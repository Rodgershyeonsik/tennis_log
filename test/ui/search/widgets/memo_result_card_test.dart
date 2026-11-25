import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/app/theme.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/search/search_models.dart';
import 'package:tennis_log/domain/search/tag_hierarchy.dart';
import 'package:tennis_log/ui/search/widgets/memo_result_card.dart';

/// 메모 탭과 통계 탭의 메모 시트가 같이 쓰는 메모 카드.
void main() {
  final memo = SearchMemo(
    id: 1,
    content: '서브 토스가 흔들렸다',
    orderIndex: 0,
    session: SearchSession(
      id: 1,
      date: DateTime(2026, 10, 12),
      placeNameSnapshot: '고척',
      sessionType: SessionType.game,
    ),
    tagIds: const [],
  );

  Future<int> tapCard(WidgetTester tester, {required bool showChevron}) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: MemoResultCard(
            memo: memo,
            hierarchy: TagHierarchy(const []),
            onTap: () => taps++,
            showChevron: showChevron,
          ),
        ),
      ),
    );
    await tester.tap(find.text('서브 토스가 흔들렸다'));
    return taps;
  }

  testWidgets('화살표를 보여주면 눌렀을 때 반응한다', (tester) async {
    expect(await tapCard(tester, showChevron: true), 1);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('화살표를 숨기면 눌러도 반응하지 않는다', (tester) async {
    expect(await tapCard(tester, showChevron: false), 0);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.text('26/10/12 월 · 고척'), findsOneWidget);
  });
}
