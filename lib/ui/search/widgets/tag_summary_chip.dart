import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../../domain/search/search_aggregator.dart';
import 'evaluation_count.dart';

/// 메모 탭 요약 카드의 칩. 예: `서브 7 · 👍2 👎5`. 0인 평가는 생략한다.
class TagSummaryChip extends StatelessWidget {
  const TagSummaryChip({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final TagSummaryItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final counts = item.evaluations;

    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Text('${item.name} ${item.count} ·'),
          for (final value in MemoEvaluation.values)
            if (counts.countOf(value) > 0)
              EvaluationCount(value: value, count: counts.countOf(value)),
        ],
      ),
    );
  }
}
