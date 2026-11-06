import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/domain/search/search_filter.dart';
import 'package:tennis_log/domain/search/search_period.dart';

void main() {
  DateRange rangeOf(SearchScope scope, DateTime today) {
    return SearchPeriod.rangeOf(scope, today)!;
  }

  test('최근 3개월: 석 달 전 같은 날짜부터 오늘까지 양 끝을 포함한다', () {
    final range = rangeOf(
      const SearchScope.preset(PeriodPreset.threeMonths),
      DateTime(2026, 10, 25),
    );

    expect(range.contains(DateTime(2026, 7, 25)), isTrue);
    expect(range.contains(DateTime(2026, 7, 24)), isFalse);
    expect(range.contains(DateTime(2026, 10, 25)), isTrue);
    expect(range.contains(DateTime(2026, 10, 26)), isFalse);
  });

  test('그 달에 같은 날짜가 없으면 말일로 잡는다', () {
    final range = rangeOf(
      const SearchScope.preset(PeriodPreset.oneMonth),
      DateTime(2026, 5, 31),
    );

    expect(range.contains(DateTime(2026, 4, 30)), isTrue);
    expect(range.contains(DateTime(2026, 4, 29)), isFalse);
  });

  test('윤년이 아닌 2월의 말일로 잡는다', () {
    expect(
      SearchPeriod.monthsBefore(DateTime(2026, 3, 31), 1),
      DateTime(2026, 2, 28),
    );
  });

  test('연도를 넘어간다', () {
    expect(
      SearchPeriod.monthsBefore(DateTime(2026, 2, 15), 6),
      DateTime(2025, 8, 15),
    );
  });

  test('올해는 1월 1일부터 오늘까지다', () {
    final range = rangeOf(
      const SearchScope.preset(PeriodPreset.thisYear),
      DateTime(2026, 10, 25),
    );

    expect(range.start, DateTime(2026));
    expect(range.end, DateTime(2026, 10, 25));
  });

  test('직접 지정은 양 끝 날짜를 포함하고 시각은 보지 않는다', () {
    final range = rangeOf(
      SearchScope.custom(
        start: DateTime(2026, 7, 1, 9),
        end: DateTime(2026, 9, 30, 9),
      ),
      DateTime(2026, 10, 25),
    );

    expect(range.contains(DateTime(2026, 7, 1)), isTrue);
    expect(range.contains(DateTime(2026, 9, 30, 23, 59)), isTrue);
    expect(range.contains(DateTime(2026, 10, 1)), isFalse);
  });

  test('전체와 최근 N세션은 날짜로 제한하지 않는다', () {
    final today = DateTime(2026, 10, 25);

    expect(SearchPeriod.rangeOf(const SearchScope.all(), today), isNull);
    expect(
      SearchPeriod.rangeOf(const SearchScope.recentSessions(10), today),
      isNull,
    );
  });
}
