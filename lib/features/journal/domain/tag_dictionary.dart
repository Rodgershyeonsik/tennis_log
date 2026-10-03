import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/db/enums.dart';

part 'tag_dictionary.freezed.dart';

/// 자동 태그 엔진(3단계)에 넘길 태그 사전 한 덩어리.
///
/// DB 행을 그대로 넘기지 않고 이 모델로 바꾸는 이유는, 엔진이 **UI와 DB를 모르는
/// 순수 Dart 클래스**여야 단위 테스트를 쓸 수 있기 때문이다. 엔진 테스트는
/// DB 없이 이 모델만 직접 만들어서 돌릴 수 있다.
@freezed
abstract class TagDictionary with _$TagDictionary {
  const factory TagDictionary({required List<TagDictionaryEntry> entries}) =
      _TagDictionary;
}

/// 태그 하나와 그 태그를 알아보는 데 필요한 모든 정보.
@freezed
abstract class TagDictionaryEntry with _$TagDictionaryEntry {
  const factory TagDictionaryEntry({
    required int tagId,
    required String name,
    required TagCategory category,

    /// 부모 태그 id. 자식이 매칭되면 부모는 붙이지 않는다(조회 시 포함).
    int? parentTagId,

    /// 이 태그를 알아보는 표현들.
    required List<TagAlias> aliases,

    /// 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다.
    required List<String> exclusions,
  }) = _TagDictionaryEntry;
}

/// 인식 표현 하나.
@freezed
abstract class TagAlias with _$TagAlias {
  const factory TagAlias({
    required String alias,
    required AliasConfidence confidence,
  }) = _TagAlias;
}
