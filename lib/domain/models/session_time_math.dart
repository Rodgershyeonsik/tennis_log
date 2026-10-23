import 'session_time_range.dart';

/// ± 버튼이나 휠에서 값이 한계에 걸려 더 움직이지 못한 이유.
///
/// 화면은 이 값을 보고 시간 줄 아래에 짧은 안내 문구를 띄운다.
enum TimeLimit {
  /// 06:00보다 이른 값
  dayStart,

  /// 24:00보다 늦은 값
  dayEnd,

  /// 종료가 시작보다 이르거나 같아지는 값
  order,
}

/// ± 조정 결과. [limit]이 null이 아니면 한계에 걸려 요청한 만큼 못 움직였다는 뜻이다.
class TimeStepResult {
  const TimeStepResult(this.range, [this.limit]);

  final SessionTimeRange range;
  final TimeLimit? limit;
}

/// 세션 시작·종료 시간 계산. UI와 무관한 순수 로직이라 단위 테스트로 검증한다.
///
/// 잘못된 값(종료 ≤ 시작)은 **만들어지지 않게** 입력 지점에서 막는다. 그래서
/// 여기의 모든 함수는 유효한 범위만 돌려준다.
abstract final class SessionTimeMath {
  /// 입력 가능한 하루의 경계. 06:00 ~ 24:00 (DB CHECK 제약과 같다)
  static const dayStart = 6 * 60;
  static const dayEnd = 24 * 60;

  /// ± 버튼 한 번에 움직이는 양
  static const stepMinutes = 10;

  /// 시간 시트 휠의 간격
  static const wheelStepMinutes = 30;

  /// 세션 길이의 최소값. 종료는 적어도 시작 + 이만큼이어야 한다.
  static const minDurationMinutes = stepMinutes;

  /// 과거 세션이 없을 때 쓰는 기본값 (18:00 ~ 20:00)
  static const defaultRange = SessionTimeRange(
    startMinutes: 18 * 60,
    endMinutes: 20 * 60,
  );

  /// 시작이 올라갈 수 있는 상한. 이보다 늦으면 종료를 둘 자리가 없다.
  static const maxStart = dayEnd - minDurationMinutes;

  /// 종료가 시작보다 뒤인가. 화면의 인라인 오류 판정에 쓴다.
  static bool isOrdered(SessionTimeRange range) =>
      range.endMinutes > range.startMinutes;

  /// 시작을 [delta]분 옮긴다. **종료는 따라 움직이지 않는다.**
  ///
  /// 시작은 06:00 아래로 내려가지 않고, 종료보다 [minDurationMinutes] 이상
  /// 앞이어야 한다. 그래서 잘못된 순서는 애초에 만들어지지 않는다.
  static TimeStepResult stepStart(SessionTimeRange range, int delta) {
    final ceiling = range.endMinutes - minDurationMinutes;
    final requested = range.startMinutes + delta;
    final start = requested.clamp(
      dayStart,
      ceiling < dayStart ? dayStart : ceiling,
    );

    TimeLimit? limit;
    if (requested < dayStart) {
      limit = TimeLimit.dayStart;
    } else if (requested > ceiling) {
      limit = TimeLimit.order;
    }

    return TimeStepResult(
      SessionTimeRange(startMinutes: start, endMinutes: range.endMinutes),
      limit,
    );
  }

  /// 종료를 [delta]분 옮긴다. 시작은 그대로 두고, 시작 이하로는 내려가지 않는다.
  static TimeStepResult stepEnd(SessionTimeRange range, int delta) {
    final floor = range.startMinutes + minDurationMinutes;
    final requested = range.endMinutes + delta;
    final end = requested.clamp(floor, dayEnd);

    TimeLimit? limit;
    if (requested < floor) {
      limit = TimeLimit.order;
    } else if (requested > dayEnd) {
      limit = TimeLimit.dayEnd;
    }

    return TimeStepResult(
      SessionTimeRange(startMinutes: range.startMinutes, endMinutes: end),
      limit,
    );
  }

  /// 시간 시트 휠 한 개의 선택지. 06:00, 06:30 … 24:00 (30분 단위).
  ///
  /// [current]가 30분 단위가 아니면 **가장 가까운 칸으로 바꾸지 않고 제자리에
  /// 끼워 넣는다**(명세 3번). 예: 21:50은 21:30과 22:00 사이에 들어간다.
  static List<int> wheelValues({int? current}) {
    final values = <int>[
      for (var value = dayStart; value <= dayEnd; value += wheelStepMinutes)
        value,
    ];
    if (current == null || current < dayStart || current > dayEnd) {
      return values;
    }
    if (values.contains(current)) return values;
    // 30분 단위가 아닌 값. 바로 뒤 칸 앞에 끼워 넣는다.
    values.insert(values.indexWhere((value) => value > current), current);
    return values;
  }
}
