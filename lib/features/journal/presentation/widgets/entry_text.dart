import 'package:flutter/material.dart';

/// 작성 화면에서 "값"을 보여주는 글자 스타일.
///
/// 일시의 날짜와 시작·종료 라벨이 같은 무게로 읽혀야 해서 한곳에서 만든다.
/// 완전한 검정은 카드 안에서 혼자 튀어서 한 톤 연하게 쓴다.
TextStyle? entryValueStyle(BuildContext context) {
  final theme = Theme.of(context);
  return theme.textTheme.titleMedium?.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
  );
}
