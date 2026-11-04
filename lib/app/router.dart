import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/home/home_page.dart';
import '../ui/journal/entry/journal_entry_page.dart';
import '../ui/journal/review/tag_review_page.dart';
import '../ui/search/search_page.dart';
import 'app_shell.dart';
import 'app_tabs.dart';

// 이 파일과 짝이 되는 생성 코드. `dart run build_runner build`로 만들어진다.
part 'router.g.dart';

/// 앱 라우터.
///
/// `@riverpod`을 붙이면 빌드러너가 `routerProvider`를 만들어 준다.
/// 라우터를 프로바이더로 두면 나중에 "로그인 여부에 따라 리다이렉트" 같은
/// 다른 프로바이더 의존이 생겼을 때 `ref.watch`로 바로 연결할 수 있다.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: JournalRoutes.home,
    routes: [
      // 하단 내비게이션 탭. 브랜치 순서는 `AppTab` 순서와 같아야 한다.
      // indexedStack이라 탭을 바꿔도 각 탭 화면이 그대로 남는다.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppTab.journal.path,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppTab.search.path,
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
        ],
      ),
      // 아래는 셸 밖의 전체 화면 라우트다. 내비게이션 바가 보이지 않는다.
      // `/journal/new`가 `/journal/:id`보다 먼저 와야 'new'가 id로 잡히지 않는다.
      GoRoute(
        path: JournalRoutes.newJournal,
        builder: (context, state) => const JournalEntryPage(),
      ),
      GoRoute(
        path: '/journal/:id',
        builder: (context, state) =>
            JournalEntryPage(sessionId: int.parse(state.pathParameters['id']!)),
        routes: [
          GoRoute(
            path: 'tags',
            builder: (context, state) => TagReviewPage(
              sessionId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
    ],
  );
}

/// 경로 문자열 오타 방지용 상수 클래스
abstract final class JournalRoutes {
  static final home = AppTab.journal.path;
  static const newJournal = '/journal/new';

  static String entry(int sessionId) => '/journal/$sessionId';
  static String tagReview(int sessionId) => '/journal/$sessionId/tags';
}
