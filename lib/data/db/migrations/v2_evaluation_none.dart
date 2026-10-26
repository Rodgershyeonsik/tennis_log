import 'package:drift/drift.dart';

import '../../../domain/tagging/evaluation_suggester.dart';
import '../enums.dart';

/// 스키마 1 → 2. 평가 값 `none`(평가 없음)을 들이면서 기존 데이터를 맞춘다
/// (명세 `02_tag_review_completion.md` 3번).
///
/// 테이블 구조는 바뀌지 않는다(텍스트 enum에 값 하나 추가). 바뀌는 건 데이터다.
/// 이 작업 뒤로 **`tagReviewed = true`인 세션에는 점선(suggested)도, 고르지
/// 않은 평가(null)도 없다**는 불변식이 선다.
///
/// **SQL을 직접 쓴다.** drift의 테이블 API로 쓰면 나중에 테이블 정의가 바뀌었을
/// 때 이 옛 마이그레이션의 의미까지 함께 바뀐다. 마이그레이션은 v1 시점의
/// 스키마를 기준으로 고정돼 있어야 한다.
///
/// 세 단계가 한 덩어리로 반영돼야 하므로 호출하는 쪽에서 트랜잭션으로 감싼다.
Future<void> migrateToV2EvaluationNone(GeneratedDatabase db) async {
  final suggested = EvaluationStatus.suggested.name;
  final confirmed = EvaluationStatus.confirmed.name;
  final none = MemoEvaluation.none.name;

  // 1) 점선이 남은 확인 완료 일지를 "태그 확인 전"으로 되돌린다.
  //    사용자가 2단계를 다시 거쳐 직접 고르게 한다.
  await db.customUpdate(
    'UPDATE sessions SET tag_reviewed = 0 '
    'WHERE tag_reviewed = 1 AND ('
    '  EXISTS (SELECT 1 FROM memos m '
    '          WHERE m.session_id = sessions.id AND m.evaluation_status = ?1)'
    '  OR EXISTS (SELECT 1 FROM memo_tags mt JOIN memos m ON m.id = mt.memo_id '
    '             WHERE m.session_id = sessions.id AND mt.status = ?2)'
    ')',
    variables: [
      Variable<String>(suggested),
      Variable<String>(MemoTagStatus.suggested.name),
    ],
  );

  // 2) 확인 완료 일지에서 평가를 비워 둔 메모는 "평가 없음"으로 확정한다.
  //    사용자가 보고도 고르지 않은 것이므로 평가할 게 없다고 본다.
  //    (1번에서 되돌린 세션은 여기에 들지 않고 3번으로 간다.)
  await db.customUpdate(
    'UPDATE memos SET evaluation = ?1, evaluation_status = ?2 '
    'WHERE evaluation IS NULL '
    '  AND session_id IN (SELECT id FROM sessions WHERE tag_reviewed = 1)',
    variables: [Variable<String>(none), Variable<String>(confirmed)],
  );

  // 3) 확인 전 일지에서 추천을 한 번이라도 돌린 빈 평가 메모는 추천을 다시 돌려,
  //    none이 나오면 점선으로 넣는다. 판단 보류(null)는 그대로 둔다.
  //    lastTaggedContent가 null인 메모는 다음 저장 때 추천이 도니 건드리지 않는다.
  //    태그 추천은 다시 돌리지 않는다.
  final rows = await db
      .customSelect(
        'SELECT id, content FROM memos '
        'WHERE evaluation IS NULL AND last_tagged_content IS NOT NULL '
        '  AND session_id IN (SELECT id FROM sessions WHERE tag_reviewed = 0)',
      )
      .get();

  for (final row in rows) {
    if (suggestEvaluation(row.read<String>('content')) != MemoEvaluation.none) {
      continue;
    }
    await db.customUpdate(
      'UPDATE memos SET evaluation = ?1, evaluation_status = ?2 WHERE id = ?3',
      variables: [
        Variable<String>(none),
        Variable<String>(suggested),
        Variable<int>(row.read<int>('id')),
      ],
    );
  }
}
