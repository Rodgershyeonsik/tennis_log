import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/database_provider.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/ui/journal/entry/journal_entry_page.dart';

/// 1단계 화면의 자동 저장·저장 검증을 실제로 돌려 본다.
///
/// 순수 로직은 따로 단위 테스트가 있고(`session_time_math_test.dart`), 여기서는
/// 화면 → notifier → DB가 이어지는지(명세 4번)를 본다.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  /// 테스트 끝에 트리를 내리고 DB를 닫는다.
  ///
  /// 그냥 `tearDown`에서 닫으면 멈춘다. drift는 스트림 쿼리가 닫힐 때 0초
  /// 타이머를 만드는데, 위젯 트리가 사라진 뒤에는 그 타이머를 돌려줄 펌프가
  /// 없어서 `close()`가 끝나지 않는다. 그래서 트리를 먼저 내리고 한 번 더
  /// 펌프해 타이머를 흘려보낸 다음, 실제 비동기로 닫는다.
  Future<void> closePage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(() => db.close());
  }

  /// 디바운스(0.8초)보다 넉넉히 기다려 자동 저장을 끝낸다.
  Future<void> settleAutoSave(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  Future<void> pumpPage(WidgetTester tester, {int? sessionId}) async {
    // 세로로 긴 화면 하나에 모든 섹션이 들어가게 해서 스크롤 없이 찾는다.
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: JournalEntryPage(sessionId: sessionId)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<int> countSessions() async {
    final count = db.sessions.id.count();
    return (db.selectOnly(
      db.sessions,
    )..addColumns([count])).map((row) => row.read(count)!).getSingle();
  }

  testWidgets('열기만 하면 세션을 만들지 않는다', (tester) async {
    await pumpPage(tester);

    expect(find.text('새 일지 작성'), findsOneWidget);
    expect(await countSessions(), 0);
    // 저장 표시도 아직 없다.
    expect(find.text('자동 저장됨'), findsNothing);

    await closePage(tester);
  });

  testWidgets('첫 변경에 draft가 만들어지고 디바운스 후 저장된다', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('쏘쏘'));
    await tester.pump();
    expect(find.text('저장 중…'), findsOneWidget);

    await settleAutoSave(tester);

    expect(find.text('자동 저장됨'), findsOneWidget);
    expect(await countSessions(), 1);
    final session = await db.select(db.sessions).getSingle();
    expect(session.conditionScore, 2);
    expect(session.status, SessionStatus.draft);

    await closePage(tester);
  });

  testWidgets('메모 입력칸의 엔터로 메모가 추가되고 입력칸이 비워진다', (tester) async {
    await pumpPage(tester);

    await tester.enterText(
      find.widgetWithText(TextField, '메모 한 줄'),
      '백발리 안 됨\n',
    );
    await settleAutoSave(tester);

    final memos = await db.select(db.memos).get();
    expect(memos.map((m) => m.content), ['백발리 안 됨']);
    expect(find.text('메모 1'), findsOneWidget);
    // 입력칸은 비어 있다.
    expect(find.text('백발리 안 됨\n'), findsNothing);

    await closePage(tester);
  });

  testWidgets('여러 줄을 붙여 넣으면 줄마다 메모가 된다', (tester) async {
    await pumpPage(tester);

    await tester.enterText(
      find.widgetWithText(TextField, '메모 한 줄'),
      '포핸드 짧았음\n서브 개굿\n\n',
    );
    await settleAutoSave(tester);

    final memos = await db.select(db.memos).get();
    expect(memos.map((m) => m.content), ['포핸드 짧았음', '서브 개굿']);

    await closePage(tester);
  });

  testWidgets('장소 없이 저장하면 인라인 오류를 보여주고 complete로 바꾸지 않는다', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.widgetWithText(TextField, '메모 한 줄'), '서브 개굿\n');
    await settleAutoSave(tester);

    await tester.tap(find.widgetWithText(FilledButton, '일지 저장'));
    await tester.pumpAndSettle();

    expect(find.text('장소를 선택해 주세요.'), findsOneWidget);
    final session = await db.select(db.sessions).getSingle();
    expect(session.status, SessionStatus.draft);
    expect(session.placeNameSnapshot, null);

    await closePage(tester);
  });

  testWidgets('장소를 등록하면 바로 선택되고 정보 줄이 보인다', (tester) async {
    await db
        .into(db.places)
        .insert(
          PlacesCompanion.insert(
            name: '귀뚜라미 실내',
            surface: SurfaceType.hard,
            isIndoor: true,
          ),
        );
    await pumpPage(tester);

    await tester.tap(find.text('귀뚜라미 실내'));
    await settleAutoSave(tester);

    expect(find.text('실내 · 하드'), findsOneWidget);
    final session = await db.select(db.sessions).getSingle();
    expect(session.placeId, isNotNull);

    await closePage(tester);
  });

  testWidgets('메모 수정 시트에서 삭제하면 지워지고 실행 취소가 뜬다', (tester) async {
    await pumpPage(tester);

    await tester.enterText(
      find.widgetWithText(TextField, '메모 한 줄'),
      '백발리 안 됨\n',
    );
    await settleAutoSave(tester);

    Future<void> deleteFromSheet() async {
      await tester.tap(find.text('백발리 안 됨'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, '삭제'));
      await tester.pumpAndSettle();
    }

    await deleteFromSheet();
    expect(await db.select(db.memos).get(), isEmpty);
    expect(find.text('실행 취소'), findsOneWidget);

    // 실행 취소하면 태그 연결까지 그대로 돌아온다.
    await tester.tap(find.text('실행 취소'));
    await tester.pumpAndSettle();
    expect((await db.select(db.memos).get()).length, 1);

    // 다시 지우면 스낵바가 5초 뒤 저절로 사라진다. SnackBar는 action이 있으면
    // persist가 기본 true라 duration을 무시하므로, 그걸 끈 게 유지되는지 지킨다.
    await deleteFromSheet();
    expect(find.text('실행 취소'), findsOneWidget);
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('실행 취소'), findsNothing);

    await settleAutoSave(tester);
    await closePage(tester);
  });

  testWidgets('장소 더보기 시트에서 검색하고 없으면 새 장소로 추가한다', (tester) async {
    for (final name in ['강남 실내', '귀뚜라미 실내']) {
      await db
          .into(db.places)
          .insert(
            PlacesCompanion.insert(
              name: name,
              surface: SurfaceType.hard,
              isIndoor: true,
            ),
          );
    }
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ActionChip, '더보기'));
    await tester.pumpAndSettle();

    // 검색하려고 키보드가 올라와도 시트가 화면을 넘치지 않는다.
    tester.view.viewInsets = const FakeViewPadding(bottom: 400);
    await tester.pump();
    expect(tester.takeException(), isNull);
    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pump();

    // 검색어가 없으면 이름 오름차순으로 다 보인다.
    expect(find.widgetWithText(ListTile, '강남 실내'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '귀뚜라미 실내'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '장소 검색'), '양재');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, '강남 실내'), findsNothing);
    expect(find.text("'양재' 새 장소로 추가"), findsOneWidget);

    // 추가 항목 → 등록 시트가 열린다. 이름을 더 치지 않고 바로 저장할 수 있다는
    // 것 자체가 검색어가 채워져 들어왔다는 뜻이다(비어 있으면 오류가 난다).
    await tester.tap(find.text("'양재' 새 장소로 추가"));
    await tester.pumpAndSettle();
    expect(find.text('장소 등록'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, '저장'));
    await settleAutoSave(tester);

    // 등록한 장소가 바로 선택된다.
    final session = await db.select(db.sessions).getSingle();
    final place = await (db.select(
      db.places,
    )..where((t) => t.name.equals('양재'))).getSingle();
    expect(session.placeId, place.id);

    await closePage(tester);
  });

  testWidgets('키보드가 올라와 있는 동안에는 저장 바를 감춘다', (tester) async {
    await pumpPage(tester);

    expect(find.widgetWithText(FilledButton, '일지 저장'), findsOneWidget);

    // 키보드가 올라온 상태를 흉내 낸다.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    expect(find.widgetWithText(FilledButton, '일지 저장'), findsNothing);

    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pump();
    expect(find.widgetWithText(FilledButton, '일지 저장'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('스코어는 세션 유형이 게임일 때만 보인다', (tester) async {
    await pumpPage(tester);

    expect(find.text('스코어'), findsOneWidget);

    await tester.tap(find.text('레슨'));
    await settleAutoSave(tester);

    expect(find.text('스코어'), findsNothing);

    await closePage(tester);
  });

  testWidgets('스코어 시트는 추가해도 닫히지 않고, 칩을 누르면 지워진다', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byTooltip('스코어 편집'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, '추가'));
    await tester.pumpAndSettle();

    // 시트가 그대로 열려 있고, 방금 넣은 스코어가 목록에 보인다.
    expect(find.widgetWithText(FilledButton, '추가'), findsOneWidget);
    expect(find.text('누르면 삭제돼요'), findsOneWidget);
    expect((await db.select(db.games).get()).length, 1);

    await tester.tap(find.widgetWithText(InputChip, '혼복 0 : 0'));
    await tester.pumpAndSettle();

    expect(await db.select(db.games).get(), isEmpty);

    // 시트는 바깥을 눌러 닫는다(닫기 버튼은 두지 않는다).
    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();
    await settleAutoSave(tester);

    await closePage(tester);
  });

  testWidgets('± 버튼은 시작과 종료를 각각 10분 단위로 움직인다', (tester) async {
    await pumpPage(tester);

    // 기본값 18:00~20:00
    expect(find.text('18:00'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);

    // 시작의 + 버튼. 종료는 따라 움직이지 않는다.
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    expect(find.text('18:10'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);

    await settleAutoSave(tester);
    final session = await db.select(db.sessions).getSingle();
    expect(session.startMinutes, 1090);
    expect(session.endMinutes, 1200);

    await closePage(tester);
  });
}
