import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';

part 'cue_summary.freezed.dart';

/// "지난 큐 불러오기" 시트의 한 줄.
///
/// 사용 횟수와 최근 적용 결과는 cues 테이블에 저장하지 않고 sessions에서
/// 계산한다(명세의 데이터 모델). 그 계산 결과를 담는 읽기 전용 모델이다.
@freezed
abstract class CueSummary with _$CueSummary {
  const factory CueSummary({
    required int id,
    required String text,

    /// 이 큐를 마지막으로 쓴 세션의 날짜. 쓴 세션이 없으면 null.
    DateTime? lastUsedDate,

    /// 이 큐를 쓴 세션 수.
    required int useCount,

    /// 가장 최근 세션에서의 적용 결과. 기록이 없으면 null(배지를 안 보여준다).
    CueApplied? latestApplied,
  }) = _CueSummary;
}
