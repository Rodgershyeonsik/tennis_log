import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/app/app.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/database_provider.dart';

/// Material이 직접 그리는 문구(날짜 선택기 등)가 한국어로 나오는지 본다.
///
/// `MaterialApp`의 로케일 설정이 빠지면 영어로 돌아가는데, 화면 코드만 봐서는
/// 눈치채기 어렵다. 그래서 실제 앱 위젯([TennisLogApp])을 띄워서 확인한다.
void main() {
  testWidgets('날짜 선택기가 한국어로 나온다', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const TennisLogApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('새 일지 쓰기'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('날짜 선택'));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);
    // 버튼 라벨과 겹치지 않는, 선택기 자체의 한국어 문구로 확인한다.
    expect(find.text('취소'), findsOneWidget);
    expect(find.text('확인'), findsOneWidget);

    // drift 스트림이 닫힐 때 생기는 0초 타이머를 흘려보낸 뒤 DB를 닫는다.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(() => db.close());
  });
}
