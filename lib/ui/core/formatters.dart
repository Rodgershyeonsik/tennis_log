/// 날짜·시간 표시 포맷.
///
/// `intl`을 쓰지 않고 직접 만든다(CLAUDE.md). 앱 문구는 모두 한국어이므로
/// 로케일 분기도 두지 않는다.
abstract final class Formatters {
  /// `DateTime.weekday`는 월요일이 1이다.
  static const _weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];

  static String weekday(DateTime date) => _weekdayNames[date.weekday - 1];

  /// `2026년 10월 9일 금요일` — 작성 화면의 일시처럼 자리가 넉넉한 곳에 쓴다.
  static String koreanDate(DateTime date) =>
      '${date.year}년 ${date.month}월 ${date.day}일 ${weekday(date)}요일';

  /// `26/9/22 금` — 목록처럼 좁은 자리에 쓰는 짧은 형식.
  static String dateWithWeekday(DateTime date) {
    final year = (date.year % 100).toString().padLeft(2, '0');
    return '$year/${date.month}/${date.day} ${weekday(date)}';
  }

  /// 자정 기준 분을 `18:00`으로. 1440은 `24:00`이다(종료 시간의 상한).
  static String minutesOfDay(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  /// 총 시간. `3시간 50분`, `2시간`, `50분`.
  /// 음수는 호출 쪽에서 걸러야 한다(종료가 시작보다 이른 값은 화면에서 막는다).
  static String duration(int minutes) {
    if (minutes <= 0) return '0분';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    if (hours == 0) return '$rest분';
    if (rest == 0) return '$hours시간';
    return '$hours시간 $rest분';
  }
}
