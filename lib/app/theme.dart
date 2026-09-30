import 'package:flutter/material.dart';

/// 앱 전체 테마. Material 3 기반이고, 하나의 시드 색에서 색 체계를 만든다.
///
/// 화면 코드에서는 색을 직접 쓰지 말고 `Theme.of(context).colorScheme.*` 로
/// 가져다 쓴다. 그래야 나중에 시드 색만 바꿔도 전체가 따라 바뀐다.
abstract final class AppTheme {
  static const _seed = Color(0xFF2B7FFF);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: _seed);
    return _base(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );
    return _base(scheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      // 모바일 세로 화면 기준이라 터치 영역을 넉넉하게 잡는다.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        // 하단 시트가 키보드/긴 목록에도 대응할 수 있게 스크롤 제어를 기본 허용.
        clipBehavior: Clip.antiAlias,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
