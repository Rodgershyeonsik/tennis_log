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

  /// 카드·입력칸·칩이 함께 쓰는 둥근 정도. 한 값에서만 나오게 모아 둔다.
  static const _radius = 14.0;

  static ThemeData _base(ColorScheme scheme) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: 'AstaSans',
      // 모바일 세로 화면 기준이라 터치 영역을 넉넉하게 잡는다.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      // 누를 때의 물결(ripple)과 음영을 모두 끈다. InkWell을 쓰는 곳(카드 안의
      // 줄, 칩, 분할 버튼, 목록)이 여기에 걸리고, 버튼류는 자기 `overlayColor`로
      // 눌림 색을 따로 칠하므로 아래 각 버튼 테마에서 투명으로 맞춰 둔다.
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
      // 입력 항목을 카드로 묶어 보여주므로, 카드는 그림자 없이 배경색으로만
      // 구분한다. 그림자를 쓰면 카드가 많은 화면이 금방 지저분해진다.
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius + 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        // 선택은 색으로 알 수 있어서 체크 표시는 뺀다(라벨이 짧아 더 복잡해 보인다).
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          overlayColor: Colors.transparent,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(overlayColor: Colors.transparent),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(overlayColor: Colors.transparent),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(overlayColor: Colors.transparent),
      ),
      switchTheme: const SwitchThemeData(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // 카드(surfaceContainerLow) 위에 올라가므로 한 단계 밝은 면으로 띄운다.
        filled: true,
        fillColor: scheme.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
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
