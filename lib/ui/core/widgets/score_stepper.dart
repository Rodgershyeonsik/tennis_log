import 'package:flutter/material.dart';

/// 게임 스코어용 −/+ 스테퍼. 0부터 시작하고 음수로 내려가지 않는다.
///
/// [value]가 null이면 "스코어 모름"이라 값 대신 `—`를 보여주고 버튼을 끈다.
class ScoreStepper extends StatelessWidget {
  const ScoreStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int? value;

  /// null을 받으면 버튼이 꺼진 상태다.
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = value;
    final enabled = onChanged != null && current != null;

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              onPressed: enabled && current > 0
                  ? () => onChanged!(current - 1)
                  : null,
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 48,
              child: Text(
                current?.toString() ?? '—',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            IconButton.outlined(
              onPressed: enabled ? () => onChanged!(current + 1) : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
