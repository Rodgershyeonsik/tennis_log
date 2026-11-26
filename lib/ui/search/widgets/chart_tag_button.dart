import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../../domain/search/tag_hierarchy.dart';
import '../../core/labels.dart';

/// 메뉴 항목의 값. 태그 전체(null)도 고를 수 있게 감싼다. `PopupMenuButton`은 값이
/// null인 항목을 고르면 닫기로 처리한다.
typedef _ChartTag = ({int? id});

/// 차트 태그 드롭다운. 기술·상황 태그 하나 또는 태그 전체(null)를 고른다.
class ChartTagButton extends StatefulWidget {
  const ChartTagButton({
    super.key,
    required this.hierarchy,
    required this.tagId,
    required this.onChanged,
  });

  final TagHierarchy hierarchy;
  final int? tagId;
  final ValueChanged<int?> onChanged;

  @override
  State<ChartTagButton> createState() => _ChartTagButtonState();
}

class _ChartTagButtonState extends State<ChartTagButton> {
  static const _menuWidth = 220.0;

  /// 길면 메뉴 안에서 스크롤한다.
  static const _menuMaxHeight = 360.0;
  static const _indent = 18.0;
  static const _categories = [TagCategory.technique, TagCategory.situation];

  bool _open = false;

  void _setOpen(bool open) => setState(() => _open = open);

  List<PopupMenuEntry<_ChartTag>> _items(BuildContext context) {
    return [
      _item(context, id: null, label: '태그 전체'),
      for (final category in _categories) ..._categoryItems(context, category),
    ];
  }

  List<PopupMenuEntry<_ChartTag>> _categoryItems(
    BuildContext context,
    TagCategory category,
  ) {
    final tags = widget.hierarchy.tags.where(
      (tag) => tag.category == category && !tag.isArchived,
    );
    if (tags.isEmpty) return const [];

    return [
      const PopupMenuDivider(),
      _header(context, category.label),
      for (final row in widget.hierarchy.chipRows(tags))
        for (final tag in row.tags)
          _item(
            context,
            id: tag.id,
            label: '#${tag.name}',
            indent: row.depth * _indent,
          ),
    ];
  }

  /// 고른 항목은 배경색과 굵은 글씨로만 표시한다.
  PopupMenuItem<_ChartTag> _item(
    BuildContext context, {
    required int? id,
    required String label,
    double indent = 0,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = id == widget.tagId;

    return PopupMenuItem(
      value: (id: id),
      padding: EdgeInsets.zero,
      child: Container(
        constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16 + indent, right: 16),
        color: selected ? scheme.primaryContainer : null,
        child: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : null,
          ),
        ),
      ),
    );
  }

  /// 누를 수 없는 카테고리 머리글.
  PopupMenuItem<_ChartTag> _header(BuildContext context, String label) {
    final theme = Theme.of(context);

    return PopupMenuItem(
      enabled: false,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tagId = widget.tagId;
    final tagged = tagId != null;
    // 태그 전체는 같은 알약 모양에 차분한 회색 채움으로 둔다. 태그를 고르면
    // primary 계열로 바뀌어서 좁혀 보는 중인지 색으로 알 수 있다.
    final foreground = tagged
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;

    // 버튼이 화면 오른쪽에 있어서 메뉴는 버튼 오른쪽 끝에 맞춰 열린다.
    return PopupMenuButton<_ChartTag>(
      tooltip: '차트 태그 선택',
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(
        minWidth: _menuWidth,
        maxWidth: _menuWidth,
        maxHeight: _menuMaxHeight,
      ),
      color: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      itemBuilder: _items,
      onOpened: () => _setOpen(true),
      onCanceled: () => _setOpen(false),
      onSelected: (picked) {
        _setOpen(false);
        widget.onChanged(picked.id);
      },
      // 보이는 알약보다 넓은 48dp 높이 전체가 터치 영역이다.
      child: SizedBox(
        height: kMinInteractiveDimension,
        child: Center(
          // 남는 폭을 차지하지 않고 알약 크기로 줄인다.
          widthFactor: 1,
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.only(left: 16, right: 10),
            decoration: ShapeDecoration(
              color: tagged
                  ? scheme.primaryContainer
                  : scheme.surfaceContainerHighest,
              shape: const StadiumBorder(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Flexible(
                  child: Text(
                    tagged
                        ? '#${widget.hierarchy.tagOf(tagId)?.name ?? ''}'
                        : '태그 전체',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: tagged ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
