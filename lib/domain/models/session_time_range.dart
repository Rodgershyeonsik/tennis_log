import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_time_range.freezed.dart';

/// 시작~종료 시간 한 쌍. 자정 기준 분이다(18:00 → 1080).
///
/// 시간 시트의 "자주 쓴 시간" 칩과, 시간 기본값을 돌려줄 때 쓴다.
@freezed
abstract class SessionTimeRange with _$SessionTimeRange {
  const factory SessionTimeRange({
    required int startMinutes,
    required int endMinutes,
  }) = _SessionTimeRange;

  const SessionTimeRange._();

  /// 총 시간(분). 종료가 시작보다 이르면 음수가 될 수 있다(검증은 화면에서 한다).
  int get durationMinutes => endMinutes - startMinutes;
}
