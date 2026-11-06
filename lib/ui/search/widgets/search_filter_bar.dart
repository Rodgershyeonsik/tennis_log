import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../search_filter_labels.dart';
import '../search_notifier.dart';
import '../search_providers.dart';
import '../sheets/filter_sheet.dart';
import '../sheets/multi_pick_sheet.dart';

/// 조회 화면 상단의 필터 바. 범위 칩, 필터 버튼, 태그 버튼이 놓인다.
class SearchFilterBar extends ConsumerWidget {
  const SearchFilterBar({super.key});

  Future<void> _openSheet(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(searchProvider.notifier);
    final applied = await showFilterSheet(
      context,
      initial: ref.read(searchProvider).filter,
    );
    if (applied != null) notifier.applyFilter(applied);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(searchProvider.select((state) => state.filter));
    final hierarchy = ref.watch(searchTagHierarchyProvider).value;
    final count = activeFilterCount(filter);
    final tagNames = [
      for (final id in filter.tagIds) ?hierarchy?.tagOf(id)?.name,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 8,
        children: [
          ActionChip(
            label: Text(searchScopeLabel(filter.scope)),
            onPressed: () => _openSheet(context, ref),
          ),
          ActionChip(
            avatar: const Icon(Icons.tune),
            label: Text(count == 0 ? '필터' : '필터 $count'),
            onPressed: () => _openSheet(context, ref),
          ),
          Flexible(
            child: FilterChip(
              label: Text(
                tagFilterLabel(tagNames),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              selected: filter.tagIds.isNotEmpty,
              onSelected: (_) => showTagPickerSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
