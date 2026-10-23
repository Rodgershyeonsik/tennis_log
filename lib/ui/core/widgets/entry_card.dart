import 'package:flutter/material.dart';

/// 작성 화면의 묶음 하나. 관련된 입력 항목을 한 카드에 담는다.
///
/// 카드 색·둥근 정도·그림자는 테마의 `cardTheme`에서 온다. 간격만 여기서
/// 정해서 모든 묶음이 같은 안쪽 여백을 쓰게 한다.
class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

/// 한 카드 안에서 항목 사이에 두는 간격.
class EntryGap extends StatelessWidget {
  const EntryGap({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(height: 18);
}
