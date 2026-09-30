import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 메인 화면. 지금은 진입점 역할만 한다.
///
/// 작성 중(draft) 일지 목록은 데이터 계층이 생긴 뒤(6단계)에 붙인다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('테니스 일지')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => context.push('/journal/new'),
                icon: const Icon(Icons.edit_note),
                label: const Text('새 일지 쓰기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
