import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';

part 'search_filter.freezed.dart';

/// 기간 프리셋. 오늘이 바뀌면 실제 날짜도 달라지므로 날짜가 아니라 이 값을 들고 있다.
enum PeriodPreset { oneMonth, threeMonths, sixMonths, thisYear }

/// 태그를 여러 개 골랐을 때의 매칭 방식.
enum TagMatchMode { any, all }

/// 조회 범위. 전체, 기간, 최근 N세션 중 하나만 고른다.
@freezed
sealed class SearchScope with _$SearchScope {
  const factory SearchScope.all() = SearchScopeAll;

  const factory SearchScope.preset(PeriodPreset preset) = SearchScopePreset;

  /// 직접 지정한 기간. 양 끝 날짜를 포함한다.
  const factory SearchScope.custom({
    required DateTime start,
    required DateTime end,
  }) = SearchScopeCustom;

  const factory SearchScope.recentSessions(int count) =
      SearchScopeRecentSessions;
}

/// 조회 조건. 모든 값의 기본은 "제한 없음"이고, 빈 집합이 제한 없음을 뜻한다.
///
/// 그룹 사이는 AND, 한 그룹 안의 여러 선택은 OR이다(태그만 [tagMatch]로 고른다).
@freezed
abstract class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    @Default(SearchScope.all()) SearchScope scope,
    @Default(<MemoEvaluation>{}) Set<MemoEvaluation> evaluations,
    @Default(<int>{}) Set<int> tagIds,
    @Default(TagMatchMode.any) TagMatchMode tagMatch,
    @Default(<SessionType>{}) Set<SessionType> sessionTypes,
    @Default(<SurfaceType>{}) Set<SurfaceType> surfaces,

    /// true = 실내, false = 야외
    @Default(<bool>{}) Set<bool> indoorOptions,
    @Default(<int>{}) Set<int> placeIds,

    /// 1~3과, "기록 없음"을 뜻하는 null
    @Default(<int?>{}) Set<int?> conditionScores,

    /// null은 "기록 없음"이다.
    @Default(<CueApplied?>{}) Set<CueApplied?> cueApplied,
  }) = _SearchFilter;
}
