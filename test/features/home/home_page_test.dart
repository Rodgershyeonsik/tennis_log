import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/database_provider.dart';
import 'package:tennis_log/core/util/formatters.dart';
import 'package:tennis_log/features/home/presentation/home_page.dart';
import 'package:tennis_log/features/journal/data/session_repository.dart';

/// 메인 화면의 일지 목록. 진행 단계 배지와 2단계 바로가기를 본다.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  Future<void> closePage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(() => db.close());
  }

  Future<int> addSession(DateTime date) {
    return db.into(db.sessions).insert(SessionsCompanion.insert(date: date));
  }

  Future<void> addMemo(int sessionId, String content) async {
    await db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: 0,
          ),
        );
  }

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
        GoRoute(
          path: '/journal/:id',
          builder: (_, _) => const Text('1단계 화면'),
          routes: [
            GoRoute(path: 'tags', builder: (_, _) => const Text('태그 확인 화면')),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('일지가 없으면 안내 문구만 보여준다', (tester) async {
    await pumpPage(tester);

    expect(find.text('아직 쓴 일지가 없어요.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '새 일지 쓰기'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('진행 단계를 배지로 구분해 보여준다', (tester) async {
    final repo = SessionRepository(db);
    await addSession(DateTime(2026, 9, 29));
    final saved = await addSession(DateTime(2026, 9, 25));
    final reviewed = await addSession(DateTime(2026, 9, 20));
    await addMemo(saved, '저장까지 함');
    await addMemo(reviewed, '태그까지 봄');
    await repo.finalizeSession(saved);
    await repo.finalizeSession(reviewed);
    await repo.markTagReviewed(reviewed);

    await pumpPage(tester);

    expect(
      find.text(Formatters.dateWithWeekday(DateTime(2026, 9, 29))),
      findsOneWidget,
    );
    expect(find.text('작성 중'), findsOneWidget);
    expect(find.text('태그 확인 전'), findsOneWidget);
    expect(find.text('확인 완료'), findsOneWidget);
    expect(find.text('게임 · 장소 없음 · 메모 1'), findsNWidgets(2));

    await closePage(tester);
  });

  testWidgets('태그 버튼으로 2단계 화면에 바로 간다', (tester) async {
    final id = await addSession(DateTime(2026, 9, 29));
    await addMemo(id, '서브 개굿');
    await pumpPage(tester);

    await tester.tap(find.byTooltip('태그 확인'));
    await tester.pumpAndSettle();

    expect(find.text('태그 확인 화면'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('밀어서 지우면 실행 취소로 되돌릴 수 있다', (tester) async {
    final id = await addSession(DateTime(2026, 9, 29));
    await addMemo(id, '백발리 안 됨');
    await pumpPage(tester);

    expect(find.text('밀어서 삭제'), findsOneWidget);

    await tester.drag(
      find.text(Formatters.dateWithWeekday(DateTime(2026, 9, 29))),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(await db.select(db.sessions).get(), isEmpty);
    // 메모도 cascade로 함께 사라진다.
    expect(await db.select(db.memos).get(), isEmpty);
    expect(find.text('실행 취소'), findsOneWidget);

    await tester.tap(find.text('실행 취소'));
    await tester.pumpAndSettle();

    expect((await db.select(db.sessions).get()).single.id, id);
    expect((await db.select(db.memos).get()).single.content, '백발리 안 됨');

    await closePage(tester);
  });

  testWidgets('반대쪽으로 밀어도 지워지고 스낵바는 5초 뒤 사라진다', (tester) async {
    await addSession(DateTime(2026, 9, 29));
    await pumpPage(tester);

    await tester.drag(find.byTooltip('태그 확인'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(await db.select(db.sessions).get(), isEmpty);
    expect(find.text('실행 취소'), findsOneWidget);

    // SnackBar는 action이 있으면 persist가 기본 true라 duration을 무시한다.
    // 그걸 끈 게 유지되는지 지킨다.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('실행 취소'), findsNothing);

    await closePage(tester);
  });

  testWidgets('줄을 탭하면 1단계 화면으로 간다', (tester) async {
    await addSession(DateTime(2026, 9, 29));
    await pumpPage(tester);

    await tester.tap(
      find.text(Formatters.dateWithWeekday(DateTime(2026, 9, 29))),
    );
    await tester.pumpAndSettle();

    expect(find.text('1단계 화면'), findsOneWidget);

    await closePage(tester);
  });
}
