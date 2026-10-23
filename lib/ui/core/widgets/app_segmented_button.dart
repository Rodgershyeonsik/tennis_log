import 'package:flutter/material.dart';

/// 분할 버튼의 한 칸.
class AppSegment<T extends Object> {
  const AppSegment(this.value, this.label);

  final T value;
  final String label;
}

/// Material 기본 모양의 분할 버튼. 지금은 장소 등록 시트의 실내/야외에 쓴다.
///
/// 작성 화면의 세션 유형·컨디션·큐 적용은 모양을 직접 그리는 [SegmentedTabs]를
/// 쓴다. 이쪽은 시트 안에서 표면 칩과 나란히 놓이므로 **테두리 색을 칩과 같게**
/// 맞춘다.
///
/// [allowEmpty]가 true면 **선택된 칸을 다시 눌러 해제**할 수 있다. false면 항상
/// 하나가 선택돼 있어야 하므로 [value]가 null일 수 없다.
class AppSegmentedButton<T extends Object> extends StatelessWidget {
  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.allowEmpty = true,
  }) : assert(allowEmpty || value != null, '해제할 수 없는 분할 버튼은 항상 값이 있어야 한다.');

  final List<AppSegment<T>> segments;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool allowEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<T>(
        segments: [
          for (final segment in segments)
            ButtonSegment(value: segment.value, label: Text(segment.label)),
        ],
        selected: {if (value != null) value!},
        emptySelectionAllowed: allowEmpty,
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          minimumSize: const Size(0, 48),
          visualDensity: VisualDensity.standard,
          // 같은 시트의 표면 칩과 같은 테두리 색.
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          // 누를 때의 효과는 앱 전체에서 쓰지 않는다.
          overlayColor: Colors.transparent,
        ),
        // 단일 선택이라 집합에는 0개 또는 1개만 들어온다.
        onSelectionChanged: (selection) =>
            onChanged(selection.isEmpty ? null : selection.first),
      ),
    );
  }
}
