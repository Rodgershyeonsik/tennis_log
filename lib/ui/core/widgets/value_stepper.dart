import 'package:flutter/material.dart';

import 'entry_text.dart';

/// `시작        [⊖ | 18:00 | ⊕]` 형태의 스테퍼.
///
/// ± 버튼은 시간 칸의 **양 끝을 채우는 캡**이다. 칸이 모서리를 깎아 내므로
/// 왼쪽 버튼은 왼쪽만, 오른쪽 버튼은 오른쪽만 둥글게 보인다. 가운데 값 부분을
/// 누르면 [onTapValue](시간 선택 시트)로 간다 — 버튼이 자기 영역의 탭을 먼저
/// 먹으므로 같은 칸 안에서 두 동작이 섞이지 않는다.
class ValueStepper extends StatelessWidget {
  const ValueStepper({
    super.key,
    required this.label,
    required this.text,
    required this.onDecrease,
    required this.onIncrease,
    this.onTapValue,
  });

  /// 시간 칸 높이. 값 칸과 ± 버튼이 함께 쓴다.
  static const _height = 44.0;

  /// 양 끝 ± 캡의 너비.
  static const _capWidth = 44.0;

  /// 값이 들어가는 가운데 너비.
  static const _valueWidth = 105.0;

  /// 값 왼쪽의 이름. 예: 시작, 종료
  final String label;
  final String text;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback? onTapValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        // 날짜 표시와 같은 글자 스타일로 맞춘다.
        Text(label, style: entryValueStyle(context)),
        const Spacer(),
        Container(
          height: _height,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(_height / 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Cap(icon: Icons.remove, tooltip: '10분 빼기', onTap: onDecrease),
              InkWell(
                onTap: onTapValue,
                child: SizedBox(
                  height: _height,
                  width: _valueWidth,
                  child: Center(
                    child: Text(
                      text,
                      maxLines: 1,
                      softWrap: false,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              _Cap(icon: Icons.add, tooltip: '10분 더하기', onTap: onIncrease),
            ],
          ),
        ),
      ],
    );
  }
}

/// 시간 칸 양 끝을 채우는 ± 버튼.
///
/// 모서리는 칸이 잘라 준다(칸의 `clipBehavior`). 그래서 왼쪽 캡은 왼쪽만,
/// 오른쪽 캡은 오른쪽만 둥글게 보인다.
class _Cap extends StatelessWidget {
  const _Cap({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: scheme.secondaryContainer,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: ValueStepper._capWidth,
            height: ValueStepper._height,
            child: Icon(icon, size: 20, color: scheme.onSecondaryContainer),
          ),
        ),
      ),
    );
  }
}
