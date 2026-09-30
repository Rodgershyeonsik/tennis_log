import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  // ProviderScope는 Riverpod의 프로바이더 값들이 실제로 저장되는 곳이다.
  // 앱 최상단을 이걸로 감싸야 하위 위젯에서 ref로 프로바이더를 읽을 수 있다.
  runApp(const ProviderScope(child: TennisLogApp()));
}
