import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_tabs.dart';

/// 하단 내비게이션 바가 있는 셸 화면.
///
/// 각 탭 화면은 [navigationShell] 안에 그대로 살아 있어서(indexedStack)
/// 탭을 바꿔도 스크롤 위치나 입력 상태가 남는다.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(int index) {
    // 지금 탭을 다시 누르면 그 탭의 첫 화면으로 돌아간다.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFirstTab = navigationShell.currentIndex == 0;

    // Android 뒤로가기: 첫 탭(일지)이 아니면 일지 탭으로 가고,
    // 일지 탭에서는 막지 않아 기본 동작(앱 종료)이 된다.
    return PopScope(
      canPop: isFirstTab,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(0);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _select,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            for (final tab in AppTab.values)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}
