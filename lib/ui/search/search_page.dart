import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/search/search_aggregator.dart';
import '../../domain/search/search_models.dart';
import 'search_notifier.dart';
import 'search_providers.dart';
import 'widgets/memo_result_tab.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/stats_tab.dart';

/// 조회 화면. 탭 화면이라 뒤로가기 버튼이 없다.
///
/// 메모 탭과 태그 통계 탭은 범위와 세션 단위 필터를 함께 쓴다. 평가·태그 필터는
/// 메모 탭에만 적용된다.
class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  /// 요약 칩으로 좁혀 보는 동안은 `메모 3 / 24`로 쓴다.
  String _memoTabLabel(List<SearchMemo>? memos, Set<int> summaryTagIds) {
    if (memos == null) return '메모';

    final shown = SearchAggregator.narrowByTags(memos, summaryTagIds).length;
    return shown == memos.length ? '메모 $shown' : '메모 $shown / ${memos.length}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final memos = ref.watch(searchResultsProvider).value;
    final summaryTagIds = ref.watch(
      searchProvider.select((state) => state.summaryTagIds),
    );
    final excluded = ref.watch(searchExcludedCountProvider).value ?? 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('조회')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SearchFilterBar(),
            if (excluded > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  '확인 완료 전 일지 $excluded개는 빠졌어요',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            TabBar(
              tabs: [
                Tab(text: _memoTabLabel(memos, summaryTagIds)),
                const Tab(text: '태그 통계'),
              ],
            ),
            const Expanded(
              child: TabBarView(children: [MemoResultTab(), StatsTab()]),
            ),
          ],
        ),
      ),
    );
  }
}
