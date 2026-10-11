import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/database_provider.dart';
import 'package:tennis_log/core/db/enums.dart';
import 'package:tennis_log/features/journal/presentation/review/tag_review_page.dart';
import 'package:tennis_log/features/journal/presentation/review/widgets/chip_metrics.dart';
import 'package:tennis_log/features/journal/presentation/review/widgets/tag_status_chip.dart';
import 'package:tennis_log/features/journal/presentation/widgets/dashed_border.dart';

/// 2단계 화면(명세 5번)을 실제로 돌려 본다.
///
/// 리포지토리 단위 테스트가 쓰기 규칙을 이미 지키고 있으므로, 여기서는
/// **화면의 조작이 그 쓰기로 이어지고 화면이 따라 바뀌는지**를 본다.
void main() {
  late AppDatabase db;
  late int sessionId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    sessionId = await db
        .into(db.sessions)
        .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 29)));
  });

  /// 트리를 먼저 내리고 한 번 더 펌프한 다음 DB를 닫는다.
  ///
  /// drift는 스트림 쿼리가 닫힐 때 0초 타이머를 만드는데, 위젯 트리가 사라진
  /// 뒤에는 그 타이머를 돌려줄 펌프가 없어서 `close()`가 끝나지 않는다.
  Future<void> closePage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(() => db.close());
  }

  Future<int> tagId(String name) async {
    final tag =
        await (db.select(db.tags)
              ..where((t) => t.name.equals(name))
              ..limit(1))
            .getSingle();
    return tag.id;
  }

  Future<int> addMemo(
    String content, {
    MemoEvaluation? evaluation,
    EvaluationStatus? evaluationStatus,
  }) async {
    final memo = await db
        .into(db.memos)
        .insertReturning(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: 0,
            evaluation: Value(evaluation),
            evaluationStatus: Value(evaluationStatus),
          ),
        );
    return memo.id;
  }

  Future<void> link(
    int memoId,
    String tagName, {
    MemoTagStatus status = MemoTagStatus.suggested,
  }) async {
    await db
        .into(db.memoTags)
        .insert(
          MemoTagsCompanion.insert(
            memoId: memoId,
            tagId: await tagId(tagName),
            source: MemoTagSource.auto,
            status: status,
          ),
        );
  }

  Future<Memo> readMemo(int memoId) {
    return (db.select(db.memos)..where((t) => t.id.equals(memoId))).getSingle();
  }

  Future<MemoTag> readLink(int memoId, String tagName) async {
    final tag = await tagId(tagName);
    return (db.select(
      db.memoTags,
    )..where((t) => t.memoId.equals(memoId) & t.tagId.equals(tag))).getSingle();
  }

  /// 화면을 띄운다. `context.go`/`context.pop`을 쓰므로 라우터가 필요하다.
  ///
  /// 앱 라우터를 그대로 쓰면 1단계 화면까지 끌고 와야 해서, 같은 모양의
  /// 작은 라우터를 둔다 — "완료"가 메인으로 가는 것까지 볼 수 있다.
  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/journal/$sessionId/tags',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('메인 화면')),
        GoRoute(
          path: '/journal/:id',
          builder: (_, _) => const Text('1단계 화면'),
          routes: [
            GoRoute(
              path: 'tags',
              builder: (_, state) => TagReviewPage(
                sessionId: int.parse(state.pathParameters['id']!),
              ),
            ),
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

  testWidgets('suggested 태그 칩을 탭하면 confirmed가 된다', (tester) async {
    final memoId = await addMemo('백발리 여전히 안 됨');
    await link(memoId, '백발리');
    await pumpPage(tester);

    expect(find.text('추천 태그/평가는 점선으로 표시돼요. 터치하면 태그/평가가 확정돼요.'), findsOneWidget);
    expect(find.text('백발리'), findsOneWidget);

    await tester.tap(find.text('백발리'));
    await tester.pumpAndSettle();

    expect((await readLink(memoId, '백발리')).status, MemoTagStatus.confirmed);
    // 확정된 뒤에도 칩은 그대로 보인다(실선으로 바뀔 뿐이다).
    expect(find.text('백발리'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('칩의 x를 누르면 화면에서 사라지고 rejected로 남는다', (tester) async {
    final memoId = await addMemo('백발리 여전히 안 됨');
    await link(memoId, '백발리', status: MemoTagStatus.confirmed);
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('백발리'), findsNothing);
    // 지워 버리면 다음 저장 때 자동 태그가 다시 붙이므로 기억으로 남긴다.
    expect((await readLink(memoId, '백발리')).status, MemoTagStatus.rejected);

    await closePage(tester);
  });

  testWidgets('평가 아이콘을 누르면 confirmed가 되고 다시 누르면 해제된다', (tester) async {
    final memoId = await addMemo('오늘 서브 개굿');
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.thumb_up_outlined));
    await tester.pumpAndSettle();

    var memo = await readMemo(memoId);
    expect(memo.evaluation, MemoEvaluation.good);
    expect(memo.evaluationStatus, EvaluationStatus.confirmed);
    // 고른 아이콘은 채워진 모양으로 바뀐다.
    expect(find.byIcon(Icons.thumb_up), findsOneWidget);

    await tester.tap(find.byIcon(Icons.thumb_up));
    await tester.pumpAndSettle();

    memo = await readMemo(memoId);
    expect(memo.evaluation, isNull);
    expect(memo.evaluationStatus, isNull);

    await closePage(tester);
  });

  /// 아이콘을 감싼 Material의 모양·면을 읽어 평가 버튼의 모습을 확인한다.
  Material materialOf(WidgetTester tester, IconData icon) {
    return tester.widget<Material>(
      find
          .ancestor(of: find.byIcon(icon), matching: find.byType(Material))
          .first,
    );
  }

  /// 네모 모양인지, 둥근 정도가 태그 칩과 같은지 본다.
  void expectChipShape(Material material, {required bool hasBorder}) {
    final shape = material.shape as RoundedRectangleBorder;
    expect(
      shape.borderRadius,
      BorderRadius.circular(ChipMetrics.radius),
      reason: '둥근 정도는 태그 칩과 같아야 한다',
    );
    expect(shape.side.style, hasBorder ? BorderStyle.solid : BorderStyle.none);
  }

  testWidgets('고르지 않은 평가 버튼은 실선 테두리에 흰 면이다', (tester) async {
    await addMemo('포칭으로 두 번 먹힘');
    await pumpPage(tester);

    final scheme = ThemeData().colorScheme;
    for (final icon in [
      Icons.thumb_up_outlined,
      Icons.thumb_down_outlined,
      Icons.help_outline,
    ]) {
      final material = materialOf(tester, icon);
      expect(material.color, scheme.surface);
      expectChipShape(material, hasBorder: true);
      expect(
        (material.shape as RoundedRectangleBorder).side.color,
        scheme.outlineVariant,
        reason: '$icon은 ＋ 태그 칩과 같은 실선 테두리여야 한다',
      );
    }

    await closePage(tester);
  });

  testWidgets('추천 평가는 점선에 흰 면, 확정하면 테두리 없이 색 면만 남는다', (tester) async {
    final memoId = await addMemo(
      '전위에서 또 다운더라인 맞음ㅠ',
      evaluation: MemoEvaluation.bad,
      evaluationStatus: EvaluationStatus.suggested,
    );
    await pumpPage(tester);

    final scheme = ThemeData().colorScheme;

    // 추천: 점선을 그리는 DashedBorder가 감싸고, 면은 고르지 않은 것과 같은 흰색.
    expect(
      find.ancestor(
        of: find.byIcon(Icons.thumb_down),
        matching: find.byType(DashedBorder),
      ),
      findsOneWidget,
    );
    var material = materialOf(tester, Icons.thumb_down);
    expect(material.color, scheme.surface);
    // 점선은 DashedBorder가 그리므로 Material 자신은 테두리가 없다.
    expectChipShape(material, hasBorder: false);

    await tester.tap(find.byIcon(Icons.thumb_down));
    await tester.pumpAndSettle();
    expect(
      (await readMemo(memoId)).evaluationStatus,
      EvaluationStatus.confirmed,
    );

    // 확정: 점선이 사라지고 색 면이 채워진다.
    expect(
      find.ancestor(
        of: find.byIcon(Icons.thumb_down),
        matching: find.byType(DashedBorder),
      ),
      findsNothing,
    );
    material = materialOf(tester, Icons.thumb_down);
    expect(material.color, isNot(scheme.surface));
    expectChipShape(material, hasBorder: false);

    await closePage(tester);
  });

  testWidgets('태그 칩과 ＋ 칩은 높이가 같고, 평가 버튼은 가로로 넓다', (tester) async {
    final memoId = await addMemo('백발리 여전히 안 됨');
    // 확정된 칩과 추천(점선) 칩을 함께 둔다.
    await link(memoId, '백발리', status: MemoTagStatus.confirmed);
    await link(memoId, '발리');
    await pumpPage(tester);

    final addHeight = tester.getSize(find.byType(AddTagChip)).height;
    final chipHeights = tester
        .widgetList<TagStatusChip>(find.byType(TagStatusChip))
        .map((chip) => tester.getSize(find.byWidget(chip)).height)
        .toSet();

    expect(chipHeights, hasLength(1), reason: '확정 칩과 추천 칩이 같은 높이여야 한다');
    expect(addHeight, chipHeights.single);
    expect(addHeight, ChipMetrics.minHeight);

    // 평가 버튼의 **보이는 네모**는 가로로 넓다. 정사각형으로 두면 위아래
    // 여백이 좌우와 같아져 뭉툭하게 솟아 보인다.
    final faceSize = tester.getSize(
      find
          .ancestor(
            of: find.byIcon(Icons.thumb_up_outlined),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(
      faceSize,
      const Size(ChipMetrics.evaluationWidth, ChipMetrics.evaluationHeight),
    );
    expect(faceSize.width, greaterThan(faceSize.height), reason: '가로로 넓어야 한다');
    expect(
      faceSize.width,
      lessThanOrEqualTo(ChipMetrics.touchSize),
      reason: '터치 영역을 넘지 않아야 한다',
    );

    await closePage(tester);
  });

  testWidgets('평가 버튼은 보이는 크기보다 넓은 48dp를 손가락이 누를 수 있다', (tester) async {
    final memoId = await addMemo('오늘 서브 개굿');
    await pumpPage(tester);

    final touchArea = find.ancestor(
      of: find.byIcon(Icons.thumb_up_outlined),
      matching: find.byType(InkWell),
    );
    expect(
      tester.getSize(touchArea.first),
      const Size.square(ChipMetrics.touchSize),
    );

    // 보이는 네모 바깥(모서리 쪽 2dp 띠)을 눌러도 눌린다.
    final topLeft = tester.getTopLeft(touchArea.first);
    await tester.tapAt(topLeft + const Offset(1, 1));
    await tester.pumpAndSettle();

    expect((await readMemo(memoId)).evaluation, MemoEvaluation.good);

    await closePage(tester);
  });

  testWidgets('추천된 평가 아이콘을 누르면 평가는 그대로 두고 confirmed로 올린다', (tester) async {
    final memoId = await addMemo(
      '전위에서 또 다운더라인 맞음ㅠ',
      evaluation: MemoEvaluation.bad,
      evaluationStatus: EvaluationStatus.suggested,
    );
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.thumb_down));
    await tester.pumpAndSettle();

    final memo = await readMemo(memoId);
    expect(memo.evaluation, MemoEvaluation.bad);
    expect(memo.evaluationStatus, EvaluationStatus.confirmed);

    await closePage(tester);
  });

  testWidgets('다른 평가 아이콘을 누르면 그 평가로 바뀌며 confirmed가 된다', (tester) async {
    final memoId = await addMemo(
      '스플릿 안 됨ㅠ 왜지?',
      evaluation: MemoEvaluation.question,
      evaluationStatus: EvaluationStatus.suggested,
    );
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.thumb_down_outlined));
    await tester.pumpAndSettle();

    final memo = await readMemo(memoId);
    expect(memo.evaluation, MemoEvaluation.bad);
    expect(memo.evaluationStatus, EvaluationStatus.confirmed);

    await closePage(tester);
  });

  testWidgets('모두 확인은 suggested 태그와 평가를 전부 confirmed로 바꾼다', (tester) async {
    final first = await addMemo(
      '서브 리시브 때 몸이 열림',
      evaluation: MemoEvaluation.bad,
      evaluationStatus: EvaluationStatus.suggested,
    );
    await link(first, '리턴');
    await link(first, '몸열림', status: MemoTagStatus.confirmed);
    final second = await addMemo('포칭으로 두 번 먹힘');
    await link(second, '포칭');
    await pumpPage(tester);

    await tester.tap(find.text('모두 확인'));
    await tester.pumpAndSettle();

    expect((await readLink(first, '리턴')).status, MemoTagStatus.confirmed);
    expect((await readLink(second, '포칭')).status, MemoTagStatus.confirmed);
    expect(
      (await readMemo(first)).evaluationStatus,
      EvaluationStatus.confirmed,
    );
    // 확인할 추천이 남지 않으면 버튼이 꺼진다.
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, '모두 확인'),
    );
    expect(button.onPressed, isNull);

    await closePage(tester);
  });

  testWidgets('완료를 누르면 tagReviewed를 켜고 메인으로 간다', (tester) async {
    final memoId = await addMemo('백발리 여전히 안 됨');
    await link(memoId, '백발리');
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(FilledButton, '완료'));
    await tester.pumpAndSettle();

    final session = await (db.select(
      db.sessions,
    )..where((t) => t.id.equals(sessionId))).getSingle();
    expect(session.tagReviewed, isTrue);
    expect(find.text('메인 화면'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('태그가 없는 메모에서도 추가 칩에 글자가 보인다', (tester) async {
    await addMemo('포칭으로 두 번 먹힘');
    await pumpPage(tester);

    // 아이콘만 두면 무엇을 더하는 버튼인지 바로 읽히지 않는다.
    expect(
      find.descendant(
        of: find.byType(AddTagChip),
        matching: find.text('태그 추가'),
      ),
      findsOneWidget,
    );

    await closePage(tester);
  });

  testWidgets('＋ 칩으로 기존 태그를 골라 붙인다', (tester) async {
    final memoId = await addMemo('포칭으로 두 번 먹힘');
    await pumpPage(tester);

    await tester.tap(find.byType(AddTagChip));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '태그 검색'), '포칭');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '포칭'));
    await tester.pumpAndSettle();

    final added = await readLink(memoId, '포칭');
    expect(added.source, MemoTagSource.manual);
    expect(added.status, MemoTagStatus.confirmed);
    expect(find.text('포칭'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('일치하는 태그가 없으면 분류를 골라 새 태그를 만들어 붙인다', (tester) async {
    final memoId = await addMemo('라켓 헤드가 늦게 따라옴');
    await pumpPage(tester);

    await tester.tap(find.byType(AddTagChip));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '태그 검색'), '헤드스피드');
    await tester.pumpAndSettle();
    await tester.tap(find.text("'헤드스피드' 새 태그 만들기"));
    await tester.pumpAndSettle();

    await tester.tap(find.text('폼'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '만들어 붙이기'));
    await tester.pumpAndSettle();

    final created = await (db.select(
      db.tags,
    )..where((t) => t.name.equals('헤드스피드'))).getSingle();
    expect(created.category, TagCategory.form);
    expect((await readLink(memoId, '헤드스피드')).source, MemoTagSource.manual);
    expect(find.text('헤드스피드'), findsOneWidget);

    await closePage(tester);
  });
}
