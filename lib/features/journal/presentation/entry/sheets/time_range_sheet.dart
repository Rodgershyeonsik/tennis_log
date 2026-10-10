import 'package:flutter/material.dart';

import '../../../../../core/util/formatters.dart';
import '../../../domain/session_time_math.dart';
import '../../../domain/session_time_range.dart';

/// 시간 선택 하단 시트. 확인을 누르면 고른 범위를, 취소하면 null을 돌려준다.
Future<SessionTimeRange?> showTimeRangeSheet(
  BuildContext context, {
  required SessionTimeRange initial,
  required List<SessionTimeRange> frequent,
}) {
  return showModalBottomSheet<SessionTimeRange>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _TimeRangeSheet(initial: initial, frequent: frequent),
  );
}

/// 시작·종료 휠 두 개를 나란히 둔 시트(명세 3번).
///
/// 각 휠은 시·분을 합친 단일 휠이고 30분 단위다. 현재 값이 30분 단위가 아니면
/// **가장 가까운 칸으로 바꾸지 않고** 그 값을 제자리에 끼워 보여준다.
class _TimeRangeSheet extends StatefulWidget {
  const _TimeRangeSheet({required this.initial, required this.frequent});

  final SessionTimeRange initial;
  final List<SessionTimeRange> frequent;

  @override
  State<_TimeRangeSheet> createState() => _TimeRangeSheetState();
}

class _TimeRangeSheetState extends State<_TimeRangeSheet> {
  static const _itemExtent = 44.0;

  late List<int> _startValues;
  late List<int> _endValues;
  late int _start;
  late int _end;
  late FixedExtentScrollController _startController;
  late FixedExtentScrollController _endController;

  @override
  void initState() {
    super.initState();
    _start = widget.initial.startMinutes;
    _end = widget.initial.endMinutes;
    _startValues = SessionTimeMath.wheelValues(current: _start);
    _endValues = SessionTimeMath.wheelValues(current: _end);
    _startController = FixedExtentScrollController(
      initialItem: _startValues.indexOf(_start),
    );
    _endController = FixedExtentScrollController(
      initialItem: _endValues.indexOf(_end),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  /// 자주 쓴 시간 칩으로 두 값을 한꺼번에 바꾼다.
  ///
  /// 칩의 값이 30분 단위가 아닐 수도 있어(± 로 만든 과거 세션) 휠 목록을 다시
  /// 만든 뒤 그 칸으로 보낸다.
  void _applyRange(SessionTimeRange range) {
    setState(() {
      _start = range.startMinutes;
      _end = range.endMinutes;
      _startValues = SessionTimeMath.wheelValues(current: _start);
      _endValues = SessionTimeMath.wheelValues(current: _end);
    });
    _startController.jumpToItem(_startValues.indexOf(_start));
    _endController.jumpToItem(_endValues.indexOf(_end));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ordered = SessionTimeMath.isOrdered(
      SessionTimeRange(startMinutes: _start, endMinutes: _end),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('시간', style: theme.textTheme.titleMedium),
            if (widget.frequent.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '자주 쓴 시간',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final range in widget.frequent)
                    ActionChip(
                      label: Text(
                        '${Formatters.minutesOfDay(range.startMinutes)}'
                        ' - ${Formatters.minutesOfDay(range.endMinutes)}',
                      ),
                      onPressed: () => _applyRange(range),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Wheel(
                    label: '시작',
                    values: _startValues,
                    controller: _startController,
                    itemExtent: _itemExtent,
                    onChanged: (value) => setState(() => _start = value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Wheel(
                    label: '종료',
                    values: _endValues,
                    controller: _endController,
                    itemExtent: _itemExtent,
                    onChanged: (value) => setState(() => _end = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 잘못된 값으로는 시트를 닫을 수 없다. 총 시간 자리에 이유를 보여준다.
            Text(
              ordered
                  ? '총 ${Formatters.duration(_end - _start)}'
                  : '종료 시간이 시작보다 빨라요. 다시 선택해 주세요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ordered ? null : theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: ordered
                  ? () => Navigator.of(context).pop(
                      SessionTimeRange(startMinutes: _start, endMinutes: _end),
                    )
                  : null,
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.label,
    required this.values,
    required this.controller,
    required this.itemExtent,
    required this.onChanged,
  });

  final String label;
  final List<int> values;
  final FixedExtentScrollController controller;
  final double itemExtent;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: SizedBox(
            height: itemExtent * 4,
            child: ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: itemExtent,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) => onChanged(values[index]),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: values.length,
                builder: (context, index) => Center(
                  child: Text(
                    Formatters.minutesOfDay(values[index]),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
