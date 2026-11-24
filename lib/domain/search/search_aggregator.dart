import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';
import 'search_models.dart';
import 'tag_hierarchy.dart';

part 'search_aggregator.freezed.dart';

/// 메모 탭의 정렬.
enum MemoSort { newest, oldest }

/// 평가별 메모 수.
@freezed
abstract class EvaluationCounts with _$EvaluationCounts {
  const EvaluationCounts._();

  const factory EvaluationCounts({
    @Default(0) int good,
    @Default(0) int bad,
    @Default(0) int question,
    @Default(0) int none,
  }) = _EvaluationCounts;

  /// 확정 평가가 없는 메모는 없음으로 센다. 평가별 건수의 합이 메모 수와
  /// 항상 같아야 하기 때문이다.
  factory EvaluationCounts.of(Iterable<SearchMemo> memos) {
    int count(bool Function(MemoEvaluation?) test) {
      return memos.where((memo) => test(memo.evaluation)).length;
    }

    return EvaluationCounts(
      good: count((e) => e == MemoEvaluation.good),
      bad: count((e) => e == MemoEvaluation.bad),
      question: count((e) => e == MemoEvaluation.question),
      none: count((e) => e == null || e == MemoEvaluation.none),
    );
  }

  int get total => good + bad + question + none;
}

/// 메모 탭 요약줄의 칩 하나.
@freezed
abstract class TagSummaryItem with _$TagSummaryItem {
  const factory TagSummaryItem({
    required int tagId,
    required String name,
    required int count,
    required EvaluationCounts evaluations,
  }) = _TagSummaryItem;
}

/// 조회 결과 메모의 정렬과 집계.
abstract final class SearchAggregator {
  /// 세션은 [sort] 방향으로, 같은 세션의 메모는 방향과 상관없이 쓴 순서로 놓는다.
  static List<SearchMemo> sortMemos(List<SearchMemo> memos, MemoSort sort) {
    return [...memos]..sort((a, b) {
      final bySession = compareSessionsNewestFirst(a.session, b.session);
      if (bySession != 0) {
        return sort == MemoSort.newest ? bySession : -bySession;
      }

      final byOrder = a.orderIndex.compareTo(b.orderIndex);
      return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
    });
  }

  /// 메모에 실제로 붙은 태그별 건수. 부모로 합산하지 않는다.
  static List<TagSummaryItem> summarize(
    List<SearchMemo> memos,
    TagHierarchy hierarchy,
  ) {
    final items = <TagSummaryItem>[];
    _memosByTag(memos).forEach((tagId, tagMemos) {
      final tag = hierarchy.tagOf(tagId);
      if (tag == null) return;
      items.add(
        TagSummaryItem(
          tagId: tagId,
          name: tag.name,
          count: tagMemos.length,
          evaluations: EvaluationCounts.of(tagMemos),
        ),
      );
    });

    return items..sort((a, b) {
      final byCount = b.count.compareTo(a.count);
      return byCount != 0 ? byCount : a.name.compareTo(b.name);
    });
  }

  /// 요약 칩으로 좁혀 본 메모. [tagIds] 중 하나라도 직접 붙은 메모만 남긴다.
  ///
  /// 어떤 메모에도 없는 태그는 무시한다. 일지를 고쳐서 태그가 사라지면 끌 칩이
  /// 없어지므로, 그 태그 때문에 목록이 비면 안 된다.
  static List<SearchMemo> narrowByTags(
    List<SearchMemo> memos,
    Set<int> tagIds,
  ) {
    final narrowed = memos.where((memo) => memo.tagIds.any(tagIds.contains));
    return narrowed.isEmpty ? memos : narrowed.toList();
  }

  static Map<int, List<SearchMemo>> _memosByTag(List<SearchMemo> memos) {
    final byTag = <int, List<SearchMemo>>{};
    for (final memo in memos) {
      for (final tagId in memo.tagIds) {
        byTag.putIfAbsent(tagId, () => []).add(memo);
      }
    }
    return byTag;
  }
}
