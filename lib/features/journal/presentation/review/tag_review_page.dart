import 'package:flutter/material.dart';

/// 일지 작성 2단계: 태그·평가 확인. (5단계에서 내용을 채운다)
class TagReviewPage extends StatelessWidget {
  const TagReviewPage({super.key, required this.sessionId});

  final int sessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('태그 확인')),
      body: Center(child: Text('태그 확인 화면 (준비 중) — 세션 #$sessionId')),
    );
  }
}
