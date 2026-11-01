import '../../data/db/enums.dart';
import 'memo_with_tags.dart';

/// 2단계에서 "완료"를 누를 때 아직 확정되지 않은 것들의 개수(02 명세 5번).
///
/// 하나라도 있으면 확인 시트를 띄우고, 시트 문구의 숫자로 쓴다.
class ReviewPending {
  const ReviewPending({
    required this.suggestedTagCount,
    required this.suggestedEvaluationCount,
    required this.unsetEvaluationCount,
  });

  factory ReviewPending.of(List<MemoWithTags> entries) {
    var tags = 0;
    var evaluations = 0;
    var unset = 0;
    for (final entry in entries) {
      tags += entry.tags.where((tag) => !tag.isConfirmed).length;
      if (entry.memo.evaluationStatus == EvaluationStatus.suggested) {
        evaluations++;
      }
      if (entry.memo.evaluation == null) unset++;
    }
    return ReviewPending(
      suggestedTagCount: tags,
      suggestedEvaluationCount: evaluations,
      unsetEvaluationCount: unset,
    );
  }

  /// 점선 태그 수. rejected는 화면에 없으므로 세지 않는다.
  final int suggestedTagCount;

  /// 점선 평가 수(none 포함).
  final int suggestedEvaluationCount;

  /// 평가를 고르지 않은(null) 메모 수. 완료하면 none으로 확정된다.
  final int unsetEvaluationCount;

  bool get isEmpty =>
      suggestedTagCount == 0 &&
      suggestedEvaluationCount == 0 &&
      unsetEvaluationCount == 0;
}
