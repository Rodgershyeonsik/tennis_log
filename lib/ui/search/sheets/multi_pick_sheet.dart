import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../../domain/search/search_filter.dart';
import '../../../domain/search/search_models.dart';
import '../../../domain/search/tag_hierarchy.dart';
import '../../core/labels.dart';
import '../../core/widgets/app_choice_chips.dart';
import '../search_notifier.dart';
import '../search_providers.dart';
import '../widgets/removable_chip_row.dart';

/// 태그 선택 시트. 분류 줄을 누르면 그 자리에서 태그 칩이 펼쳐진다. 보관된 태그는
/// 뺀다. 고르는 즉시 조회 결과에 적용한다.
Future<void> showTagPickerSheet(BuildContext context) {
  return _showSheet(context, const _TagPickerSheet());
}

/// 필터의 장소 선택 시트. 이름 순 목록이고 골라도 닫히지 않는다.
Future<void> showPlaceFilterSheet(
  BuildContext context, {
  required Set<int> selected,
  required ValueChanged<Set<int>> onChanged,
}) {
  return _showSheet(
    context,
    _PlacePickerSheet(selected: selected, onChanged: onChanged),
  );
}

Future<void> _showSheet(BuildContext context, Widget sheet) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => sheet,
  );
}

Set<int> _toggled(Set<int> selected, int id) {
  return selected.contains(id) ? selected.difference({id}) : {...selected, id};
}

/// 제목, 검색칸, 목록으로 된 시트의 틀.
class _PickSheetFrame extends StatelessWidget {
  const _PickSheetFrame({
    required this.title,
    required this.hintText,
    required this.onQueryChanged,
    required this.body,
    this.action,
    this.picked,
    this.header,
  });

  final String title;
  final String hintText;
  final ValueChanged<String> onQueryChanged;

  /// 제목 줄의 완료 버튼 왼쪽.
  final Widget? action;

  /// 제목 줄 아래의 고른 조건 줄.
  final Widget? picked;

  /// 검색칸 아래에 고정되는 줄.
  final Widget? header;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title, style: theme.textTheme.titleMedium),
                      ),
                      ?action,
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('완료'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ?picked,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  TextField(
                    decoration: InputDecoration(
                      hintText: hintText,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: onQueryChanged,
                  ),
                  if (header case final header?) ...[
                    const SizedBox(height: 8),
                    header,
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 남는 높이만큼만 쓴다. 고정 비율로 잡으면 키보드가 올라왔을 때
            // 시트가 화면을 넘쳐서 bottom overflow가 난다.
            Flexible(child: body),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TagPickerSheet extends ConsumerStatefulWidget {
  const _TagPickerSheet();

  @override
  ConsumerState<_TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends ConsumerState<_TagPickerSheet> {
  static const _indent = 20.0;

  String _query = '';

  Set<int> get _selected => ref.read(searchProvider).filter.tagIds;
  SearchNotifier get _notifier => ref.read(searchProvider.notifier);

  Widget _tagChip(SearchTag tag, TagHierarchy hierarchy) {
    final selected = _selected.contains(tag.id);
    // 부모를 고르면 자식도 조회에 포함되므로 흐린 체크로 알려준다.
    final implied =
        !selected && hierarchy.ancestorsOf(tag.id).any(_selected.contains);

    return FilterChip(
      label: Text(tag.name),
      selected: selected,
      avatar: implied
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.outlineVariant,
            )
          : null,
      onSelected: (_) => _notifier.toggleTag(tag.id),
    );
  }

  Widget _chipRow(
    Iterable<SearchTag> tags,
    TagHierarchy hierarchy, {
    int depth = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: (depth - 1).clamp(0, depth) * _indent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          if (depth > 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Icon(
                Icons.subdirectory_arrow_right,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [for (final tag in tags) _tagChip(tag, hierarchy)],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final selected = state.filter.tagIds;
    final hierarchy = ref.watch(searchTagHierarchyProvider).value;
    final tags =
        hierarchy?.tags.where((tag) => !tag.isArchived).toList() ??
        <SearchTag>[];
    final query = _query.trim().toLowerCase();
    final searching = query.isNotEmpty;

    final Widget body;
    if (hierarchy == null) {
      body = const SizedBox.shrink();
    } else if (searching) {
      // 검색은 분류 구분 없이 일치하는 태그만 보여준다.
      final matches =
          tags.where((tag) => tag.name.toLowerCase().contains(query)).toList()
            ..sort((a, b) => a.name.compareTo(b.name));
      body = matches.isEmpty
          ? const _EmptyText('일치하는 태그가 없어요.')
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _chipRow(matches, hierarchy),
            );
    } else {
      final groups = [
        for (final category in TagCategory.values)
          _categoryGroup(
            category,
            tags.where((tag) => tag.category == category).toList(),
            hierarchy,
          ),
      ].where((group) => group.isNotEmpty).toList();

      body = ListView(
        shrinkWrap: true,
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            if (i > 0) const Divider(indent: 16, endIndent: 16),
            ...groups[i],
          ],
        ],
      );
    }

    return _PickSheetFrame(
      title: '태그 선택',
      hintText: '태그 검색',
      onQueryChanged: (value) => setState(() => _query = value),
      action: selected.isEmpty
          ? null
          : TextButton(
              onPressed: () => _notifier.setTags(const {}),
              child: const Text('모두 해제'),
            ),
      picked: RemovableChipRow(
        chips: [
          for (final id in selected)
            RemovableChip(
              hierarchy?.tagOf(id)?.name ?? '',
              () => _notifier.toggleTag(id),
            ),
        ],
      ),
      header: selected.length > 1
          ? AppChoiceChips<TagMatchMode>(
              chips: const [
                AppChip(TagMatchMode.any, '하나라도'),
                AppChip(TagMatchMode.all, '모두'),
              ],
              value: state.filter.tagMatch,
              // 매칭 방식은 비울 수 없다. 같은 칩을 다시 눌러도 그대로 둔다.
              onChanged: (value) {
                if (value != null) _notifier.setTagMatch(value);
              },
            )
          : null,
      body: body,
    );
  }

  List<Widget> _categoryGroup(
    TagCategory category,
    List<SearchTag> tags,
    TagHierarchy hierarchy,
  ) {
    if (tags.isEmpty) return const [];
    final expanded = ref
        .read(searchProvider)
        .expandedTagCategories
        .contains(category);

    return [
      _CategoryHeader(
        title: category.label,
        selectedNames: [
          for (final tag in tags)
            if (_selected.contains(tag.id)) tag.name,
        ]..sort(),
        expanded: expanded,
        onTap: () => _notifier.toggleTagCategory(category),
      ),
      if (expanded)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final row in hierarchy.chipRows(tags))
                _chipRow(row.tags, hierarchy, depth: row.depth),
            ],
          ),
        ),
    ];
  }
}

/// 분류 줄. 접혀 있으면 고른 태그의 이름을 보여준다. 펼치면 칩으로 보이므로 뺀다.
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.title,
    required this.selectedNames,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final List<String> selectedNames;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      title: Row(
        spacing: 8,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!expanded && selectedNames.isNotEmpty)
            Expanded(
              child: Text(
                selectedNames.join(', '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.primary,
                ),
              ),
            ),
        ],
      ),
      trailing: Icon(
        expanded ? Icons.expand_less : Icons.expand_more,
        color: scheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

class _PlacePickerSheet extends ConsumerStatefulWidget {
  const _PlacePickerSheet({required this.selected, required this.onChanged});

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  ConsumerState<_PlacePickerSheet> createState() => _PlacePickerSheetState();
}

class _PlacePickerSheetState extends ConsumerState<_PlacePickerSheet> {
  String _query = '';
  late Set<int> _selected = widget.selected;

  void _toggle(int id) {
    setState(() => _selected = _toggled(_selected, id));
    widget.onChanged(_selected);
  }

  Widget _row(Place place) {
    return ListTile(
      title: Text(place.name),
      subtitle: Text(
        placeDetailLabel(isIndoor: place.isIndoor, surface: place.surface),
      ),
      trailing: _selected.contains(place.id)
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () => _toggle(place.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(searchPlacesProvider).value ?? const <Place>[];
    final query = _query.trim().toLowerCase();
    final matches = places.where(
      (place) => place.name.toLowerCase().contains(query),
    );

    return _PickSheetFrame(
      title: '장소 선택',
      hintText: '장소 검색',
      onQueryChanged: (value) => setState(() => _query = value),
      body: matches.isEmpty
          ? const _EmptyText('일치하는 장소가 없어요.')
          : ListView(
              shrinkWrap: true,
              children: [for (final place in matches) _row(place)],
            ),
    );
  }
}
