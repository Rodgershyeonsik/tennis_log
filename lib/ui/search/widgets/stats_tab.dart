import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../search_notifier.dart';
import '../search_providers.dart';
import '../stats_notifier.dart';
import 'empty_result.dart';
import 'session_trend_card.dart';

/// 조회 화면의 태그 통계 탭.
class StatsTab extends ConsumerStatefulWidget {
  const StatsTab({super.key});

  @override
  ConsumerState<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends ConsumerState<StatsTab>
    with AutomaticKeepAliveClientMixin {
  /// 메모 탭에 다녀와도 스크롤 위치가 남게 한다.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final stats = ref.watch(searchStatsProvider);
    final hierarchy = ref.watch(searchTagHierarchyProvider).value;
    final state = ref.watch(statsProvider);
    final filter = ref.watch(searchProvider.select((state) => state.filter));
    final notifier = ref.read(statsProvider.notifier);

    if (stats == null || hierarchy == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final firstDate = stats.firstDate;
    final lastDate = stats.lastDate;
    if (firstDate == null || lastDate == null) {
      return EmptyResult(
        message: '조건에 맞는 세션이 없어요.',
        onReset: ref.read(searchProvider.notifier).resetFilter,
      );
    }

    final first = Formatters.dateWithWeekday(firstDate);
    final last = Formatters.dateWithWeekday(lastDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 필터 재구성 전까지의 임시 안내.
          if (filter != filter.sessionOnly) ...[
            Text(
              '평가·태그 필터는 통계에 적용되지 않아요',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _PeriodLabel(
            text: stats.sessions.length == 1 ? last : '$first – $last',
          ),
          const SizedBox(height: 12),
          SessionTrendCard(
            stats: stats,
            hierarchy: hierarchy,
            chartTagId: state.chartTagId,
            selectedSessionId: state.selectedSessionId,
            onChartTagChanged: notifier.setChartTag,
            onSelectSession: notifier.selectSession,
          ),
        ],
      ),
    );
  }
}

class _PeriodLabel extends StatelessWidget {
  const _PeriodLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    return Row(
      spacing: 8,
      children: [
        Icon(Icons.calendar_today_outlined, size: 18, color: color),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
