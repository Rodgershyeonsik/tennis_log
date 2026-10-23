import 'package:flutter/material.dart';

/// 메모 목록의 한 줄.
///
/// 구분선 대신 **줄마다 밝은 면**을 깔아 나눈다. 카드(묶음)보다 한 단계 덜 둥글게
/// 깎아서 카드 안에 들어 있는 조각으로 읽히게 한다.
class EntryListRow extends StatelessWidget {
  const EntryListRow({
    super.key,
    required this.text,
    required this.onTap,
    this.maxLines = 3,
  });

  static const _radius = 12.0;

  final String text;
  final VoidCallback onTap;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(_radius);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
