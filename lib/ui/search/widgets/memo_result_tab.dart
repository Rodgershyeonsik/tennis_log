import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/search/search_aggregator.dart';
import '../search_notifier.dart';
import '../search_providers.dart';
import 'memo_result_card.dart';
import 'tag_summary_card.dart';

/// 조회 화면의 메모 탭. 정렬과 요약 카드는 고정이고 메모 카드만 스크롤된다.
class MemoResultTab extends ConsumerWidget {
  const MemoResultTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memos = ref.watch(searchResultsProvider).value;
    final hierarchy = ref.watch(searchTagHierarchyProvider).value;
    final sort = ref.watch(searchProvider.select((state) => state.memoSort));
    final summaryExpanded = ref.watch(
      searchProvider.select((state) => state.summaryExpanded),
    );
    final summaryTagIds = ref.watch(
      searchProvider.select((state) => state.summaryTagIds),
    );
    final notifier = ref.read(searchProvider.notifier);

    if (memos == null || hierarchy == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (memos.isEmpty) return _EmptyResult(onReset: notifier.resetFilter);

    final sorted = SearchAggregator.sortMemos(
      SearchAggregator.narrowByTags(memos, summaryTagIds),
      sort,
    );
    final summary = SearchAggregator.summarize(memos, hierarchy);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: notifier.toggleMemoSort,
              icon: const Icon(Icons.swap_vert, size: 18),
              label: Text(sort == MemoSort.newest ? '최신순' : '오래된순'),
            ),
          ),
        ),
        if (summary.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TagSummaryCard(
              items: summary,
              selectedTagIds: summaryTagIds,
              expanded: summaryExpanded,
              onToggle: notifier.toggleSummary,
              onTapItem: notifier.toggleSummaryTag,
            ),
          ),
        Expanded(
          child: ListView.separated(
            // 태그 통계 탭에 다녀와도 스크롤 위치가 남게 한다.
            key: const PageStorageKey('search-memos'),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return MemoResultCard(memo: sorted[index], hierarchy: hierarchy);
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            '조건에 맞는 메모가 없어요.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          TextButton(onPressed: onReset, child: const Text('필터 초기화')),
        ],
      ),
    );
  }
}
