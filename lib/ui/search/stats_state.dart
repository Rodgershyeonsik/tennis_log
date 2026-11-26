import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_state.freezed.dart';

/// 태그 통계 탭의 상태. 앱을 다시 시작하면 초기값으로 돌아간다.
@freezed
abstract class StatsState with _$StatsState {
  const factory StatsState({
    /// null이면 태그 전체다.
    int? chartTagId,

    /// null이면 최신 세션이다.
    int? selectedSessionId,
  }) = _StatsState;
}
