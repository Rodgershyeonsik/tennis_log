import 'package:flutter/material.dart';

/// 분할 버튼의 한 칸.
class SegmentedTab<T extends Object> {
  const SegmentedTab(this.value, this.label);

  final T value;
  final String label;
}

/// 칸이 실선으로 나뉘는 분할 버튼.
///
/// Material의 `SegmentedButton`은 바깥 테두리와 칸 구분선이 같은 `BorderSide`
/// 하나라서, 선택된 칸만 다르게 칠하거나 구분선 색을 따로 줄 수 없다. 그래서
/// 직접 그린다.
///
/// - 칸에는 테두리를 두지 않는다. **선택되지 않은 칸끼리 맞닿은 자리에만** 흰
///   구분선을 넣고, 선택된 칸에 맞닿은 자리에는 선을 두지 않는다.
/// - 양 끝은 알약처럼 둥글다. 트랙을 잘라내는(clip) 방식은 안드로이드에서 모서리
///   선이 끊겨 보여서 쓰지 않고, 양 끝 칸이 자기 모서리를 둥글게 그린다.
/// - 선택되지 않은 칸의 글씨는 흐린 회색(`onSurfaceVariant`)이라 선택된 칸이
///   먼저 읽힌다.
/// - 선택된 칸: `primary` 채움 + `onPrimary` 글씨. **모서리를 깎지 않아서**
///   칸이 일자로 나뉘어 보인다(바깥 모서리는 트랙이 잘라 준다).
/// - 구분선: 기본은 흐린 실선, **선택된 칸과 맞닿은 자리는 채움과 같은 색**이라
///   선이 보이지 않고 한 덩어리로 읽힌다.
class SegmentedTabs<T extends Object> extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.tabs,
    required this.value,
    required this.onChanged,
    this.allowEmpty = true,
  }) : assert(allowEmpty || value != null, '해제할 수 없는 분할 버튼은 항상 값이 있어야 한다.');

  static const _height = 48.0;

  /// 알약 모양이 되도록 높이의 절반.
  static const _radius = _height / 2;

  final List<SegmentedTab<T>> tabs;
  final T? value;

  /// [allowEmpty]가 true면 선택된 칸을 다시 눌러 해제할 수 있다.
  final ValueChanged<T?> onChanged;
  final bool allowEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = Radius.circular(_radius);

    return SizedBox(
      height: _height,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                // 선택된 칸에 닿은 자리에는 선을 두지 않는다. 칸 너비가 선택에
                // 따라 흔들리지 않게, 선이 없을 때도 자리는 차지한다.
                color: tabs[i].value == value || tabs[i - 1].value == value
                    ? Colors.transparent
                    : scheme.surfaceContainerLowest,
              ),
            Expanded(
              child: _Tab(
                label: tabs[i].label,
                selected: tabs[i].value == value,
                // 양 끝 칸만 바깥쪽 모서리를 둥글게 깎는다.
                borderRadius: BorderRadius.horizontal(
                  left: i == 0 ? radius : Radius.zero,
                  right: i == tabs.length - 1 ? radius : Radius.zero,
                ),
                onTap: () {
                  if (tabs[i].value == value) {
                    if (allowEmpty) onChanged(null);
                    return;
                  }
                  onChanged(tabs[i].value);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.borderRadius,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: selected ? scheme.primary : scheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              // 선택되지 않은 칸은 한 톤 흐리게 — 선택된 칸이 먼저 읽힌다.
              color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
