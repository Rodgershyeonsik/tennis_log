import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/app/app.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/database_provider.dart';

/// 하단 내비게이션 셸. 실제 앱 위젯([TennisLogApp])과 라우터로 띄운다.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  Future<void> closeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(() => db.close());
  }

  Future<int> addSession(DateTime date, {String? memo}) async {
    final id = await db
        .into(db.sessions)
        .insert(SessionsCompanion.insert(date: date));
    if (memo != null) {
      await db
          .into(db.memos)
          .insert(
            MemosCompanion.insert(sessionId: id, content: memo, orderIndex: 0),
          );
    }
    return id;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const TennisLogApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tab(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  testWidgets('탭을 눌러 일지와 조회를 오간다', (tester) async {
    await pumpApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('테니스 일지'), findsOneWidget);

    await tester.tap(tab('조회'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, '조회'), findsOneWidget);
    // 탭 화면이라 뒤로가기 버튼이 없다.
    expect(find.byType(BackButton), findsNothing);

    await tester.tap(tab('일지'));
    await tester.pumpAndSettle();
    expect(find.text('테니스 일지'), findsOneWidget);

    await closeApp(tester);
  });

  testWidgets('탭을 바꿔도 일지 목록 스크롤 위치가 남는다', (tester) async {
    for (var day = 1; day <= 20; day++) {
      await tester.runAsync(() => addSession(DateTime(2026, 10, day)));
    }
    await pumpApp(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    final scrolled = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(scrolled, greaterThan(0));

    await tester.tap(tab('조회'));
    await tester.pumpAndSettle();
    await tester.tap(tab('일지'));
    await tester.pumpAndSettle();

    final restored = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(restored, scrolled);

    await closeApp(tester);
  });

  testWidgets('작성 화면에서는 내비게이션 바가 보이지 않는다', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(FilledButton, '새 일지'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);

    await closeApp(tester);
  });

  testWidgets('태그 확인 화면에서는 내비게이션 바가 보이지 않는다', (tester) async {
    await tester.runAsync(() => addSession(DateTime(2026, 10, 1), memo: '서브'));
    await pumpApp(tester);

    await tester.tap(find.byTooltip('태그 확인'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);

    await closeApp(tester);
  });

  testWidgets('조회 탭에서 뒤로가기를 누르면 일지 탭으로 간다', (tester) async {
    await pumpApp(tester);

    await tester.tap(tab('조회'));
    await tester.pumpAndSettle();

    final handled = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // 앱을 끄지 않고 일지 탭으로 돌아왔다.
    expect(handled, isTrue);
    expect(find.text('테니스 일지'), findsOneWidget);

    await closeApp(tester);
  });

  testWidgets('실행 취소 스낵바가 내비게이션 바를 가리지 않는다', (tester) async {
    await tester.runAsync(() => addSession(DateTime(2026, 10, 1)));
    await pumpApp(tester);

    await tester.drag(find.text('26/10/1 목'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    final snackBar = tester.getRect(find.byType(SnackBar));
    final navigationBar = tester.getRect(find.byType(NavigationBar));

    expect(snackBar.bottom, lessThanOrEqualTo(navigationBar.top));

    await closeApp(tester);
  });
}
