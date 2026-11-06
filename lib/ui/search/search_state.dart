import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';
import '../../domain/search/search_aggregator.dart';
import '../../domain/search/search_filter.dart';

part 'search_state.freezed.dart';

/// 조회 화면의 상태. 앱을 다시 시작하면 초기값으로 돌아간다.
@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default(SearchFilter()) SearchFilter filter,
    @Default(MemoSort.newest) MemoSort memoSort,
    @Default(false) bool summaryExpanded,

    /// 요약 칩으로 좁혀 보는 태그. 필터가 아니라 결과 안에서의 보기 상태다.
    @Default(<int>{}) Set<int> summaryTagIds,

    /// 태그 선택 시트에서 펼친 분류. 시트를 다시 열어도 남아 있다.
    @Default(<TagCategory>{}) Set<TagCategory> expandedTagCategories,
  }) = _SearchState;
}
