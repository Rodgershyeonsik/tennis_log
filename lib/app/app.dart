import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

/// 앱 루트 위젯.
///
/// `ConsumerWidget`은 Riverpod이 주는 위젯으로, build에 `WidgetRef ref`가 하나
/// 더 들어온다. 이 `ref`로 프로바이더 값을 읽는다.
class TennisLogApp extends ConsumerWidget {
  const TennisLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(routerProvider): routerProvider가 만든 GoRouter를 가져오고,
    // 그 값이 바뀌면 이 위젯을 다시 빌드한다.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '테니스 일지',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
