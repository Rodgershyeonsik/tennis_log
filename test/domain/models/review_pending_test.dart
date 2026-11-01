import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/models/memo_with_tags.dart';
import 'package:tennis_log/domain/models/review_pending.dart';

void main() {
  var nextId = 1;

  MemoWithTags entry({
    MemoEvaluation? evaluation,
    EvaluationStatus? evaluationStatus,
    List<MemoTagStatus> tagStatuses = const [],
  }) {
    final id = nextId++;
    final now = DateTime(2026, 11, 1);
    return MemoWithTags(
      memo: Memo(
        id: id,
        sessionId: 1,
        content: '메모 $id',
        orderIndex: id,
        evaluation: evaluation,
        evaluationStatus: evaluationStatus,
        createdAt: now,
        updatedAt: now,
      ),
      tags: [
        for (final (i, status) in tagStatuses.indexed)
          MemoTagView(
            tagId: i,
            name: '태그$i',
            category: TagCategory.technique,
            source: MemoTagSource.auto,
            status: status,
          ),
      ],
    );
  }

  test('점선 태그, 점선 평가(none 포함), 빈 평가를 각각 센다', () {
    final pending = ReviewPending.of([
      entry(
        evaluation: MemoEvaluation.none,
        evaluationStatus: EvaluationStatus.suggested,
        tagStatuses: [MemoTagStatus.suggested, MemoTagStatus.confirmed],
      ),
      entry(
        evaluation: MemoEvaluation.bad,
        evaluationStatus: EvaluationStatus.suggested,
        tagStatuses: [MemoTagStatus.suggested],
      ),
      entry(),
    ]);

    expect(pending.suggestedTagCount, 2);
    expect(pending.suggestedEvaluationCount, 2);
    expect(pending.unsetEvaluationCount, 1);
    expect(pending.isEmpty, isFalse);
  });

  test('모두 확정돼 있으면 비어 있다', () {
    final pending = ReviewPending.of([
      entry(
        evaluation: MemoEvaluation.none,
        evaluationStatus: EvaluationStatus.confirmed,
        tagStatuses: [MemoTagStatus.confirmed],
      ),
    ]);

    expect(pending.isEmpty, isTrue);
  });

  test('메모가 없으면 비어 있다', () {
    expect(ReviewPending.of(const []).isEmpty, isTrue);
  });
}
