import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../../domain/search/search_models.dart';
import '../../../domain/search/tag_hierarchy.dart';
import '../../core/formatters.dart';
import '../../core/widgets/entry_card.dart';
import '../../core/widgets/evaluation_display.dart';
import '../../core/widgets/tag_display_chip.dart';

/// 조회 결과의 메모 한 건. 본문은 줄이지 않고 전부 보여준다.
class MemoResultCard extends StatelessWidget {
  const MemoResultCard({
    super.key,
    required this.memo,
    required this.hierarchy,
  });

  final SearchMemo memo;
  final TagHierarchy hierarchy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = memo.session;
    final evaluation = memo.evaluation;
    final showEvaluation =
        evaluation != null && evaluation != MemoEvaluation.none;
    final tagNames = memo.tagIds
        .map((id) => hierarchy.tagOf(id)?.name)
        .nonNulls
        .toList();

    return EntryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  [
                    Formatters.dateWithWeekday(session.date),
                    ?session.placeNameSnapshot,
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(memo.content, style: theme.textTheme.bodyLarge),
          if (tagNames.isNotEmpty || showEvaluation) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final name in tagNames) TagDisplayChip(label: name),
                    ],
                  ),
                ),
                if (showEvaluation) EvaluationBadge(value: evaluation),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
