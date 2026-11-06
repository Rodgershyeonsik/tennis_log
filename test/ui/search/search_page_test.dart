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

/// 조회 화면의 메모 탭과 필터 시트.
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
  }

  Future<void> openFilterSheet(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ActionChip, '필터'));
    await tester.pumpAndSettle();
  }

  Future<void> openTagSheet(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilterChip, '태그'));
    await tester.pumpAndSettle();
  }

  Finder memoTab(int count) => find.widgetWithText(Tab, '메모 $count');

  Finder resultButton(int count) {
    return find.widgetWithText(FilledButton, '결과 보기 $count');
  }

  /// 시트 바깥(화면 맨 위)을 눌러 닫는다.
  Future<void> dismissSheet(WidgetTester tester) async {
    await tester.tapAt(const Offset(200, 10));
    await tester.pumpAndSettle();
  }

  testWidgets('메모 카드는 날짜, 장소, 본문 전체, 태그를 보여준다', (tester) async {
    final longMemo = '서브 토스가 흔들렸다. ' * 30;
    final session = await addSession(DateTime(2026, 10, 13), place: '귀뚜라미 실내');
    await addMemo(
      session,
      longMemo,
      evaluation: MemoEvaluation.bad,
      tags: ['서브'],
    );
    await pumpPage(tester);

    expect(memoTab(1), findsOneWidget);
    expect(find.text('26/10/13 화 · 귀뚜라미 실내'), findsOneWidget);
    final body = tester.widget<Text>(find.text(longMemo));
    expect(body.maxLines, isNull);
    expect(find.byIcon(Icons.thumb_down), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('평가가 없음이면 카드에 평가 아이콘을 두지 않는다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '그냥 메모');
    await pumpPage(tester);

    expect(find.text('그냥 메모'), findsOneWidget);
    expect(find.byIcon(Icons.remove_circle), findsNothing);

    await closePage(tester);
  });

  testWidgets('조회 대상이 아닌 일지 수를 안내하고, 없으면 숨긴다', (tester) async {
    final draft = await addSession(
      DateTime(2026, 10, 13),
      status: SessionStatus.draft,
      tagReviewed: false,
    );
    await addMemo(draft, '작성 중');
    await pumpPage(tester);

    expect(find.text('확인 완료 전 일지 1개는 빠졌어요'), findsOneWidget);

    await tester.runAsync(() async {
      await (db.delete(db.sessions)..where((t) => t.id.equals(draft))).go();
    });
    await tester.pumpAndSettle();

    expect(find.textContaining('빠졌어요'), findsNothing);

    await closePage(tester);
  });

  testWidgets('정렬을 바꾸면 세션 순서만 뒤집히고 세션 안은 쓴 순서다', (tester) async {
    final older = await addSession(DateTime(2026, 10, 12));
    final newer = await addSession(DateTime(2026, 10, 13));
    await addMemo(older, 'X-0');
    await addMemo(older, 'X-1', orderIndex: 1);
    await addMemo(newer, 'Y-0');
    await pumpPage(tester);

    double top(String text) => tester.getTopLeft(find.text(text)).dy;

    expect(top('Y-0'), lessThan(top('X-0')));
    expect(top('X-0'), lessThan(top('X-1')));

    await tester.tap(find.text('최신순'));
    await tester.pumpAndSettle();

    expect(find.text('오래된순'), findsOneWidget);
    expect(top('X-0'), lessThan(top('X-1')));
    expect(top('X-1'), lessThan(top('Y-0')));

    await closePage(tester);
  });

  testWidgets('요약 칩은 결과 안에서 좁혀 보고 건수와 필터는 바꾸지 않는다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '서브 메모', tags: ['서브']);
    await addMemo(session, '리턴 메모', orderIndex: 1, tags: ['리턴']);
    await addMemo(session, '발리 메모', orderIndex: 2, tags: ['발리']);
    await pumpPage(tester);
    await tester.tap(find.text('태그 요약'));
    await tester.pumpAndSettle();

    FilterChip chip(String label) {
      return tester.widget<FilterChip>(
        find.ancestor(of: find.text(label), matching: find.byType(FilterChip)),
      );
    }

    await tester.tap(find.text('리턴 1 ·'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(Tab, '메모 1 / 3'), findsOneWidget);
    expect(find.text('리턴 메모'), findsOneWidget);
    expect(find.text('서브 메모'), findsNothing);
    expect(chip('리턴 1 ·').selected, isTrue);
    expect(find.text('서브 1 ·'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, '태그'), findsOneWidget);

    await tester.tap(find.text('서브 1 ·'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(Tab, '메모 2 / 3'), findsOneWidget);
    expect(find.text('서브 메모'), findsOneWidget);
    expect(find.text('발리 메모'), findsNothing);

    await tester.tap(find.text('리턴 1 ·'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('서브 1 ·'));
    await tester.pumpAndSettle();

    expect(memoTab(3), findsOneWidget);
    expect(find.text('발리 메모'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('상위 필터가 바뀌면 좁혀 보기가 풀린다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(
      session,
      '못한 서브',
      evaluation: MemoEvaluation.bad,
      tags: ['서브'],
    );
    await addMemo(
      session,
      '못한 리턴',
      orderIndex: 1,
      evaluation: MemoEvaluation.bad,
      tags: ['리턴'],
    );
    await pumpPage(tester);
    await tester.tap(find.text('태그 요약'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('리턴 1 ·'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(Tab, '메모 1 / 2'), findsOneWidget);

    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'bad'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(2));
    await tester.pumpAndSettle();

    expect(memoTab(2), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('필터를 걸면 요약 칩도 결과 메모만 센다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(
      session,
      '못한 서브',
      evaluation: MemoEvaluation.bad,
      tags: ['서브'],
    );
    await addMemo(
      session,
      '잘한 서브',
      orderIndex: 1,
      evaluation: MemoEvaluation.good,
      tags: ['서브'],
    );
    await addMemo(
      session,
      '잘한 리턴',
      orderIndex: 2,
      evaluation: MemoEvaluation.good,
      tags: ['리턴'],
    );
    await pumpPage(tester);

    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'bad'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('태그 요약'));
    await tester.pumpAndSettle();

    expect(find.text('서브 1 ·'), findsOneWidget);
    expect(find.textContaining('리턴'), findsNothing);

    await closePage(tester);
  });

  testWidgets('정렬이 요약 카드 위에 놓인다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '서브 메모', tags: ['서브']);
    await pumpPage(tester);

    expect(
      tester.getTopLeft(find.text('최신순')).dy,
      lessThan(tester.getTopLeft(find.text('태그 요약')).dy),
    );

    await closePage(tester);
  });

  testWidgets('요약 카드는 접혀 있다가 눌러서 펼치고 접는다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '서브 메모', tags: ['서브']);
    await pumpPage(tester);

    expect(find.text('서브 1 ·'), findsNothing);

    await tester.tap(find.text('태그 요약'));
    await tester.pumpAndSettle();
    expect(find.text('서브 1 ·'), findsOneWidget);

    await tester.tap(find.text('태그 요약'));
    await tester.pumpAndSettle();
    expect(find.text('서브 1 ·'), findsNothing);

    await closePage(tester);
  });

  testWidgets('메모를 스크롤해도 요약 카드와 정렬은 그 자리에 있다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    for (var i = 0; i < 20; i++) {
      await addMemo(session, '메모 $i', orderIndex: i, tags: ['서브']);
    }
    await pumpPage(tester);

    final summaryTop = tester.getTopLeft(find.text('태그 요약')).dy;
    final sortTop = tester.getTopLeft(find.text('최신순')).dy;

    await tester.drag(find.text('메모 2'), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('메모 0'), findsNothing);
    expect(tester.getTopLeft(find.text('태그 요약')).dy, summaryTop);
    expect(tester.getTopLeft(find.text('최신순')).dy, sortTop);

    await closePage(tester);
  });

  testWidgets('태그가 많아도 펼친 요약 카드가 메모 자리를 남긴다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    final names = (await tester.runAsync(() => db.select(db.tags).get()))!
        .map((tag) => tag.name)
        .toList();
    await addMemo(session, '태그 많은 메모', tags: names);
    await pumpPage(tester);

    await tester.tap(find.text('태그 요약'));
    await tester.pumpAndSettle();

    final sortTop = tester.getTopLeft(find.text('최신순')).dy;
    expect(sortTop, lessThan(500));
    expect(tester.takeException(), isNull);

    await closePage(tester);
  });

  testWidgets('필터를 걸어도 칩 없이 필터 버튼의 개수로만 보여준다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '못한 메모', evaluation: MemoEvaluation.bad);
    await pumpPage(tester);

    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'bad'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(1));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ActionChip, '필터 1'), findsOneWidget);
    expect(find.byType(InputChip), findsNothing);

    await closePage(tester);
  });

  testWidgets('특정 장소를 고르면 표면과 실내·야외를 비우고 끈다', (tester) async {
    final now = DateTime(2026, 10, 1);
    await tester.runAsync(() async {
      await db
          .into(db.places)
          .insert(
            PlacesCompanion.insert(
              name: '남산 코트',
              surface: SurfaceType.clay,
              isIndoor: false,
              createdAt: Value(now),
              lastUsedAt: Value(now),
            ),
          );
    });
    await pumpPage(tester);
    await openFilterSheet(tester);

    FilterChip chip(String label) {
      return tester.widget<FilterChip>(find.widgetWithText(FilterChip, label));
    }

    await tester.tap(find.widgetWithText(FilterChip, '클레이'));
    await tester.pumpAndSettle();
    expect(chip('클레이').selected, isTrue);
    expect(find.text('특정 장소를 고르면 선택할 수 없어요'), findsNothing);

    final pickPlace = find.widgetWithText(ActionChip, '장소 선택');
    await tester.dragUntilVisible(
      pickPlace,
      find.byType(ListView).last,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(pickPlace);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '남산 코트'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, '완료'));
    await tester.pumpAndSettle();

    expect(chip('클레이').selected, isFalse);
    expect(chip('클레이').onSelected, isNull);
    expect(chip('실내').onSelected, isNull);
    expect(find.text('특정 장소를 고르면 선택할 수 없어요'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(chip('클레이').onSelected, isNotNull);
    expect(find.text('특정 장소를 고르면 선택할 수 없어요'), findsNothing);

    await closePage(tester);
  });

  testWidgets('시트의 변경은 결과 보기를 눌러야 적용되고 N이 따라 바뀐다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '잘한 메모', evaluation: MemoEvaluation.good);
    await addMemo(
      session,
      '못한 메모',
      orderIndex: 1,
      evaluation: MemoEvaluation.bad,
    );
    await pumpPage(tester);

    await openFilterSheet(tester);
    expect(resultButton(2), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'good'));
    await tester.pumpAndSettle();

    expect(resultButton(1), findsOneWidget);
    expect(memoTab(2), findsOneWidget);

    await tester.tap(resultButton(1));
    await tester.pumpAndSettle();

    expect(memoTab(1), findsOneWidget);
    expect(find.text('못한 메모'), findsNothing);
    expect(find.widgetWithText(ActionChip, '필터 1'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('시트를 위로 끌면 전체 높이까지 펼쳐진다', (tester) async {
    await pumpPage(tester);
    await openFilterSheet(tester);

    double sheetTop() => tester.getTopLeft(find.byType(BottomSheet)).dy;
    final initialTop = sheetTop();
    expect(initialTop, greaterThan(100));

    await tester.drag(find.text('평가'), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(sheetTop(), 0);

    await closePage(tester);
  });

  testWidgets('시트를 그냥 닫으면 적용하지 않는다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '못한 메모', evaluation: MemoEvaluation.bad);
    await pumpPage(tester);

    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'good'));
    await tester.pumpAndSettle();
    expect(resultButton(0), findsOneWidget);

    await dismissSheet(tester);

    expect(memoTab(1), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('초기화는 시트 안만 되돌리고 적용은 결과 보기에서 한다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '잘한 메모', evaluation: MemoEvaluation.good);
    await addMemo(
      session,
      '못한 메모',
      orderIndex: 1,
      evaluation: MemoEvaluation.bad,
    );
    await pumpPage(tester);
    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'good'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(1));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ActionChip, '필터 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('초기화'));
    await tester.pumpAndSettle();

    expect(resultButton(2), findsOneWidget);
    expect(memoTab(1), findsOneWidget);

    await tester.tap(resultButton(2));
    await tester.pumpAndSettle();

    expect(memoTab(2), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('범위를 최근 N세션으로 바꾸면 범위 칩에 N이 나온다', (tester) async {
    final older = await addSession(DateTime(2026, 10, 12));
    final newer = await addSession(DateTime(2026, 10, 13));
    await addMemo(older, '옛 메모');
    await addMemo(newer, '새 메모');
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ActionChip, '전체'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '최근 N세션'));
    await tester.pumpAndSettle();

    expect(find.text('10세션'), findsOneWidget);

    for (var i = 0; i < 9; i++) {
      await tester.tap(find.byTooltip('세션 수 줄이기'));
      await tester.pumpAndSettle();
    }

    expect(find.text('1세션'), findsOneWidget);
    expect(
      tester.widget<IconButton>(find.byType(IconButton).first).onPressed,
      isNull,
    );

    await tester.tap(resultButton(1));
    await tester.pumpAndSettle();

    expect(find.text('최근 1세션'), findsOneWidget);
    expect(find.text('새 메모'), findsOneWidget);
    expect(find.text('옛 메모'), findsNothing);

    await closePage(tester);
  });

  testWidgets('기간을 고르면 프리셋이 나오고 범위 칩에 반영된다', (tester) async {
    final session = await addSession(DateTime.now());
    await addMemo(session, '오늘 메모');
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ActionChip, '전체'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '기간'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '3개월'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(1));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ActionChip, '최근 3개월'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('태그를 고르면 시트를 닫지 않고 바로 적용되고 버튼에 이름이 나온다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '서브 메모', tags: ['서브']);
    await addMemo(session, '리턴 메모', orderIndex: 1, tags: ['리턴']);
    await addMemo(session, '발리 메모', orderIndex: 2, tags: ['발리']);
    await pumpPage(tester);

    await openTagSheet(tester);
    await tester.enterText(find.byType(TextField), '서브');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '서브'));
    await tester.pumpAndSettle();

    expect(memoTab(1), findsOneWidget);

    await tester.enterText(find.byType(TextField), '리턴');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '리턴'));
    await tester.pumpAndSettle();

    expect(memoTab(2), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '모두'));
    await tester.pumpAndSettle();

    expect(find.text('조건에 맞는 메모가 없어요.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '하나라도'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, '완료'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilterChip, '태그: 서브, 리턴'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('태그 시트 맨 위 칩을 누르면 그 태그가 빠진다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '서브 메모', tags: ['서브']);
    await addMemo(session, '태그 없는 메모', orderIndex: 1);
    await pumpPage(tester);

    await openTagSheet(tester);
    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '서브'));
    await tester.pumpAndSettle();

    expect(memoTab(1), findsOneWidget);
    expect(tester.getTopLeft(find.byType(InputChip)).dx, 16);

    await tester.tap(find.widgetWithText(InputChip, '서브'));
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsNothing);
    expect(memoTab(2), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('필터 시트 맨 위 칩을 누르면 그 조건이 빠지고 범위는 전체로 돌아간다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '못한 메모', evaluation: MemoEvaluation.bad);
    await addMemo(session, '그냥 메모', orderIndex: 1);
    await pumpPage(tester);

    await openFilterSheet(tester);
    expect(find.byType(InputChip), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'bad'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '최근 N세션'));
    await tester.pumpAndSettle();

    final top = tester.getTopLeft(find.widgetWithText(InputChip, 'bad')).dy;
    expect(top, lessThan(tester.getTopLeft(find.text('범위')).dy));
    expect(resultButton(1), findsOneWidget);

    await tester.tap(find.widgetWithText(InputChip, 'bad'));
    await tester.pumpAndSettle();

    expect(resultButton(2), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'bad'))
          .selected,
      isFalse,
    );

    await tester.tap(find.widgetWithText(InputChip, '최근 10세션'));
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsNothing);
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '전체')).selected,
      isTrue,
    );

    await closePage(tester);
  });

  testWidgets('모두 해제는 고른 태그를 한 번에 푼다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '서브 메모', tags: ['서브']);
    await addMemo(session, '태그 없는 메모', orderIndex: 1);
    await pumpPage(tester);

    await openTagSheet(tester);
    expect(find.text('모두 해제'), findsNothing);

    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '서브'));
    await tester.pumpAndSettle();
    expect(memoTab(1), findsOneWidget);

    await tester.tap(find.text('모두 해제'));
    await tester.pumpAndSettle();

    expect(memoTab(2), findsOneWidget);
    expect(find.text('모두 해제'), findsNothing);

    await closePage(tester);
  });

  testWidgets('펼친 분류는 시트를 다시 열어도 남아 있다', (tester) async {
    await pumpPage(tester);

    await openTagSheet(tester);
    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, '완료'));
    await tester.pumpAndSettle();

    await openTagSheet(tester);

    expect(find.widgetWithText(FilterChip, '서브'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('필터 시트의 초기화는 태그를 풀지 않고 빈 결과의 초기화는 푼다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(
      session,
      '못한 서브',
      evaluation: MemoEvaluation.bad,
      tags: ['서브'],
    );
    await addMemo(session, '태그 없는 메모', orderIndex: 1);
    await pumpPage(tester);

    await openTagSheet(tester);
    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '서브'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, '완료'));
    await tester.pumpAndSettle();

    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'good'));
    await tester.pumpAndSettle();
    expect(resultButton(0), findsOneWidget);

    await tester.tap(find.text('초기화'));
    await tester.pumpAndSettle();
    expect(resultButton(1), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'good'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('필터 초기화'));
    await tester.pumpAndSettle();

    expect(memoTab(2), findsOneWidget);
    expect(find.widgetWithText(FilterChip, '태그'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('분류 줄을 누르면 태그 칩이 펼쳐지고 자식은 부모 아래에 놓인다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    Finder tagChip(String name) => find.widgetWithText(FilterChip, name);

    expect(find.widgetWithText(ListTile, '기술'), findsOneWidget);
    expect(tagChip('서브'), findsNothing);

    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();

    expect(tagChip('서브'), findsOneWidget);
    final parent = tester.getTopLeft(tagChip('발리'));
    final child = tester.getTopLeft(tagChip('백발리'));
    expect(child.dy, greaterThan(parent.dy));
    expect(child.dx, greaterThan(parent.dx));

    await tester.tap(find.widgetWithText(ListTile, '풋워크'));
    await tester.pumpAndSettle();

    expect(tagChip('서브'), findsOneWidget);
    expect(tagChip('스플릿'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();

    expect(tagChip('서브'), findsNothing);
    expect(tagChip('스플릿'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('부모를 고르면 자식에 흐린 체크가 나온다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    Finder checkOf(String name) {
      return find.descendant(
        of: find.widgetWithText(FilterChip, name),
        matching: find.byIcon(Icons.check),
      );
    }

    await tester.tap(find.widgetWithText(ListTile, '기술'));
    await tester.pumpAndSettle();

    expect(checkOf('백발리'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, '발리'));
    await tester.pumpAndSettle();

    expect(checkOf('백발리'), findsOneWidget);
    expect(checkOf('포발리'), findsOneWidget);
    expect(checkOf('서브'), findsNothing);

    await closePage(tester);
  });

  testWidgets('접힌 분류 줄에 고른 태그 이름이 나오고 펼치면 사라진다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    final category = find.widgetWithText(ListTile, '기술');
    await tester.tap(category);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '서브'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, '리턴'));
    await tester.pumpAndSettle();

    expect(find.text('리턴, 서브'), findsNothing);

    await tester.tap(category);
    await tester.pumpAndSettle();

    expect(find.text('리턴, 서브'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('고른 태그가 많아도 분류 줄이 넘치지 않는다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    final category = find.widgetWithText(ListTile, '기술');
    await tester.tap(category);
    await tester.pumpAndSettle();
    for (final name in ['더블폴트', '로브', '리턴', '백핸드', '서브', '스매시', '포핸드']) {
      await tester.tap(find.widgetWithText(FilterChip, name));
      await tester.pumpAndSettle();
    }
    await tester.tap(category);
    await tester.pumpAndSettle();

    expect(find.text('더블폴트, 로브, 리턴, 백핸드, 서브, 스매시, 포핸드'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await closePage(tester);
  });

  testWidgets('분류 사이 구분선은 펼쳐도 그대로 있다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    final dividers = find.descendant(
      of: find.byType(BottomSheet).last,
      matching: find.byType(Divider),
    );
    expect(dividers, findsNWidgets(TagCategory.values.length - 1));

    await tester.tap(find.widgetWithText(ListTile, '폼'));
    await tester.pumpAndSettle();

    expect(dividers, findsNWidgets(TagCategory.values.length - 1));

    await closePage(tester);
  });

  testWidgets('검색하면 분류 줄을 숨기고 일치하는 태그만 보여준다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    await tester.enterText(find.byType(TextField), '스플');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilterChip, '스플릿'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '풋워크'), findsNothing);

    await tester.enterText(find.byType(TextField), '없는태그');
    await tester.pumpAndSettle();

    expect(find.text('일치하는 태그가 없어요.'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('태그 선택 시트에 보관된 태그는 나오지 않는다', (tester) async {
    await tester.runAsync(() async {
      await (db.update(db.tags)..where((t) => t.name.equals('서브'))).write(
        const TagsCompanion(isArchived: Value(true)),
      );
    });
    await pumpPage(tester);

    await openTagSheet(tester);
    await tester.enterText(find.byType(TextField), '서브');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilterChip, '서브'), findsNothing);

    await closePage(tester);
  });

  testWidgets('장소 선택 시트로 여러 장소를 고른다', (tester) async {
    final now = DateTime(2026, 10, 1);
    late int firstPlace;
    await tester.runAsync(() async {
      for (final name in ['귀뚜라미 실내', '남산 코트']) {
        final id = await db
            .into(db.places)
            .insert(
              PlacesCompanion.insert(
                name: name,
                surface: SurfaceType.hard,
                isIndoor: false,
                createdAt: Value(now),
                lastUsedAt: Value(now),
              ),
            );
        if (name == '귀뚜라미 실내') firstPlace = id;
      }
      final session = await db
          .into(db.sessions)
          .insert(
            SessionsCompanion.insert(
              date: now,
              placeId: Value(firstPlace),
              status: const Value(SessionStatus.complete),
              tagReviewed: const Value(true),
            ),
          );
      await addMemo(session, '장소 메모');
    });
    await pumpPage(tester);

    await openFilterSheet(tester);
    final pickPlace = find.widgetWithText(ActionChip, '장소 선택');
    await tester.dragUntilVisible(
      pickPlace,
      find.byType(ListView).last,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(pickPlace);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '남산 코트'));
    await tester.pumpAndSettle();
    await dismissSheet(tester);

    expect(find.widgetWithText(InputChip, '남산 코트'), findsOneWidget);
    expect(resultButton(0), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('키보드가 올라와도 태그 선택 시트가 넘치지 않는다', (tester) async {
    await pumpPage(tester);
    await openTagSheet(tester);

    tester.view.viewInsets = const FakeViewPadding(bottom: 400);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final field = tester.getBottomLeft(find.byType(TextField));
    expect(field.dy, lessThan(500));

    await closePage(tester);
  });

  testWidgets('결과가 없으면 안내와 필터 초기화를 보여주고 바로 적용한다', (tester) async {
    final session = await addSession(DateTime(2026, 10, 13));
    await addMemo(session, '못한 메모', evaluation: MemoEvaluation.bad);
    await pumpPage(tester);

    await openFilterSheet(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'good'));
    await tester.pumpAndSettle();
    await tester.tap(resultButton(0));
    await tester.pumpAndSettle();

    expect(find.text('조건에 맞는 메모가 없어요.'), findsOneWidget);

    await tester.tap(find.text('필터 초기화'));
    await tester.pumpAndSettle();

    expect(find.text('못한 메모'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);

    await closePage(tester);
  });
}
