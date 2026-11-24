import 'dart:math';

import '../../data/db/enums.dart';
import 'search_aggregator.dart';
import 'search_models.dart';
import 'tag_hierarchy.dart';

/// 전체 메모에 달린 태그의 정렬.
enum TagUsageSort { count, good, bad }

/// 추이 차트의 열 하나. 해당하는 메모가 없는 세션은 건수가 모두 0이다.
typedef SessionTrendItem = ({
  SearchSession session,
  EvaluationCounts evaluations,
});

/// 태그 통계 탭의 집계.
///
/// 받은 메모 전체에서 세션 목록을 구하고, 그중 차트 태그가 붙은 메모만
/// [chartMemos]로 추린다. 차트와 같이 달린 태그는 모두 [chartMemos]로 계산한다.
class SearchStats {
  /// `memos`는 평가·태그로 거르지 않은 메모여야 한다(`SearchFilter.sessionOnly`).
  /// `chartTagId`가 null이면 메모를 거르지 않는다.
  SearchStats({
    required this._memos,
    required this._hierarchy,
    this._chartTagId,
  });

  static const _usageCategories = [
    TagCategory.technique,
    TagCategory.form,
    TagCategory.situation,
  ];

  final List<SearchMemo> _memos;
  final TagHierarchy _hierarchy;
  final int? _chartTagId;

  /// 차트 태그 또는 그 자손이 붙은 메모.
  late final List<SearchMemo> chartMemos = _findChartMemos();

  /// 세션별 평가 건수. 오래된 세션이 앞이다.
  late final List<SessionTrendItem> sessions = _buildSessions();

  /// 세션이 없으면 null이다.
  DateTime? get firstDate => sessions.firstOrNull?.session.date;

  DateTime? get lastDate => sessions.lastOrNull?.session.date;

  /// 세로축 최대값. 절반 눈금이 정수가 되도록 2 이상의 짝수로 맞춘다.
  int get axisMax {
    final highest = sessions.fold(
      0,
      (value, item) => max(value, item.evaluations.total),
    );
    return max(2, highest.isOdd ? highest + 1 : highest);
  }

  int get totalMemoCount => _memos.length;

  /// [chartMemos]에 직접 붙은 태그를 카테고리별로 묶는다. 차트 태그 자신은 뺀다.
  Map<TagCategory, List<TagSummaryItem>> relatedTags() {
    final items = SearchAggregator.summarize(chartMemos, _hierarchy);
    return _grouped(
      items.where((item) => item.tagId != _chartTagId),
      TagCategory.values,
    );
  }

  /// 차트 태그와 상관없이 메모 전체에 직접 붙은 기술·폼·상황 태그.
  Map<TagCategory, List<TagSummaryItem>> usedTags(TagUsageSort sort) {
    final items = SearchAggregator.summarize(_memos, _hierarchy)
      ..sort((a, b) {
        final byKey = _sortKey(b, sort).compareTo(_sortKey(a, sort));
        if (byKey != 0) return byKey;

        final byCount = b.count.compareTo(a.count);
        return byCount != 0 ? byCount : a.name.compareTo(b.name);
      });
    return _grouped(items, _usageCategories);
  }

  /// 칩을 눌렀을 때의 메모. [chartMemos] 중 [tagId]가 직접 붙은 메모를 최신순으로
  /// 놓는다.
  List<SearchMemo> memosWithTag(int tagId) {
    return SearchAggregator.sortMemos(
      chartMemos.where((memo) => memo.tagIds.contains(tagId)).toList(),
      MemoSort.newest,
    );
  }

  /// 날짜 라벨마다 연도를 붙일지 여부. [dates]는 오래된 순이다.
  ///
  /// 두 해 이상에 걸치면 첫 날짜와 해가 바뀌는 날짜에만 붙인다.
  static List<bool> yearLabels(List<DateTime> dates) {
    if (dates.isEmpty || dates.first.year == dates.last.year) {
      return List.filled(dates.length, false);
    }
    return [
      for (var i = 0; i < dates.length; i++)
        i == 0 || dates[i].year != dates[i - 1].year,
    ];
  }

  List<SearchMemo> _findChartMemos() {
    final tagId = _chartTagId;
    if (tagId == null) return _memos;

    final ids = _hierarchy.withDescendants(tagId);
    return _memos.where((memo) => memo.tagIds.any(ids.contains)).toList();
  }

  List<SessionTrendItem> _buildSessions() {
    final sessions = {
      for (final memo in _memos) memo.session.id: memo.session,
    }.values.toList()..sort((a, b) => compareSessionsNewestFirst(b, a));

    final memosBySession = <int, List<SearchMemo>>{};
    for (final memo in chartMemos) {
      memosBySession.putIfAbsent(memo.session.id, () => []).add(memo);
    }

    return [
      for (final session in sessions)
        (
          session: session,
          evaluations: EvaluationCounts.of(
            memosBySession[session.id] ?? const [],
          ),
        ),
    ];
  }

  static int _sortKey(TagSummaryItem item, TagUsageSort sort) {
    return switch (sort) {
      TagUsageSort.count => item.count,
      TagUsageSort.good => item.evaluations.good,
      TagUsageSort.bad => item.evaluations.bad,
    };
  }

  /// [categories] 순서로 묶는다. 칩이 없는 카테고리는 뺀다.
  Map<TagCategory, List<TagSummaryItem>> _grouped(
    Iterable<TagSummaryItem> items,
    List<TagCategory> categories,
  ) {
    final byCategory = <TagCategory, List<TagSummaryItem>>{};
    for (final item in items) {
      final category = _hierarchy.tagOf(item.tagId)!.category;
      byCategory.putIfAbsent(category, () => []).add(item);
    }

    return {for (final category in categories) category: ?byCategory[category]};
  }
}
