import 'package:flutter/material.dart';

/// 하단 내비게이션 탭 목록.
///
/// 라우터의 셸 브랜치와 `NavigationBar`가 모두 이 목록의 순서를 따른다.
/// 탭을 추가할 때는 여기에 값을 하나 넣고, 라우터에 같은 순서로 브랜치를 넣는다.
enum AppTab {
  journal(
    path: '/',
    label: '일지',
    icon: Icons.book_outlined,
    selectedIcon: Icons.book,
  ),
  search(
    path: '/search',
    label: '조회',
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
  );

  const AppTab({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  /// 탭의 첫 화면 경로.
  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
