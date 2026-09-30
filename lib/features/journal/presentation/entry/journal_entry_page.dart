import 'package:flutter/material.dart';

/// 일지 작성 1단계. (4단계에서 내용을 채운다)
///
/// [sessionId]가 null이면 새 일지, 값이 있으면 작성 중인 일지 이어쓰기.
class JournalEntryPage extends StatelessWidget {
  const JournalEntryPage({super.key, this.sessionId});

  final int? sessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sessionId == null ? '새 일지' : '일지 #$sessionId')),
      body: const Center(child: Text('일지 작성 화면 (준비 중)')),
    );
  }
}
