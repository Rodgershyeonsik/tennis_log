import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../../domain/search/search_stats.dart';
import '../../../domain/search/tag_hierarchy.dart';
import '../../core/formatters.dart';
import '../sheets/session_detail_sheet.dart';
import 'chart_tag_button.dart';
import 'evaluation_count.dart';
import 'session_trend_chart.dart';

/// 세션별 평가 추이 카드. 차트 태그 드롭다운, 차트, 선택한 세션 줄로 이루어진다.
class SessionTrendCard extends StatelessWidget {
  const SessionTrendCard({
    super.key,
    required this.stats,
    required this.hierarchy,
    required this.chartTagId,
    required this.selectedSessionId,
    required this.onChartTagChanged,
    required this.onSelectSession,
  });

  /// 세션이 1개 이상이어야 한다.
  final SearchStats stats;
  final TagHierarchy hierarchy;
  final int? chartTagId;

  /// null이면 최신 세션이다.
  final int? selectedSessionId;
  final ValueChanged<int?> onChartTagChanged;
  final ValueChanged<int> onSelectSession;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessions = stats.sessions;
    final selected = sessions.firstWhere(
      (item) => item.session.id == selectedSessionId,
      orElse: () => sessions.last,
    );

    return Card(
      child: Padding(
        // 위쪽은 드롭다운의 48dp 터치 영역이 여백 일부를 대신한다.
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      '세션별 평가 추이',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // 이름이 길어도 제목 자리를 남긴다.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: ChartTagButton(
                    hierarchy: hierarchy,
                    tagId: chartTagId,
                    onChanged: onChartTagChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SessionTrendChart(
              sessions: sessions,
              axisMax: stats.axisMax,
              selectedSessionId: selected.session.id,
              onSelect: onSelectSession,
            ),
            const SizedBox(height: 12),
            _SelectedSessionRow(item: selected),
          ],
        ),
      ),
    );
  }
}

class _SelectedSessionRow extends StatelessWidget {
  const _SelectedSessionRow({required this.item});

  final SessionTrendItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            // 좁은 폭이나 큰 글씨에서는 줄을 바꾸지 않고 줄인다.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                spacing: 8,
                children: [
                  Text(
                    Formatters.dateWithWeekday(item.session.date),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  for (final value in MemoEvaluation.values)
                    EvaluationCount(
                      value: value,
                      count: item.evaluations.countOf(value),
                    ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                showSessionDetailSheet(context, sessionId: item.session.id),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 10, right: 6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('세션 보기'), Icon(Icons.chevron_right, size: 18)],
            ),
          ),
        ],
      ),
    );
  }
}
