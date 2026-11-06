import 'package:flutter/material.dart';

/// 여러 개를 고르는 칩 그룹. 모습은 [AppChoiceChips]와 같다.
///
/// [chips]는 값과 표기의 쌍이고 넣은 순서대로 그린다. 값에 null을 쓸 수 있다
/// (조회 필터의 "기록 없음").
class AppMultiChoiceChips<T> extends StatelessWidget {
  const AppMultiChoiceChips({
    super.key,
    required this.chips,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
  });

  final Map<T, String> chips;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;

  /// false면 칩이 흐려지고 눌리지 않는다.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final MapEntry(key: value, value: label) in chips.entries)
          FilterChip(
            label: Text(label),
            selected: selected.contains(value),
            onSelected: enabled
                ? (isSelected) => onChanged(
                    isSelected
                        ? {...selected, value}
                        : selected.difference({value}),
                  )
                : null,
          ),
      ],
    );
  }
}
