import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';

const _goodLight = Color(0xFF1B8A4B);
const _goodDark = Color(0xFF6BD69B);

/// 평가의 아이콘. 태그 확인 화면에서 선택된 아이콘과 같다.
IconData evaluationIcon(MemoEvaluation value) {
  return switch (value) {
    MemoEvaluation.good => Icons.thumb_up,
    MemoEvaluation.bad => Icons.thumb_down,
    MemoEvaluation.question => Icons.help,
    MemoEvaluation.none => Icons.remove_circle,
  };
}

/// 평가의 색. 초록만 colorScheme에 없어서 직접 정한다.
Color evaluationColor(BuildContext context, MemoEvaluation value) {
  final theme = Theme.of(context);
  return switch (value) {
    MemoEvaluation.good =>
      theme.brightness == Brightness.dark ? _goodDark : _goodLight,
    MemoEvaluation.bad => theme.colorScheme.error,
    MemoEvaluation.question => theme.colorScheme.primary,
    MemoEvaluation.none => theme.colorScheme.onSurfaceVariant,
  };
}
