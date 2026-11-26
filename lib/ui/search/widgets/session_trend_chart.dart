import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../../domain/search/search_aggregator.dart';
import '../../../domain/search/search_stats.dart';
import '../../core/formatters.dart';
import '../../core/widgets/evaluation_display.dart';

/// 막대의 평가 색. 없음만 연하게 쓴다.
///
/// 반투명이면 눈금선이 비치므로 카드 배경과 미리 섞는다.
Color trendColor(BuildContext context, MemoEvaluation value) {
  final color = evaluationColor(context, value);
  if (value != MemoEvaluation.none) return color;
  return Color.alphaBlend(
    color.withValues(alpha: 0.4),
    Theme.of(context).colorScheme.surfaceContainerLow,
  );
}

/// 세션별 누적 막대 차트와 스크롤 안내.
///
/// 막대 영역만 좌우로 스크롤되고 세로축 라벨과 눈금선은 고정이다.
class SessionTrendChart extends StatefulWidget {
  const SessionTrendChart({
    super.key,
    required this.sessions,
    required this.axisMax,
    required this.selectedSessionId,
    required this.onSelect,
  });

  /// 오래된 세션이 앞이다.
  final List<SessionTrendItem> sessions;
  final int axisMax;
  final int selectedSessionId;
  final ValueChanged<int> onSelect;

  @override
  State<SessionTrendChart> createState() => _SessionTrendChartState();
}

class _SessionTrendChartState extends State<SessionTrendChart> {
  static const _columnWidth = 48.0;
  static const _axisWidth = 24.0;

  /// 맨 위 눈금 라벨의 절반이 들어갈 자리.
  static const _topPadding = 10.0;
  static const _plotHeight = 160.0;
  static const _labelHeight = 28.0;

  /// 목록을 뒤집어 두어서 0이 오른쪽 끝(최신 세션)이다.
  final _controller = ScrollController(keepScrollOffset: false);

  @override
  void didUpdateWidget(SessionTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed = !listEquals(
      [for (final item in oldWidget.sessions) item.session.id],
      [for (final item in widget.sessions) item.session.id],
    );
    if (!changed) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.hasClients) _controller.jumpTo(0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.maxWidth - _axisWidth;
        final content = widget.sessions.length * _columnWidth;
        final scrollable = content > viewport;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _topPadding + _plotHeight + _labelHeight,
              child: Stack(
                children: [
                  ..._gridLines(context),
                  Positioned.fill(
                    left: _axisWidth,
                    top: _topPadding,
                    child: _columns(max(0, viewport - content)),
                  ),
                  if (scrollable)
                    Positioned.fill(
                      left: _axisWidth,
                      child: _edgeFades(content - viewport),
                    ),
                ],
              ),
            ),
            if (scrollable) ...[const SizedBox(height: 8), const _SwipeHint()],
          ],
        );
      },
    );
  }

  List<Widget> _gridLines(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return [
      for (final value in [0, widget.axisMax ~/ 2, widget.axisMax]) ...[
        Positioned(
          left: _axisWidth,
          right: 0,
          top: _lineY(value),
          child: Container(
            height: 1,
            color: value == 0 ? scheme.outline : scheme.outlineVariant,
          ),
        ),
        Positioned(
          left: 0,
          top: _lineY(value) - _topPadding,
          width: _axisWidth - 6,
          height: _topPadding * 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              '$value',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    ];
  }

  double _lineY(int value) {
    return _topPadding + _plotHeight * (1 - value / widget.axisMax);
  }

  Widget _columns(double emptyWidth) {
    final sessions = widget.sessions;
    final withYear = SearchStats.yearLabels([
      for (final item in sessions) item.session.date,
    ]);

    return ScrollConfiguration(
      // 웹에서도 마우스로 밀 수 있게 한다.
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        reverse: true,
        // 열이 적으면 왼쪽부터 채운다.
        padding: EdgeInsets.only(right: emptyWidth),
        itemExtent: _columnWidth,
        itemCount: sessions.length,
        itemBuilder: (context, reversedIndex) {
          final index = sessions.length - 1 - reversedIndex;
          final item = sessions[index];
          final date = item.session.date;
          return _SessionColumn(
            key: ValueKey(item.session.id),
            evaluations: item.evaluations,
            axisMax: widget.axisMax,
            plotHeight: _plotHeight,
            label: withYear[index]
                ? Formatters.shortDate(date)
                : Formatters.monthDay(date),
            selected: item.session.id == widget.selectedSessionId,
            onTap: () => widget.onSelect(item.session.id),
          );
        },
      ),
    );
  }

  Widget _edgeFades(double maxOffset) {
    return IgnorePointer(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final offset =
              _controller.hasClients && _controller.position.hasPixels
              ? _controller.offset
              : 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (offset < maxOffset - 0.5)
                const _EdgeFade(left: true)
              else
                const SizedBox.shrink(),
              if (offset > 0.5)
                const _EdgeFade(left: false)
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}

/// 열 하나(막대 + 날짜 라벨). 열 전체가 터치 영역이다.
class _SessionColumn extends StatelessWidget {
  const _SessionColumn({
    super.key,
    required this.evaluations,
    required this.axisMax,
    required this.plotHeight,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _barWidth = 22.0;
  static const _segmentGap = 1.0;

  final EvaluationCounts evaluations;
  final int axisMax;
  final double plotHeight;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: plotHeight,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            alignment: Alignment.bottomCenter,
            color: selected ? scheme.primary.withValues(alpha: 0.1) : null,
            child: evaluations.total == 0 ? _emptyMark(scheme) : _bar(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyMark(ColorScheme scheme) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: scheme.outline, width: 2),
      ),
    );
  }

  /// 아래에서부터 [MemoEvaluation] 순서로 쌓는다.
  Widget _bar(BuildContext context) {
    final shown = MemoEvaluation.values
        .where((value) => evaluations.countOf(value) > 0)
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final value in shown.reversed)
          Container(
            key: ValueKey(value),
            width: _barWidth,
            height: plotHeight * evaluations.countOf(value) / axisMax,
            padding: EdgeInsets.only(
              bottom: value == shown.first ? 0 : _segmentGap,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: trendColor(context, value),
                // 맨 위 칸만 위쪽 모서리를 깎는다.
                borderRadius: value == shown.last
                    ? const BorderRadius.vertical(top: Radius.circular(3))
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

/// 가려진 쪽 가장자리의 흐림과 화살표.
class _EdgeFade extends StatelessWidget {
  const _EdgeFade({required this.left});

  final bool left;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = scheme.surfaceContainerLow;

    return Container(
      width: 28,
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: left ? Alignment.centerLeft : Alignment.centerRight,
          end: left ? Alignment.centerRight : Alignment.centerLeft,
          colors: [background, background.withValues(alpha: 0)],
        ),
      ),
      child: Icon(
        left ? Icons.chevron_left : Icons.chevron_right,
        size: 20,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}

class _SwipeHint extends StatelessWidget {
  const _SwipeHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        Icon(Icons.swap_horiz, size: 16, color: color),
        Flexible(
          child: Text(
            '차트를 좌우로 밀어서 다른 세션을 볼 수 있어요',
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
