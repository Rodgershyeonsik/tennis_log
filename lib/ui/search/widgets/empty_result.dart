import 'package:flutter/material.dart';

/// 조건에 맞는 결과가 없을 때의 안내와 필터 초기화 버튼.
class EmptyResult extends StatelessWidget {
  const EmptyResult({super.key, required this.message, required this.onReset});

  final String message;
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
            message,
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
