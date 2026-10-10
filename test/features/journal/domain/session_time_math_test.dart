import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/features/journal/domain/session_time_math.dart';
import 'package:tennis_log/features/journal/domain/session_time_range.dart';

void main() {
  const range = SessionTimeRange(startMinutes: 1080, endMinutes: 1200);

  group('stepStart', () {
    test('종료는 그대로 두고 시작만 움직인다', () {
      final result = SessionTimeMath.stepStart(range, 10);
      expect(result.range.startMinutes, 1090);
      expect(result.range.endMinutes, 1200);
      expect(result.limit, isNull);
    });

    test('뒤로도 종료를 건드리지 않는다', () {
      final result = SessionTimeMath.stepStart(range, -10);
      expect(result.range.startMinutes, 1070);
      expect(result.range.endMinutes, 1200);
    });

    test('시작은 종료보다 10분 이상 앞이어야 한다', () {
      const tight = SessionTimeRange(startMinutes: 1190, endMinutes: 1200);
      final result = SessionTimeMath.stepStart(tight, 10);
      expect(result.range, tight);
      expect(result.limit, TimeLimit.order);
    });

    test('시작은 06:00보다 이를 수 없다', () {
      const early = SessionTimeRange(startMinutes: 360, endMinutes: 480);
      final result = SessionTimeMath.stepStart(early, -10);
      expect(result.range, early);
      expect(result.limit, TimeLimit.dayStart);
    });
  });

  group('stepEnd', () {
    test('시작은 그대로 두고 종료만 움직인다', () {
      final result = SessionTimeMath.stepEnd(range, 10);
      expect(result.range.startMinutes, 1080);
      expect(result.range.endMinutes, 1210);
      expect(result.limit, isNull);
    });

    test('종료는 시작 + 10분 아래로 내려가지 않는다', () {
      const tight = SessionTimeRange(startMinutes: 1080, endMinutes: 1090);
      final result = SessionTimeMath.stepEnd(tight, -10);
      expect(result.range, tight);
      expect(result.limit, TimeLimit.order);
    });

    test('종료는 24:00을 넘지 않는다', () {
      const late = SessionTimeRange(startMinutes: 1080, endMinutes: 1440);
      final result = SessionTimeMath.stepEnd(late, 10);
      expect(result.range, late);
      expect(result.limit, TimeLimit.dayEnd);
    });
  });

  group('isOrdered', () {
    test('종료가 시작보다 뒤여야 유효하다', () {
      expect(SessionTimeMath.isOrdered(range), isTrue);
      expect(
        SessionTimeMath.isOrdered(
          const SessionTimeRange(startMinutes: 1080, endMinutes: 1080),
        ),
        isFalse,
      );
      expect(
        SessionTimeMath.isOrdered(
          const SessionTimeRange(startMinutes: 1200, endMinutes: 1080),
        ),
        isFalse,
      );
    });
  });

  group('wheelValues', () {
    test('06:00부터 24:00까지 30분 단위', () {
      final values = SessionTimeMath.wheelValues();
      expect(values.first, 360);
      expect(values.last, 1440);
      expect(values.length, 37);
      expect(values.take(3), [360, 390, 420]);
    });

    test('30분 단위가 아닌 현재 값을 제자리에 끼워 넣는다', () {
      final values = SessionTimeMath.wheelValues(current: 1310); // 21:50
      final index = values.indexOf(1310);
      expect(values[index - 1], 1290); // 21:30
      expect(values[index + 1], 1320); // 22:00
      expect(values.length, 38);
    });

    test('30분 단위면 끼워 넣지 않는다', () {
      final values = SessionTimeMath.wheelValues(current: 1080);
      expect(values.length, 37);
    });

    test('범위를 벗어난 값은 무시한다', () {
      expect(SessionTimeMath.wheelValues(current: 100).length, 37);
      expect(SessionTimeMath.wheelValues(current: 2000).length, 37);
    });
  });
}
