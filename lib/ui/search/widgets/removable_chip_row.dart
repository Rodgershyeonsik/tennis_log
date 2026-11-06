import 'package:flutter/material.dart';

/// [RemovableChipRow]의 칩 하나.
class RemovableChip {
  const RemovableChip(this.label, this.onRemove);

  final String label;
  final VoidCallback onRemove;
}

/// 시트 맨 위의 고른 조건 줄. 칩을 누르면 그 조건이 빠진다.
///
/// 칩이 많아도 시트 높이가 변하지 않게 한 줄 가로 스크롤로 둔다.
class RemovableChipRow extends StatelessWidget {
  const RemovableChipRow({super.key, required this.chips});

  final List<RemovableChip> chips;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 8,
          children: [
            for (final chip in chips)
              InputChip(
                label: Text(chip.label),
                selected: true,
                onPressed: chip.onRemove,
                onDeleted: chip.onRemove,
              ),
          ],
        ),
      ),
    );
  }
}
