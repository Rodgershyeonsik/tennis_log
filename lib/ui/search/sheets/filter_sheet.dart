import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/enums.dart';
import '../../../domain/search/search_filter.dart';
import '../../core/labels.dart';
import '../../core/widgets/app_choice_chips.dart';
import '../../core/widgets/app_multi_choice_chips.dart';
import '../../core/widgets/entry_card.dart';
import '../../core/widgets/form_section.dart';
import '../search_filter_labels.dart';
import '../search_providers.dart';
import '../widgets/removable_chip_row.dart';
import 'multi_pick_sheet.dart';

/// 필터 시트. **결과 보기**를 누르면 고른 조건을 돌려주고, 그냥 닫으면 null이다.
///
/// 내비게이션 바까지 덮도록 루트 내비게이터에 띄운다. 탭 안의 내비게이터에 띄우면
/// 시트가 바 뒤로 들어간다.
Future<SearchFilter?> showFilterSheet(
  BuildContext context, {
  required SearchFilter initial,
}) {
  return showModalBottomSheet<SearchFilter>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _FilterSheet(initial: initial),
  );
}

enum _ScopeKind {
  all('전체'),
  period('기간'),
  recentSessions('최근 N세션');

  const _ScopeKind(this.label);

  final String label;

  static _ScopeKind of(SearchScope scope) {
    return switch (scope) {
      SearchScopeAll() => all,
      SearchScopePreset() || SearchScopeCustom() => period,
      SearchScopeRecentSessions() => recentSessions,
    };
  }
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet({required this.initial});

  final SearchFilter initial;

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  static const _defaultRecentCount = 10;

  /// 적용 전의 임시 조건.
  late SearchFilter _draft = widget.initial;

  /// 범위를 바꿨다가 돌아와도 고른 N이 남아 있게 따로 들고 있는다.
  late int _recentCount = switch (widget.initial.scope) {
    SearchScopeRecentSessions(:final count) => count,
    _ => _defaultRecentCount,
  };

  /// 결과를 다시 세는 동안 버튼 글자가 비지 않도록 마지막 값을 들고 있는다.
  int? _lastCount;

  void _update(SearchFilter filter) => setState(() => _draft = filter);

  void _reset() {
    setState(() {
      // 태그는 이 시트에 없으므로 보이지 않는 값을 지우지 않는다.
      _draft = SearchFilter(tagIds: _draft.tagIds, tagMatch: _draft.tagMatch);
      _recentCount = _defaultRecentCount;
    });
  }

  void _selectScopeKind(_ScopeKind? kind) {
    if (kind == null || kind == _ScopeKind.of(_draft.scope)) return;
    _update(
      _draft.copyWith(
        scope: switch (kind) {
          _ScopeKind.all => const SearchScope.all(),
          _ScopeKind.period => const SearchScope.preset(PeriodPreset.oneMonth),
          _ScopeKind.recentSessions => SearchScope.recentSessions(_recentCount),
        },
      ),
    );
  }

  void _setRecentCount(int count) {
    _recentCount = count;
    _update(_draft.copyWith(scope: SearchScope.recentSessions(count)));
  }

  /// 취소하면 지금 범위를 그대로 둔다.
  Future<void> _pickDateRange() async {
    final scope = _draft.scope;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: scope is SearchScopeCustom
          ? DateTimeRange(start: scope.start, end: scope.end)
          : null,
    );
    if (picked == null || !mounted) return;
    _update(
      _draft.copyWith(
        scope: SearchScope.custom(start: picked.start, end: picked.end),
      ),
    );
  }

  /// 장소를 고르면 표면과 실내·야외는 장소가 정하므로 고른 값을 비운다.
  void _setPlaces(Set<int> placeIds) {
    _update(
      placeIds.isEmpty
          ? _draft.copyWith(placeIds: placeIds)
          : _draft.copyWith(
              placeIds: placeIds,
              surfaces: const {},
              indoorOptions: const {},
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(searchMatchCountProvider(_draft)).value;
    _lastCount = count ?? _lastCount;

    final places = ref.watch(searchPlacesProvider).value ?? const [];
    final placeNames = {for (final place in places) place.id: place.name};
    final active = activeFilters(
      _draft,
      placeName: (id) => placeNames[id] ?? '',
    );

    final placePicked = _draft.placeIds.isNotEmpty;
    final placeHint = placePicked ? '특정 장소를 고르면 선택할 수 없어요' : null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Column(
          children: [
            RemovableChipRow(
              chips: [
                for (final item in active)
                  RemovableChip(item.label, () => _update(item.removed)),
              ],
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  _buildScope(),
                  const EntryGap(),
                  FormSection(
                    label: '평가',
                    child: AppMultiChoiceChips<MemoEvaluation>(
                      chips: {
                        for (final value in MemoEvaluation.values)
                          value: evaluationFilterLabel(value),
                      },
                      selected: _draft.evaluations,
                      onChanged: (value) =>
                          _update(_draft.copyWith(evaluations: value)),
                    ),
                  ),
                  const EntryGap(),
                  FormSection(
                    label: '세션 유형',
                    child: AppMultiChoiceChips<SessionType>(
                      chips: {
                        for (final value in SessionType.values)
                          value: value.label,
                      },
                      selected: _draft.sessionTypes,
                      onChanged: (value) =>
                          _update(_draft.copyWith(sessionTypes: value)),
                    ),
                  ),
                  const EntryGap(),
                  FormSection(
                    label: '코트 표면',
                    hint: placeHint,
                    child: AppMultiChoiceChips<SurfaceType>(
                      enabled: !placePicked,
                      chips: {
                        for (final value in SurfaceType.values)
                          value: value.label,
                      },
                      selected: _draft.surfaces,
                      onChanged: (value) =>
                          _update(_draft.copyWith(surfaces: value)),
                    ),
                  ),
                  const EntryGap(),
                  FormSection(
                    label: '실내·야외',
                    hint: placeHint,
                    child: AppMultiChoiceChips<bool>(
                      enabled: !placePicked,
                      chips: {
                        for (final value in const [true, false])
                          value: indoorFilterLabel(value),
                      },
                      selected: _draft.indoorOptions,
                      onChanged: (value) =>
                          _update(_draft.copyWith(indoorOptions: value)),
                    ),
                  ),
                  const EntryGap(),
                  _buildPlaces(),
                  const EntryGap(),
                  FormSection(
                    label: '컨디션',
                    child: AppMultiChoiceChips<int?>(
                      chips: {
                        for (final value in const [1, 2, 3, null])
                          value: conditionFilterLabel(value),
                      },
                      selected: _draft.conditionScores,
                      onChanged: (value) =>
                          _update(_draft.copyWith(conditionScores: value)),
                    ),
                  ),
                  const EntryGap(),
                  FormSection(
                    label: '큐 적용',
                    child: AppMultiChoiceChips<CueApplied?>(
                      chips: {
                        for (final value in const [...CueApplied.values, null])
                          value: cueAppliedFilterLabel(value),
                      },
                      selected: _draft.cueApplied,
                      onChanged: (value) =>
                          _update(_draft.copyWith(cueApplied: value)),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  spacing: 8,
                  children: [
                    TextButton(onPressed: _reset, child: const Text('초기화')),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(_draft),
                        child: Text('결과 보기 ${_lastCount ?? ''}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScope() {
    final scope = _draft.scope;
    final kind = _ScopeKind.of(scope);

    return FormSection(
      label: '범위',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          AppChoiceChips<_ScopeKind>(
            chips: [
              for (final value in _ScopeKind.values)
                AppChip(value, value.label),
            ],
            value: kind,
            onChanged: _selectScopeKind,
          ),
          if (kind == _ScopeKind.period)
            AppChoiceChips<PeriodPreset>(
              chips: [
                for (final value in PeriodPreset.values)
                  AppChip(value, value.label),
              ],
              value: scope is SearchScopePreset ? scope.preset : null,
              // 기간은 비울 수 없다. 같은 칩을 다시 눌러도 그대로 둔다.
              onChanged: (value) {
                if (value == null) return;
                _update(_draft.copyWith(scope: SearchScope.preset(value)));
              },
              trailing: ChoiceChip(
                label: Text(
                  scope is SearchScopeCustom
                      ? searchScopeLabel(scope)
                      : '직접 지정',
                ),
                selected: scope is SearchScopeCustom,
                onSelected: (_) => _pickDateRange(),
              ),
            ),
          if (kind == _ScopeKind.recentSessions)
            _RecentCountStepper(
              value: _recentCount,
              onChanged: _setRecentCount,
            ),
        ],
      ),
    );
  }

  Widget _buildPlaces() {
    return FormSection(
      label: '특정 장소',
      child: ActionChip(
        avatar: const Icon(Icons.add),
        label: const Text('장소 선택'),
        onPressed: () => showPlaceFilterSheet(
          context,
          selected: _draft.placeIds,
          onChanged: _setPlaces,
        ),
      ),
    );
  }
}

class _RecentCountStepper extends StatelessWidget {
  const _RecentCountStepper({required this.value, required this.onChanged});

  static const _min = 1;
  static const _max = 50;

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.outlined(
          tooltip: '세션 수 줄이기',
          onPressed: value > _min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 80,
          child: Text(
            '$value세션',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton.outlined(
          tooltip: '세션 수 늘리기',
          onPressed: value < _max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
