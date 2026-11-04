import 'package:flutter/material.dart';

/// 조회 화면. 탭 화면이라 뒤로가기 버튼이 없다.
///
/// 필터와 결과는 다음 단계에서 채운다.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('조회')),
      body: Center(
        child: Text(
          '조회 화면을 준비하고 있어요.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
