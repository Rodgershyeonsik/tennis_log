import 'package:flutter/material.dart';

import '../../../core/widgets/dashed_border.dart';
import 'chip_metrics.dart';

/// 메모에 붙은 태그 칩 하나(명세 5번).
///
/// **confirmed는 실선 채움, suggested는 점선 테두리**다. 점선은 "저장 때 자동으로
/// 골라 둔 것이니 맞는지 봐 달라"는 뜻이라, 눌러서 확정할 수 있다. x는 둘 다에
/// 있고 누르면 rejected가 된다.
class TagStatusChip extends StatelessWidget {
  const TagStatusChip({
    super.key,
    required this.label,
    required this.confirmed,
    required this.onConfirm,
    required this.onDelete,
  });

  final String label;

  /// false면 suggested. rejected는 화면에 오지 않는다.
  final bool confirmed;

  /// suggested 칩을 탭했을 때. 이미 confirmed면 할 일이 없어 호출하지 않는다.
  final VoidCallback onConfirm;

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final borderRadius = BorderRadius.circular(ChipMetrics.radius);

    final foreground = confirmed
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;

    final chip = Material(
      // suggested는 면을 깔지 않아 "아직 붙지 않은 것"처럼 비어 보이게 한다.
      color: confirmed ? scheme.primaryContainer : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: confirmed ? null : onConfirm,
        borderRadius: borderRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ChipMetrics.minHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foreground,
                  ),
                ),
                // x는 칩 본체와 따로 눌려야 해서 자기 InkWell을 가진다.
                InkWell(
                  onTap: onDelete,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.close, size: 16, color: foreground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (confirmed) return chip;
    return DashedBorder(
      color: scheme.outline,
      radius: ChipMetrics.radius,
      child: chip,
    );
  }
}

/// 태그 추가 시트를 여는 `＋ 태그 추가` 칩.
///
/// 추천 칩(점선)과 헷갈리지 않게 **실선 테두리**로 그린다.
///
/// **아이콘만 두지 않고 글자를 함께 쓴다.** 태그가 하나도 붙지 않은 메모에서는
/// 이 칩만 홀로 남는데, `＋`만 있으면 무엇을 더하는 버튼인지 바로 읽히지 않는다.
class AddTagChip extends StatelessWidget {
  const AddTagChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final borderRadius = BorderRadius.circular(ChipMetrics.radius);

    return Material(
      color: Colors.transparent,
      // Material은 borderRadius와 shape를 함께 받지 않는다. 테두리가 필요하니
      // shape 쪽으로만 준다.
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ChipMetrics.minHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // Row가 남는 높이 안에서 내용을 가운데로 맞춘다. 세로 여백으로
            // 높이를 만들면 태그 칩과 또 어긋난다.
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(Icons.add, size: 18, color: scheme.onSurfaceVariant),
                Text(
                  '태그 추가',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
