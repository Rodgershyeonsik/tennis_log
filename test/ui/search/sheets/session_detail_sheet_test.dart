import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/app/theme.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/database_provider.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/ui/search/search_page.dart';
import 'package:tennis_log/ui/search/sheets/session_detail_sheet.dart';

/// 조회 화면의 메모 카드를 눌러 여는 세션 상세 시트.
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

  Future<int> addSession({
    SessionType sessionType = SessionType.game,
    int? startMinutes,
    int? endMinutes,
    String? cue,
    CueApplied? cueApplied,
    int? conditionScore,
    LastMealBucket? lastMeal,
  }) async {
    final cueId = cue == null
        ? null
        : await db.into(db.cues).insert(CuesCompanion.insert(cueText: cue));
    return db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: DateTime(2026, 10, 12),
            sessionType: Value(sessionType),
            startMinutes: Value(startMinutes),
            endMinutes: Value(endMinutes),
            placeNameSnapshot: const Value('고척'),
            isIndoorSnapshot: const Value(false),
            surfaceSnapshot: const Value(SurfaceType.hard),
            conditionScore: Value(conditionScore),
            lastMealBucket: Value(lastMeal),
            cueId: Value(cueId),
            cueApplied: Value(cueApplied),
            status: const Value(SessionStatus.complete),
            tagReviewed: const Value(true),
          ),
        );
  }

  Future<void> addMemo(int sessionId, String content, int orderIndex) {
    return db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: orderIndex,
            evaluation: const Value(MemoEvaluation.good),
            evaluationStatus: const Value(EvaluationStatus.confirmed),
          ),
        );
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

  /// 조회 결과의 메모 카드를 눌러 시트를 연다.
  Future<void> openDetail(WidgetTester tester, String memo) async {
    await tester.tap(find.text(memo));
    await tester.pumpAndSettle();
  }

  Finder inSheet(Finder finder) {
    return find.descendant(of: find.byType(BottomSheet), matching: finder);
  }

  testWidgets('제목에 날짜, 시간, 유형, 장소를 보여준다', (tester) async {
    final session = await addSession(startMinutes: 1200, endMinutes: 1350);
    await addMemo(session, '게임 메모', 0);
    await pumpPage(tester);

    await openDetail(tester, '게임 메모');

    expect(inSheet(find.text('게임')), findsOneWidget);
    expect(inSheet(find.text('2026년 10월 12일 월요일')), findsOneWidget);
    expect(inSheet(find.text('20:00 – 22:30 · 2시간 30분 소요')), findsOneWidget);
    expect(inSheet(find.text('고척 · 야외 하드')), findsOneWidget);
    // 시간과 장소 줄은 가운데에 둔다.
    double centerX(Finder finder) => tester.getCenter(inSheet(finder)).dx;
    expect(centerX(find.text('20:00 – 22:30 · 2시간 30분 소요')), closeTo(200, 1));
    // 유형과 날짜가 한 줄이다.
    double centerY(Finder finder) => tester.getCenter(inSheet(finder)).dy;
    expect(
      centerY(find.text('게임')),
      closeTo(centerY(find.text('2026년 10월 12일 월요일')), 2),
    );
    expect(inSheet(find.text('고척 · 야외 하드')), findsOneWidget);
    // 구분선으로 나누므로 라벨을 두지 않는다.
    expect(inSheet(find.text('세션 요약')), findsNothing);
    expect(inSheet(find.text('읽기 전용')), findsNothing);
    // 큐가 없는 게임이다.
    expect(inSheet(find.text('의식적으로 적용한 큐는 없었어요.')), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('컨디션·식사와 큐를 문장으로 쓴다', (tester) async {
    final session = await addSession(
      conditionScore: 2,
      lastMeal: LastMealBucket.h2to3,
      cue: '상대 임팩트 순간에 스플릿 착지',
      cueApplied: CueApplied.partial,
    );
    await addMemo(session, '게임 메모', 0);
    await pumpPage(tester);

    await openDetail(tester, '게임 메모');

    expect(inSheet(find.text('컨디션은 쏘쏘, 마지막 식사는 2–3시간 전이었어요.')), findsOneWidget);
    expect(
      inSheet(
        find.text(
          '상대 임팩트 순간에 스플릿 착지 큐를 적용하려고 했어요.\n'
          '게임 중에 큐를 어느 정도 적용했어요.',
        ),
      ),
      findsOneWidget,
    );

    await closePage(tester);
  });

  testWidgets('스코어는 유형별 한 줄의 표로 보여주고 이긴 경기를 강조한다', (tester) async {
    final session = await addSession();
    for (final (index, format, my) in [
      (0, GameFormat.singles, 3),
      (1, GameFormat.mixedDoubles, 6),
      (2, GameFormat.mixedDoubles, 5),
    ]) {
      await db
          .into(db.games)
          .insert(
            GamesCompanion.insert(
              sessionId: session,
              format: format,
              myScore: Value(my),
              opponentScore: Value(format == GameFormat.singles ? 6 : 4),
              orderIndex: index,
            ),
          );
    }
    await addMemo(session, '게임 메모', 0);
    await pumpPage(tester);

    await openDetail(tester, '게임 메모');

    expect(inSheet(find.text('스코어')), findsOneWidget);
    // 입력 순이 아니라 유형 순(혼복 → 단식)이고, 혼복 두 경기는 한 줄이다.
    double top(String text) => tester.getTopLeft(inSheet(find.text(text))).dy;
    expect(top('혼복'), lessThan(top('단식')));
    expect(top('6:4'), top('5:4'));
    expect(top('3:6'), greaterThan(top('6:4')));

    FontWeight? weight(String text) =>
        tester.widget<Text>(inSheet(find.text(text))).style?.fontWeight;
    expect(weight('6:4'), FontWeight.w700);
    expect(weight('3:6'), FontWeight.w400);

    await closePage(tester);
  });

  testWidgets('게임에 스코어가 없으면 문장만 쓴다', (tester) async {
    final session = await addSession();
    await addMemo(session, '게임 메모', 0);
    await pumpPage(tester);

    await openDetail(tester, '게임 메모');

    expect(inSheet(find.text('스코어는 기록하지 않았어요.')), findsOneWidget);
    expect(inSheet(find.text('스코어')), findsNothing);

    await closePage(tester);
  });

  testWidgets('레슨이면 큐와 스코어를 숨기고 기록이 없으면 그렇게 쓴다', (tester) async {
    final session = await addSession(
      sessionType: SessionType.lesson,
      cue: '라켓 먼저',
    );
    await addMemo(session, '레슨 메모', 0);
    await pumpPage(tester);

    await openDetail(tester, '레슨 메모');

    // 시작·종료가 없으면 시간 줄을 쓰지 않는다.
    expect(inSheet(find.text('2026년 10월 12일 월요일')), findsOneWidget);
    expect(inSheet(find.textContaining(':')), findsNothing);
    expect(inSheet(find.text('컨디션과 마지막 식사 기록이 없어요')), findsOneWidget);
    expect(inSheet(find.textContaining('라켓 먼저')), findsNothing);
    expect(inSheet(find.textContaining('스코어')), findsNothing);

    await closePage(tester);
  });

  testWidgets('누른 메모를 먼저 보여주고 다른 메모는 펼쳐야 보인다', (tester) async {
    final session = await addSession();
    await addMemo(session, '첫째 메모', 0);
    await addMemo(session, '둘째 메모', 1);
    await addMemo(session, '셋째 메모', 2);
    await pumpPage(tester);

    await openDetail(tester, '둘째 메모');

    double top(String text) => tester.getTopLeft(inSheet(find.text(text))).dy;
    expect(inSheet(find.text('둘째 메모')), findsOneWidget);
    expect(top('선택한 메모'), lessThan(top('둘째 메모')));
    expect(inSheet(find.text('첫째 메모')), findsNothing);
    expect(inSheet(find.text('셋째 메모')), findsNothing);

    await tester.tap(inSheet(find.text('같은 세션 다른 메모 2개 펼쳐보기')));
    await tester.pumpAndSettle();

    expect(top('둘째 메모'), lessThan(top('첫째 메모')));
    expect(top('첫째 메모'), lessThan(top('셋째 메모')));

    await tester.tap(inSheet(find.text('다른 메모 접기')));
    await tester.pumpAndSettle();

    expect(inSheet(find.text('첫째 메모')), findsNothing);

    await closePage(tester);
  });

  testWidgets('다른 메모가 없으면 펼치기를 두지 않는다', (tester) async {
    final session = await addSession();
    await addMemo(session, '하나뿐인 메모', 0);
    await pumpPage(tester);

    await openDetail(tester, '하나뿐인 메모');

    expect(inSheet(find.byType(TextButton)), findsNothing);

    await closePage(tester);
  });

  testWidgets('시트를 위로 끌면 전체 높이까지 펼쳐진다', (tester) async {
    final session = await addSession();
    await addMemo(session, '게임 메모', 0);
    await pumpPage(tester);
    await openDetail(tester, '게임 메모');

    double sheetTop() => tester.getTopLeft(find.byType(BottomSheet)).dy;
    // 처음에는 화면의 약 70%다(끌기 손잡이 높이만큼 더 올라온다).
    expect(sheetTop(), inInclusiveRange(200, 300));

    await tester.drag(inSheet(find.text('고척 · 야외 하드')), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(sheetTop(), 0);

    await closePage(tester);
  });

  group('문장', () {
    String? sentence({int? conditionScore, LastMealBucket? lastMeal}) {
      return conditionSentence(
        conditionScore: conditionScore,
        lastMeal: lastMeal,
      )?.toPlainText();
    }

    test('컨디션과 식사 값만 굵게 쓴다', () {
      final span = conditionSentence(
        conditionScore: 2,
        lastMeal: LastMealBucket.h2to3,
      )!;
      final bold = [
        for (final child in span.children!.cast<TextSpan>())
          if (child.style?.fontWeight == FontWeight.w700) child.text,
      ];
      expect(bold, ['쏘쏘', '2–3시간 전']);
    });

    test('받침에 따라 이었어요·였어요를 붙인다', () {
      expect(sentence(conditionScore: 3), '컨디션은 굿이었어요.');
      expect(sentence(conditionScore: 1), '컨디션은 별로였어요.');
      expect(sentence(lastMeal: LastMealBucket.within1h), '마지막 식사는 1시간 이내였어요.');
    });

    test('둘 다 없으면 null이다', () {
      expect(sentence(), isNull);
    });

    test('큐 적용 결과 문장은 세션 유형에 따라 게임·랠리 중이라고 쓴다', () {
      expect(
        cueResultSentence(SessionType.game, CueApplied.yes),
        '게임 중에 큐를 의식해서 적용했어요.',
      );
      expect(
        cueResultSentence(SessionType.practice, CueApplied.no),
        '랠리 중에 큐를 떠올리기 어려웠어요.',
      );
      expect(cueResultSentence(SessionType.game, null), isNull);
    });
  });

  testWidgets('맨 아래 내용이 Android 내비게이션 바에 가리지 않는다', (tester) async {
    tester.view.padding = const FakeViewPadding(bottom: 48);
    final session = await addSession();
    await addMemo(session, '긴 메모 ${'내용 ' * 300}', 0);
    await pumpPage(tester);
    await openDetail(tester, '긴 메모 ${'내용 ' * 300}');

    // 끝까지 끌어올리고 끝까지 스크롤한다.
    await tester.drag(inSheet(find.text('고척 · 야외 하드')), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.drag(
      inSheet(find.textContaining('긴 메모')),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();

    // 시트의 맨 아래 요소는 메모의 평가 아이콘(잘함)이다.
    expect(
      tester.getBottomLeft(inSheet(find.byIcon(Icons.thumb_up))).dy,
      lessThan(900 - 48),
    );

    await closePage(tester);
  });
}
