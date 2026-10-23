import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/ui/core/formatters.dart';

void main() {
  group('dateWithWeekday', () {
    test('26/9/22 금 형태로 만든다', () {
      expect(Formatters.dateWithWeekday(DateTime(2026, 9, 22)), '26/9/22 화');
      expect(Formatters.dateWithWeekday(DateTime(2026, 10, 9)), '26/10/9 금');
    });

    test('연도는 뒤 두 자리, 월·일은 0을 채우지 않는다', () {
      expect(Formatters.dateWithWeekday(DateTime(2026, 1, 4)), '26/1/4 일');
      expect(Formatters.dateWithWeekday(DateTime(2005, 3, 7)), '05/3/7 월');
    });

    test('요일 7개를 모두 맞춘다', () {
      // 2026-10-05는 월요일이다.
      const names = ['월', '화', '수', '목', '금', '토', '일'];
      for (var i = 0; i < 7; i++) {
        expect(Formatters.weekday(DateTime(2026, 10, 5 + i)), names[i]);
      }
    });
  });

  group('minutesOfDay', () {
    test('두 자리로 채운다', () {
      expect(Formatters.minutesOfDay(1080), '18:00');
      expect(Formatters.minutesOfDay(360), '06:00');
      expect(Formatters.minutesOfDay(1310), '21:50');
    });

    test('상한 1440은 24:00이다', () {
      expect(Formatters.minutesOfDay(1440), '24:00');
    });
  });

  group('duration', () {
    test('시간과 분을 함께 쓴다', () {
      expect(Formatters.duration(230), '3시간 50분');
    });

    test('떨어지는 값은 한쪽만 쓴다', () {
      expect(Formatters.duration(120), '2시간');
      expect(Formatters.duration(50), '50분');
    });

    test('0 이하는 0분', () {
      expect(Formatters.duration(0), '0분');
      expect(Formatters.duration(-30), '0분');
    });
  });
}
