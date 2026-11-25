import 'package:flutter/material.dart';

import '../../../domain/search/search_models.dart';
import '../../../domain/search/tag_hierarchy.dart';
import '../../core/formatters.dart';
import '../../core/widgets/entry_card.dart';
import 'memo_content.dart';

/// 조회 결과의 메모 한 건. 본문은 줄이지 않고 전부 보여준다.
class MemoResultCard extends StatelessWidget {
  const MemoResultCard({
    super.key,
    required this.memo,
    required this.hierarchy,
    this.onTap,
    this.showChevron = true,
  }) : assert(!showChevron || onTap != null);

  final SearchMemo memo;
  final TagHierarchy hierarchy;

  /// 카드 어디를 눌러도 불린다. 태그 칩과 평가 아이콘도 따로 반응하지 않는다.
  final VoidCallback? onTap;

  /// 오른쪽 화살표. 숨기면 카드를 눌러도 아무 동작이 없고 [onTap]도 불리지 않는다.
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = memo.session;
    final tagNames = memo.tagIds
        .map((id) => hierarchy.tagOf(id)?.name)
        .nonNulls
        .toList();

    return GestureDetector(
      onTap: showChevron ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: EntryCard(
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
                if (showChevron)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            MemoContent(
              content: memo.content,
              tagNames: tagNames,
              evaluation: memo.evaluation,
            ),
          ],
        ),
      ),
    );
  }
}
