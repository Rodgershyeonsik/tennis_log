import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 점선 테두리를 그려 주는 껍데기.
///
/// 태그 확인 화면(2단계)에서 **"아직 확인하지 않은 추천"** 을 점선으로 표시한다
/// (명세 5번: suggested 태그 칩, suggested 평가 아이콘). Flutter의
/// `Border`·`OutlineInputBorder`는 실선만 그릴 수 있어서 직접 그린다.
class DashedBorder extends StatelessWidget {
  const DashedBorder({
    super.key,
    required this.child,
    required this.color,
    required this.radius,
    this.strokeWidth = 1.2,
    this.dashLength = 3.5,
    this.gapLength = 3,
  });

  final Widget child;
  final Color color;

  /// 둥근 정도. 감싸는 쪽(칩, 아이콘 버튼)의 값과 맞춰서 넘긴다.
  final double radius;

  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // 자식이 불투명한 면을 깔아도 테두리가 가려지지 않게 위에 그린다.
      foregroundPainter: _DashedBorderPainter(
        color: color,
        radius: radius,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    // 선은 경로를 가운데 두고 그려지므로, 절반만큼 안으로 들여야 테두리가
    // 위젯 바깥으로 삐져나오지 않는다.
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    if (rect.isEmpty) return;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius - inset)),
      );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 경로를 따라가며 dash 길이만큼만 잘라 그린다.
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) {
    return old.color != color ||
        old.radius != radius ||
        old.strokeWidth != strokeWidth ||
        old.dashLength != dashLength ||
        old.gapLength != gapLength;
  }
}
