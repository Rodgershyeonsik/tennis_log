import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/app/theme.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/ui/search/widgets/memo_content.dart';

/// 조회 결과 카드와 세션 상세 시트가 같이 쓰는 메모 본문.
void main() {
  Future<void> pump(
    WidgetTester tester, {
    List<String> tagNames = const [],
    MemoEvaluation? evaluation,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: MemoContent(
            content: '서브 토스가 흔들렸다',
            tagNames: tagNames,
            evaluation: evaluation,
          ),
        ),
      ),
    );
  }

  testWidgets('태그는 #을 붙여 쉼표 없이 띄어쓰기 1.5배 간격으로 늘어놓는다', (tester) async {
    await pump(tester, tagNames: ['서브', '발리']);

    expect(find.text('#서브'), findsOneWidget);
    expect(find.text('#발리'), findsOneWidget);
    expect(find.textContaining(','), findsNothing);

    final style = tester.widget<Text>(find.text('#서브')).style;
    final space = TextPainter(
      text: TextSpan(text: ' ', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final gap =
        tester.getTopLeft(find.text('#발리')).dx -
        tester.getTopRight(find.text('#서브')).dx;
    expect(gap, closeTo(space.width * 1.5, 0.01));
    space.dispose();
  });

  testWidgets('평가는 아이콘 하나만 두고 없음이면 생략한다', (tester) async {
    await pump(tester, evaluation: MemoEvaluation.bad);
    expect(find.byIcon(Icons.thumb_down), findsOneWidget);

    await pump(tester, evaluation: MemoEvaluation.none);
    expect(find.byIcon(Icons.remove_circle), findsNothing);
  });
}
