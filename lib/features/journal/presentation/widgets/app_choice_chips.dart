import 'package:flutter/material.dart';

/// 칩 그룹의 한 칸.
class AppChip<T extends Object> {
  const AppChip(this.value, this.label);

  final T value;
  final String label;
}

/// 단일 선택 칩 그룹. **선택된 칩을 다시 누르면 해제된다**(명세: 마지막 식사).
///
/// [trailing]은 목록 끝에 붙는 고정 칩이다(장소 섹션의 **+** 칩).
class AppChoiceChips<T extends Object> extends StatelessWidget {
  const AppChoiceChips({
    super.key,
    required this.chips,
    required this.value,
    required this.onChanged,
    this.trailing,
  });

  final List<AppChip<T>> chips;
  final T? value;
  final ValueChanged<T?> onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final chip in chips)
          ChoiceChip(
            label: Text(chip.label),
            selected: chip.value == value,
            onSelected: (selected) => onChanged(selected ? chip.value : null),
          ),
        ?trailing,
      ],
    );
  }
}
