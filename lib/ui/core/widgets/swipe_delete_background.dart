import 'package:flutter/material.dart';

/// 줄을 밀 때 뒤에 보이는 삭제 표시.
///
/// [alignment]로 아이콘이 붙는 쪽을 정한다. 오른쪽으로 밀 때는 왼쪽에,
/// 왼쪽으로 밀 때는 오른쪽에 둔다(손가락이 가는 방향에 아이콘이 보인다).
class SwipeDeleteBackground extends StatelessWidget {
  const SwipeDeleteBackground({
    super.key,
    this.alignment = Alignment.centerRight,
  });

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final left = alignment == Alignment.centerLeft;
    return Container(
      alignment: alignment,
      padding: EdgeInsets.only(left: left ? 16 : 0, right: left ? 0 : 16),
      color: scheme.errorContainer,
      child: Icon(Icons.delete, color: scheme.onErrorContainer),
    );
  }
}
