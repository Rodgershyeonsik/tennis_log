import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/enums.dart';
import '../../domain/search/search_aggregator.dart';
import '../../domain/search/search_filter.dart';
import 'search_state.dart';

part 'search_notifier.g.dart';

/// 조회 화면의 필터와 정렬. 탭을 바꿔도 남아 있어야 해서 keepAlive다.
@Riverpod(keepAlive: true)
class SearchNotifier extends _$SearchNotifier {
  @override
  SearchState build() => const SearchState();

  /// 조건이 바뀌면 결과가 달라지므로 요약 칩으로 좁혀 본 상태도 푼다.
  void applyFilter(SearchFilter filter) {
    if (filter == state.filter) return;
    state = state.copyWith(filter: filter, summaryTagIds: const {});
  }

  void resetFilter() => applyFilter(const SearchFilter());

  /// 태그가 하나 이하면 매칭 방식은 뜻이 없으므로 기본값으로 돌려 둔다.
  void setTags(Set<int> tagIds) {
    final filter = state.filter;
    applyFilter(
      filter.copyWith(
        tagIds: tagIds,
        tagMatch: tagIds.length > 1 ? filter.tagMatch : TagMatchMode.any,
      ),
    );
  }

  void toggleTag(int tagId) {
    final tagIds = state.filter.tagIds;
    setTags(
      tagIds.contains(tagId) ? tagIds.difference({tagId}) : {...tagIds, tagId},
    );
  }

  void setTagMatch(TagMatchMode tagMatch) {
    applyFilter(state.filter.copyWith(tagMatch: tagMatch));
  }

  void toggleTagCategory(TagCategory category) {
    final expanded = state.expandedTagCategories;
    state = state.copyWith(
      expandedTagCategories: expanded.contains(category)
          ? expanded.difference({category})
          : {...expanded, category},
    );
  }

  void toggleSummaryTag(int tagId) {
    final tagIds = state.summaryTagIds;
    state = state.copyWith(
      summaryTagIds: tagIds.contains(tagId)
          ? tagIds.difference({tagId})
          : {...tagIds, tagId},
    );
  }

  void toggleSummary() {
    state = state.copyWith(summaryExpanded: !state.summaryExpanded);
  }

  void toggleMemoSort() {
    state = state.copyWith(
      memoSort: state.memoSort == MemoSort.newest
          ? MemoSort.oldest
          : MemoSort.newest,
    );
  }
}
