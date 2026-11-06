import 'dart:math';

import 'search_filter.dart';

/// 양 끝 날짜를 포함하는 기간.
class DateRange {
  DateRange(DateTime start, DateTime end)
    : start = _dateOnly(start),
      end = _dateOnly(end);

  final DateTime start;
  final DateTime end;

  bool contains(DateTime date) {
    final day = _dateOnly(date);
    return !day.isBefore(start) && !day.isAfter(end);
  }
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

/// 조회 범위를 실제 날짜로 푸는 계산.
abstract final class SearchPeriod {
  /// [scope]의 기간. 날짜로 제한하지 않는 범위(전체, 최근 N세션)면 null이다.
  static DateRange? rangeOf(SearchScope scope, DateTime today) {
    return switch (scope) {
      SearchScopeAll() || SearchScopeRecentSessions() => null,
      SearchScopeCustom(:final start, :final end) => DateRange(start, end),
      SearchScopePreset(:final preset) => DateRange(switch (preset) {
        PeriodPreset.oneMonth => monthsBefore(today, 1),
        PeriodPreset.threeMonths => monthsBefore(today, 3),
        PeriodPreset.sixMonths => monthsBefore(today, 6),
        PeriodPreset.thisYear => DateTime(today.year),
      }, today),
    };
  }

  /// [months]개월 전의 같은 날짜. 그 달에 같은 날짜가 없으면 그 달 말일이다.
  static DateTime monthsBefore(DateTime date, int months) {
    final firstOfMonth = DateTime(date.year, date.month - months);
    final lastDay = DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0).day;
    return DateTime(
      firstOfMonth.year,
      firstOfMonth.month,
      min(date.day, lastDay),
    );
  }
}
