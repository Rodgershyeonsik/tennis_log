import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../labels.dart';

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

/// 확정된 평가를 보여주기만 하는 아이콘. 태그 확인 화면의 확정 모양과 같다.
///
/// 버튼이 아니라서 눌러도 아무 동작이 없다.
class EvaluationBadge extends StatelessWidget {
  const EvaluationBadge({super.key, required this.value});

  static const _width = 46.0;
  static const _height = 40.0;
  static const _radius = 10.0;
  static const _iconSize = 22.0;

  final MemoEvaluation value;

  @override
  Widget build(BuildContext context) {
    final color = evaluationColor(context, value);

    return Tooltip(
      message: value.label,
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Icon(evaluationIcon(value), size: _iconSize, color: color),
      ),
    );
  }
}
