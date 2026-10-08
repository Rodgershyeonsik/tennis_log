import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/db/enums.dart';

part 'auto_tag_result.freezed.dart';

/// 메모 한 줄을 [AutoTagger]에 넣은 결과.
///
/// 엔진은 "이 텍스트라면 이런 태그와 평가"까지만 정한다. 기존 태그를 지우거나
/// 사용자가 확인한 평가를 지키는 일은 저장 시 적용 계층(`AutoTagApplier`)이 한다.
@freezed
abstract class MemoAnalysis with _$MemoAnalysis {
  const factory MemoAnalysis({
    /// tagId 오름차순. 같은 태그가 두 번 들어오지는 않는다.
    required List<SuggestedTag> tags,

    /// 추천 평가. 키워드가 없거나 good·bad가 동시에 매칭되면 null이다.
    MemoEvaluation? evaluation,
  }) = _MemoAnalysis;
}

/// 붙일 태그 하나.
@freezed
abstract class SuggestedTag with _$SuggestedTag {
  const factory SuggestedTag({
    required int tagId,

    /// 인식 표현의 confidence에서 나온다. sure면 confirmed, ambiguous면 suggested.
    /// **엔진은 rejected를 내지 않는다**(사용자가 지운 기억은 DB에만 있다).
    required MemoTagStatus status,
  }) = _SuggestedTag;
}
