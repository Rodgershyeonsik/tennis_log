import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../core/widgets/evaluation_display.dart';

/// 평가 아이콘 + 건수.
class EvaluationCount extends StatelessWidget {
  const EvaluationCount({super.key, required this.value, required this.count});

  final MemoEvaluation value;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        Icon(
          evaluationIcon(value),
          size: 14,
          color: evaluationColor(context, value),
        ),
        Text('$count'),
      ],
    );
  }
}
