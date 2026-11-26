import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/app/theme.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/database_provider.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/data/repositories/tag_repository.dart';
import 'package:tennis_log/ui/search/search_page.dart';
import 'package:tennis_log/ui/search/widgets/evaluation_count.dart';

/// 조회 화면의 태그 통계 탭: 차트 카드.
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

  Future<int> addSession(
    DateTime date, {
    String? place,
    SessionStatus status = SessionStatus.complete,
    bool tagReviewed = true,
  }) {
    return db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: date,
            placeNameSnapshot: Value(place),
            status: Value(status),
            tagReviewed: Value(tagReviewed),
          ),
        );
  }

  Future<void> addMemo(
    int sessionId,
    String content, {
    int orderIndex = 0,
    MemoEvaluation evaluation = MemoEvaluation.none,
    List<String> tags = const [],
  }) async {
    final memoId = await db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: orderIndex,
            evaluation: Value(evaluation),
            evaluationStatus: const Value(EvaluationStatus.confirmed),
          ),
        );
    for (final name in tags) {
      final tag = await TagRepository(db).findByName(name);
      await db
          .into(db.memoTags)
          .insert(
            MemoTagsCompanion.insert(
              memoId: memoId,
              tagId: tag!.id,
              source: MemoTagSource.manual,
              status: MemoTagStatus.confirmed,
            ),
          );
    }
  }

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(theme: AppTheme.light(), home: const SearchPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('태그 통계'));
    await tester.pumpAndSettle();
  }

  /// 메모가 하나씩 있는 세션 [count]개. 10/1부터 하루씩이다.
  Future<List<int>> addSessions(int count) async {
    final ids = <int>[];
    for (var i = 0; i < count; i++) {
      final id = await addSession(DateTime(2026, 10, 1 + i));
      await addMemo(id, '메모 $i', evaluation: MemoEvaluation.good);
      ids.add(id);
    }
    return ids;
  }

  Finder chartTagButton() =>
      find.byWidgetPredicate((widget) => widget is PopupMenuButton);

  Future<void> pickChartTag(WidgetTester tester, String label) async {
    await tester.tap(chartTagButton());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(label).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  Future<void> applyFilter(WidgetTester tester, String chip) async {
    await tester.tap(find.widgetWithText(ActionChip, '필터'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilterChip, chip));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, chip));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('결과 보기'));
    await tester.pumpAndSettle();
  }

  Finder chartList() => find.byWidgetPredicate(
    (widget) => widget is ListView && widget.scrollDirection == Axis.horizontal,
  );

  double chartOffset(WidgetTester tester) {
    return tester.widget<ListView>(chartList()).controller!.offset;
  }

  /// 선택한 세션 줄의 good, bad, ?, none 건수.
  List<int> selectedCounts(WidgetTester tester) {
    return [
      for (final widget in tester.widgetList<EvaluationCount>(
        find.byType(EvaluationCount),
      ))
        widget.count,
    ];
  }

  /// 최신 세션(일요일 10/11)과 그 전 세션.
  Future<void> addTagged() async {
    final older = await addSession(DateTime(2026, 10, 10));
    await addMemo(older, '포핸드', evaluation: MemoEvaluation.bad, tags: ['포핸드']);
    final newer = await addSession(DateTime(2026, 10, 11));
    await addMemo(newer, '서브', evaluation: MemoEvaluation.good, tags: ['서브']);
    await addMemo(newer, '기타', orderIndex: 1);
  }

  testWidgets('기간과 최신 세션의 평가 건수를 0까지 보여준다', (tester) async {
    await addTagged();
    await pumpPage(tester);

    expect(find.text('26/10/10 토 – 26/10/11 일'), findsOneWidget);
    expect(find.text('26/10/11 일'), findsOneWidget);
    expect(selectedCounts(tester), [1, 0, 0, 1]);
    expect(find.text('10/10'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('세션이 하나면 기간에 날짜 하나만 쓴다', (tester) async {
    await addSessions(1);
    await pumpPage(tester);

    // 기간과 선택한 세션 줄
    expect(find.text('26/10/1 목'), findsNWidgets(2));
    expect(find.textContaining('–'), findsNothing);

    await closePage(tester);
  });

  testWidgets('열을 누르면 선택되고 차트 태그를 바꿔도 유지된다', (tester) async {
    await addTagged();
    await pumpPage(tester);

    await tester.tap(find.text('10/10'));
    await tester.pumpAndSettle();
    expect(find.text('26/10/10 토'), findsOneWidget);
    expect(selectedCounts(tester), [0, 1, 0, 0]);

    await pickChartTag(tester, '#서브');
    expect(find.text('26/10/10 토'), findsOneWidget);
    expect(selectedCounts(tester), [0, 0, 0, 0]);
    expect(find.text('10/11'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('드롭다운은 기술·상황만, 자식을 부모 아래에 들여 보여준다', (tester) async {
    await addTagged();
    await pumpPage(tester);
    await tester.tap(chartTagButton());
    await tester.pumpAndSettle();

    expect(find.text('기술'), findsOneWidget);
    expect(find.text('상황'), findsOneWidget);
    expect(find.text('폼'), findsNothing);
    final parent = tester.getTopLeft(find.text('#발리'));
    final child = tester.getTopLeft(find.text('#백발리'));
    expect(child.dx, greaterThan(parent.dx));
    expect(child.dy, greaterThan(parent.dy));

    // 메뉴는 버튼 아래에 버튼 오른쪽 끝에 맞춰 열린다.
    final button = tester.getRect(chartTagButton());
    final item = tester.getRect(
      find.ancestor(
        of: find.text('태그 전체').last,
        matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
      ),
    );
    expect(item.right, moreOrLessEquals(button.right));
    // 버튼은 알약 크기만 차지하고 카드 안쪽 오른쪽 끝에 붙는다.
    expect(button.right, tester.getRect(find.byType(Card)).right - 12);
    expect(button.width, lessThan(180));
    expect(item.top, greaterThan(button.bottom));

    // 바깥을 누르면 바뀌지 않고 닫힌다.
    await tester.tapAt(const Offset(10, 890));
    await tester.pumpAndSettle();
    expect(find.text('태그 전체'), findsOneWidget);
    expect(find.text('#발리'), findsNothing);

    await pickChartTag(tester, '#서브');
    expect(find.text('#서브'), findsOneWidget);
    await pickChartTag(tester, '태그 전체');
    expect(find.text('태그 전체'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('열이 다 들어가면 스크롤 안내를 숨기고 왼쪽부터 채운다', (tester) async {
    await addSessions(3);
    await pumpPage(tester);

    expect(find.textContaining('좌우로 밀어서'), findsNothing);
    expect(find.byIcon(Icons.chevron_left), findsNothing);
    expect(tester.getCenter(find.text('10/1')).dx, lessThan(100));

    await closePage(tester);
  });

  testWidgets('처음엔 오른쪽 끝이고 태그만 바꾸면 스크롤을 유지한다', (tester) async {
    await addSessions(12);
    await pumpPage(tester);

    expect(find.text('10/12'), findsOneWidget);
    expect(find.text('10/1'), findsNothing);
    expect(find.textContaining('좌우로 밀어서'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);

    await tester.drag(chartList(), const Offset(100, 0));
    await tester.pumpAndSettle();
    final offset = chartOffset(tester);
    expect(offset, greaterThan(0));
    // 오른쪽 흐림과 '세션 보기'
    expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));

    await pickChartTag(tester, '#서브');
    expect(chartOffset(tester), offset);

    await tester.tap(find.textContaining('메모 12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('태그 통계'));
    await tester.pumpAndSettle();
    expect(chartOffset(tester), offset);
    expect(find.text('#서브'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('세션 목록이 바뀌면 최신 세션과 오른쪽 끝으로 돌아간다', (tester) async {
    final ids = await addSessions(12);
    await pumpPage(tester);
    await tester.drag(chartList(), const Offset(400, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10/2'));
    await tester.pumpAndSettle();
    expect(find.text('26/10/2 금'), findsOneWidget);

    await tester.runAsync(() async {
      await (db.delete(db.sessions)..where((t) => t.id.equals(ids.last))).go();
    });
    await tester.pumpAndSettle();

    expect(find.text('26/10/11 일'), findsOneWidget);
    expect(chartOffset(tester), 0);

    await closePage(tester);
  });

  testWidgets('평가 필터는 통계에 적용하지 않고 안내만 보여준다', (tester) async {
    await addTagged();
    await pumpPage(tester);
    expect(find.textContaining('통계에 적용되지 않아요'), findsNothing);
    await tester.tap(find.text('10/10'));
    await tester.pumpAndSettle();

    await applyFilter(tester, 'good');

    expect(find.text('평가·태그 필터는 통계에 적용되지 않아요'), findsOneWidget);
    expect(find.text('26/10/10 토 – 26/10/11 일'), findsOneWidget);
    // 세션 목록이 그대로라 선택도 그대로다.
    expect(selectedCounts(tester), [0, 1, 0, 0]);

    await closePage(tester);
  });

  testWidgets('세션 보기는 모든 메모를 펼친 세션 상세 시트를 연다', (tester) async {
    await addTagged();
    await pumpPage(tester);
    await tester.tap(find.text('세션 보기'));
    await tester.pumpAndSettle();

    expect(find.text('메모 2'), findsOneWidget);
    expect(find.text('선택한 메모'), findsNothing);

    await closePage(tester);
  });

  testWidgets('세션이 없으면 안내하고 필터 초기화로 돌아온다', (tester) async {
    await addTagged();
    await pumpPage(tester);
    await applyFilter(tester, '레슨');

    expect(find.text('조건에 맞는 세션이 없어요.'), findsOneWidget);
    expect(find.text('세션별 평가 추이'), findsNothing);

    await tester.tap(find.text('필터 초기화'));
    await tester.pumpAndSettle();
    expect(find.text('세션별 평가 추이'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('좁은 폭과 큰 글씨에서도 넘치지 않는다', (tester) async {
    await addSessions(12);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(tester);
    tester.view.physicalSize = const Size(340, 700);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    await closePage(tester);
  });
}
