import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_summary.freezed.dart';

/// 메인 화면의 "작성 중인 일지 이어쓰기" 한 줄.
@freezed
abstract class DraftSummary with _$DraftSummary {
  const factory DraftSummary({
    required int id,
    required DateTime date,

    /// 장소를 아직 안 골랐으면 null.
    String? placeName,
    required DateTime updatedAt,
  }) = _DraftSummary;
}
