import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/enums.dart';
import '../domain/auto_tagger.dart';
import 'tag_repository.dart';

part 'auto_tag_applier.g.dart';

/// 저장 버튼을 눌렀을 때 자동 태그·평가 추천을 DB에 반영한 결과.
class AutoTagApplyResult {
  const AutoTagApplyResult({
    required this.processedMemoCount,
    required this.suggestedTagCount,
    required this.suggestedEvaluationCount,
  });

  /// 내용이 바뀌어서 다시 처리한 메모 수.
  final int processedMemoCount;

  /// 반영 후 **세션 전체**에서 확인이 필요한(suggested) 태그 수.
  ///
  /// 이번에 새로 붙은 것만 세지 않는 이유는, 이 값이 저장 후 하단 시트의
  /// "추천 태그 N개"(명세 4번)에 쓰이고 그 시트가 2단계 화면으로 보내기 때문이다.
  /// 2단계에서 확인해야 할 점선 태그 수와 숫자가 맞아야 한다.
  final int suggestedTagCount;

  /// 반영 후 세션 전체에서 확인이 필요한(suggested) 평가 수.
  final int suggestedEvaluationCount;
}

/// 명세 6번의 **"저장 시 적용 규칙"** 담당.
///
/// 태그와 평가를 실제로 계산하는 건 순수 엔진인 [AutoTagger]이고, 이 클래스는
/// 그 결과를 기존 DB 상태와 합치는 일만 한다:
///
/// - 내용이 `lastTaggedContent`와 다른 메모만 다시 처리한다.
/// - manual 태그와 rejected 태그는 건드리지 않는다.
/// - 내용이 바뀐 메모의 기존 auto 태그 중 새 결과에 없는 것은 지운다.
/// - evaluationStatus가 confirmed인 평가는 절대 덮어쓰지 않는다.
class AutoTagApplier {
  AutoTagApplier(this._db, this._tagRepository);

  final AppDatabase _db;
  final TagRepository _tagRepository;

  /// 세션의 모든 메모에 자동 태그·평가 추천을 반영한다.
  Future<AutoTagApplyResult> applyToSession(int sessionId) async {
    // 사전은 세션 하나에 한 번만 읽고, 엔진도 한 번만 만들어 메모마다 재사용한다.
    final tagger = AutoTagger(await _tagRepository.loadDictionary());

    final processed = await _db.transaction(() async {
      final memos =
          await (_db.select(_db.memos)
                ..where((t) => t.sessionId.equals(sessionId))
                ..orderBy([
                  (t) => OrderingTerm.asc(t.orderIndex),
                  (t) => OrderingTerm.asc(t.id),
                ]))
              .get();

      var count = 0;
      for (final memo in memos) {
        // 내용이 그대로면 다시 추천하지 않는다. 사용자가 2단계에서 손본 결과를
        // 저장 때마다 되돌려 놓지 않으려는 규칙이다.
        if (memo.content == memo.lastTaggedContent) continue;

        await _applyToMemo(memo, tagger);
        count++;
      }
      return count;
    });

    return AutoTagApplyResult(
      processedMemoCount: processed,
      suggestedTagCount: await _countSuggestedTags(sessionId),
      suggestedEvaluationCount: await _countSuggestedEvaluations(sessionId),
    );
  }

  Future<void> _applyToMemo(Memo memo, AutoTagger tagger) async {
    final analysis = tagger.analyze(memo.content);

    final existing = await (_db.select(
      _db.memoTags,
    )..where((t) => t.memoId.equals(memo.id))).get();
    final existingByTagId = {for (final link in existing) link.tagId: link};

    // 1) 새 결과를 반영한다.
    final matchedTagIds = <int>{};
    for (final suggested in analysis.tags) {
      matchedTagIds.add(suggested.tagId);
      final current = existingByTagId[suggested.tagId];

      if (current == null) {
        await _db
            .into(_db.memoTags)
            .insert(
              MemoTagsCompanion.insert(
                memoId: memo.id,
                tagId: suggested.tagId,
                source: MemoTagSource.auto,
                status: suggested.status,
              ),
            );
        continue;
      }

      // 사용자가 직접 붙인 태그(manual), 사용자가 지운 태그(rejected),
      // 사용자가 확인한 태그(confirmed)는 그대로 둔다. confirmed를 다시
      // suggested로 내리면 이미 끝낸 확인 작업이 되살아난다.
      if (current.source == MemoTagSource.manual) continue;
      if (current.status != MemoTagStatus.suggested) continue;

      // 남은 경우는 suggested인 auto 태그다. 새 결과가 confirmed면 올려 준다
      // (ambiguous 표현에 걸렸던 메모가 sure 표현을 담게 수정된 경우).
      if (suggested.status != MemoTagStatus.confirmed) continue;
      await _setStatus(memo.id, suggested.tagId, MemoTagStatus.confirmed);
    }

    // 2) 새 결과에 없는 기존 auto 태그는 지운다.
    for (final link in existing) {
      if (link.source != MemoTagSource.auto) continue;
      // rejected는 "사용자가 지웠다"는 기억이라 남겨 둔다. 지우면 다음 저장
      // 때 같은 태그가 다시 붙는다.
      if (link.status == MemoTagStatus.rejected) continue;
      if (matchedTagIds.contains(link.tagId)) continue;

      await (_db.delete(_db.memoTags)..where(
            (t) => t.memoId.equals(memo.id) & t.tagId.equals(link.tagId),
          ))
          .go();
    }

    // 3) 평가. confirmed는 건드리지 않고, 비어 있거나 suggested면 새 결과로 바꾼다.
    //    (새 결과가 없으면 비운다.)
    final keepEvaluation = memo.evaluationStatus == EvaluationStatus.confirmed;

    await (_db.update(_db.memos)..where((t) => t.id.equals(memo.id))).write(
      MemosCompanion(
        evaluation: keepEvaluation
            ? const Value.absent()
            : Value(analysis.evaluation),
        evaluationStatus: keepEvaluation
            ? const Value.absent()
            : Value(
                analysis.evaluation == null ? null : EvaluationStatus.suggested,
              ),
        // 4) 이 내용으로 추천을 돌렸다고 표시한다.
        lastTaggedContent: Value(memo.content),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _setStatus(int memoId, int tagId, MemoTagStatus status) {
    return (_db.update(_db.memoTags)
          ..where((t) => t.memoId.equals(memoId) & t.tagId.equals(tagId)))
        .write(MemoTagsCompanion(status: Value(status)));
  }

  Future<int> _countSuggestedTags(int sessionId) async {
    final memoIds = _db.selectOnly(_db.memos)
      ..addColumns([_db.memos.id])
      ..where(_db.memos.sessionId.equals(sessionId));

    final count = _db.memoTags.tagId.count();
    return (_db.selectOnly(_db.memoTags)
          ..addColumns([count])
          ..where(
            _db.memoTags.memoId.isInQuery(memoIds) &
                _db.memoTags.status.equalsValue(MemoTagStatus.suggested),
          ))
        .map((row) => row.read(count)!)
        .getSingle();
  }

  Future<int> _countSuggestedEvaluations(int sessionId) async {
    final count = _db.memos.id.count();
    return (_db.selectOnly(_db.memos)
          ..addColumns([count])
          ..where(
            _db.memos.sessionId.equals(sessionId) &
                _db.memos.evaluationStatus.equalsValue(
                  EvaluationStatus.suggested,
                ),
          ))
        .map((row) => row.read(count)!)
        .getSingle();
  }
}

@riverpod
AutoTagApplier autoTagApplier(Ref ref) {
  return AutoTagApplier(
    ref.watch(appDatabaseProvider),
    ref.watch(tagRepositoryProvider),
  );
}
