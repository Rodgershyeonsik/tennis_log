import 'package:flutter/material.dart';

import '../../../domain/search/search_aggregator.dart';
import 'tag_summary_chip.dart';

/// 메모 탭의 요약 카드. 결과 메모의 태그별 건수를 보여주고, 칩을 누르면 결과 안에서
/// 그 태그의 메모만 좁혀 본다. 머리를 누르면 칩들을 접고 편다.
///
/// 화면 상단에 고정되므로, 태그가 많아도 메모 목록의 자리를 남기도록 펼친 높이에
/// 상한을 두고 그 안에서 세로로 스크롤한다.
class TagSummaryCard extends StatelessWidget {
  const TagSummaryCard({
    super.key,
    required this.items,
    required this.selectedTagIds,
    required this.expanded,
    required this.onToggle,
    required this.onTapItem,
  });

  static const _headerHeight = 48.0;

  /// 칩 석 줄 반. 한 줄이 잘려 보여서 더 있다는 걸 알 수 있다.
  static const _maxChipsHeight = 168.0;

  final List<TagSummaryItem> items;
  final Set<int> selectedTagIds;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<int> onTapItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: SizedBox(
              height: _headerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('태그 요약', style: theme.textTheme.labelLarge),
                    ),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: _maxChipsHeight),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final item in items)
                      TagSummaryChip(
                        item: item,
                        selected: selectedTagIds.contains(item.tagId),
                        onTap: () => onTapItem(item.tagId),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
