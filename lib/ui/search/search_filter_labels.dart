import '../../data/db/enums.dart';
import '../../domain/search/search_filter.dart';
import '../core/formatters.dart';
import '../core/labels.dart';

extension PeriodPresetLabel on PeriodPreset {
  String get label => switch (this) {
    PeriodPreset.oneMonth => '1개월',
    PeriodPreset.threeMonths => '3개월',
    PeriodPreset.sixMonths => '6개월',
    PeriodPreset.thisYear => '올해',
  };
}

/// 범위 칩의 표기. 예: `전체`, `최근 3개월`, `최근 10세션`, `26/7/1 – 26/9/30`
String searchScopeLabel(SearchScope scope) {
  return switch (scope) {
    SearchScopeAll() => '전체',
    SearchScopePreset(preset: PeriodPreset.thisYear) => '올해',
    SearchScopePreset(:final preset) => '최근 ${preset.label}',
    SearchScopeCustom(:final start, :final end) =>
      '${Formatters.shortDate(start)} – ${Formatters.shortDate(end)}',
    SearchScopeRecentSessions(:final count) => '최근 $count세션',
  };
}

/// 필터 시트와 필터 바의 평가 표기.
String evaluationFilterLabel(MemoEvaluation value) {
  return switch (value) {
    MemoEvaluation.good => 'good',
    MemoEvaluation.bad => 'bad',
    MemoEvaluation.question => '?',
    MemoEvaluation.none => 'none',
  };
}

String indoorFilterLabel(bool isIndoor) => isIndoor ? '실내' : '야외';

String conditionFilterLabel(int? score) {
  return score == null ? '기록 없음' : conditionLabel(score);
}

String cueAppliedFilterLabel(CueApplied? value) => value?.label ?? '기록 없음';

/// 필터 시트 맨 위의 칩 하나.
class ActiveFilter {
  const ActiveFilter(this.label, this.removed);

  final String label;

  /// 이 칩을 해제한 뒤의 조건.
  final SearchFilter removed;
}

/// [filter]의 조건을 필터 시트의 순서대로 칩으로 푼다. 태그는 태그 시트에 있으므로
/// 뺀다. 범위는 기본값(전체)이 아닐 때만 나오고, 해제하면 전체로 돌아간다.
///
/// "됨", "기록 없음"은 칩 하나만 봐서는 무슨 필터인지 알 수 없어서 앞에 이름을
/// 붙인다.
List<ActiveFilter> activeFilters(
  SearchFilter filter, {
  required String Function(int placeId) placeName,
}) {
  Iterable<ActiveFilter> chipsOf<T>(
    Iterable<T> order,
    Set<T> selected,
    String Function(T) labelOf,
    SearchFilter Function(Set<T> remaining) copyWith,
  ) {
    return order
        .where(selected.contains)
        .map(
          (value) => ActiveFilter(
            labelOf(value),
            copyWith(selected.difference({value})),
          ),
        );
  }

  return [
    if (filter.scope is! SearchScopeAll)
      ActiveFilter(
        searchScopeLabel(filter.scope),
        filter.copyWith(scope: const SearchScope.all()),
      ),
    ...chipsOf(
      MemoEvaluation.values,
      filter.evaluations,
      evaluationFilterLabel,
      (rest) => filter.copyWith(evaluations: rest),
    ),
    ...chipsOf(
      SessionType.values,
      filter.sessionTypes,
      (value) => value.label,
      (rest) => filter.copyWith(sessionTypes: rest),
    ),
    ...chipsOf(
      SurfaceType.values,
      filter.surfaces,
      (value) => value.label,
      (rest) => filter.copyWith(surfaces: rest),
    ),
    ...chipsOf(
      const [true, false],
      filter.indoorOptions,
      indoorFilterLabel,
      (rest) => filter.copyWith(indoorOptions: rest),
    ),
    ...chipsOf(
      filter.placeIds,
      filter.placeIds,
      placeName,
      (rest) => filter.copyWith(placeIds: rest),
    ),
    ...chipsOf(
      const [1, 2, 3, null],
      filter.conditionScores,
      (value) => '컨디션 ${conditionFilterLabel(value)}',
      (rest) => filter.copyWith(conditionScores: rest),
    ),
    ...chipsOf(
      const [...CueApplied.values, null],
      filter.cueApplied,
      (value) => '큐 ${cueAppliedFilterLabel(value)}',
      (rest) => filter.copyWith(cueApplied: rest),
    ),
  ];
}

/// 태그 버튼의 표기. 예: `태그`, `태그: 서브, 리턴`, `태그: 서브, 리턴 외 1`
String tagFilterLabel(List<String> names) {
  const shown = 2;
  if (names.isEmpty) return '태그';

  final head = names.take(shown).join(', ');
  final rest = names.length - shown;
  return rest > 0 ? '태그: $head 외 $rest' : '태그: $head';
}

/// 필터 버튼에 표시할 걸린 필터 개수. 범위와 태그는 따로 보이므로 세지 않는다.
int activeFilterCount(SearchFilter filter) {
  return filter.evaluations.length +
      filter.sessionTypes.length +
      filter.surfaces.length +
      filter.indoorOptions.length +
      filter.placeIds.length +
      filter.conditionScores.length +
      filter.cueApplied.length;
}
