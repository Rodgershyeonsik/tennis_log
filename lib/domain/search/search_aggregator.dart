import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';
import 'search_models.dart';
import 'tag_hierarchy.dart';

part 'search_aggregator.freezed.dart';

/// 메모 탭의 정렬.
enum MemoSort { newest, oldest }

/// 태그 통계 탭의 정렬.
enum TagStatSort { count, good, bad, question }

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

/// 태그 통계의 행 하나.
@freezed
abstract class TagStatRow with _$TagStatRow {
  const factory TagStatRow({
    required int tagId,
    required String name,
    required TagCategory category,

    /// 자기 자신 또는 자손이 붙은 메모 수. 같은 메모는 한 번만 센다.
    required int count,

    /// 이 태그 자체가 붙은 메모 수.
    required int directCount,
    required EvaluationCounts evaluations,

    /// 결과에 등장한 자식들.
    required List<TagStatRow> children,
  }) = _TagStatRow;
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

  /// 최상위 태그의 통계 행. 자식은 부모 행의 [TagStatRow.children]에만 나온다.
  ///
  /// [category]는 최상위 태그의 카테고리로 거르고, null이면 전체다.
  static List<TagStatRow> tagStats(
    List<SearchMemo> memos,
    TagHierarchy hierarchy, {
    TagCategory? category,
    TagStatSort sort = TagStatSort.count,
  }) {
    final memosByTag = _memosByTag(memos);

    TagStatRow? rowOf(SearchTag tag) {
      final ids = hierarchy.withDescendants(tag.id);
      final tagMemos = memos.where((memo) => memo.tagIds.any(ids.contains));
      if (tagMemos.isEmpty) return null;

      return TagStatRow(
        tagId: tag.id,
        name: tag.name,
        category: tag.category,
        count: tagMemos.length,
        directCount: memosByTag[tag.id]?.length ?? 0,
        evaluations: EvaluationCounts.of(tagMemos),
        children: _sorted(
          hierarchy.childrenOf(tag.id).map(rowOf).nonNulls,
          sort,
        ),
      );
    }

    return _sorted(
      hierarchy.roots
          .where((tag) => category == null || tag.category == category)
          .map(rowOf)
          .nonNulls,
      sort,
    );
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

  static List<TagStatRow> _sorted(Iterable<TagStatRow> rows, TagStatSort sort) {
    int keyOf(TagStatRow row) => switch (sort) {
      TagStatSort.count => row.count,
      TagStatSort.good => row.evaluations.good,
      TagStatSort.bad => row.evaluations.bad,
      TagStatSort.question => row.evaluations.question,
    };

    return rows.toList()..sort((a, b) {
      final byKey = keyOf(b).compareTo(keyOf(a));
      if (byKey != 0) return byKey;

      final byCount = b.count.compareTo(a.count);
      return byCount != 0 ? byCount : a.name.compareTo(b.name);
    });
  }
}
