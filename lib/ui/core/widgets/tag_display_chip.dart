import 'package:flutter/material.dart';

/// 확정된 태그를 보여주기만 하는 칩. 태그 확인 화면의 확정 칩과 같은 모양이다.
///
/// 버튼이 아니라서 눌러도 아무 동작이 없다.
class TagDisplayChip extends StatelessWidget {
  const TagDisplayChip({super.key, required this.label});

  static const _radius = 10.0;
  static const _minHeight = 36.0;

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _minHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
