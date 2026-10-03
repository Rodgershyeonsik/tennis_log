import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/enums.dart';

part 'memo_with_tags.freezed.dart';

/// 태그 확인 화면(2단계)의 카드 한 장.
@freezed
abstract class MemoWithTags with _$MemoWithTags {
  const factory MemoWithTags({
    required Memo memo,

    /// 화면에 보여줄 태그들. **rejected는 담지 않는다** (명세: 화면에 표시하지 않음).
    required List<MemoTagView> tags,
  }) = _MemoWithTags;
}

/// 메모에 붙은 태그 하나를 화면에 그리는 데 필요한 정보.
@freezed
abstract class MemoTagView with _$MemoTagView {
  const factory MemoTagView({
    required int tagId,
    required String name,
    required TagCategory category,
    required MemoTagSource source,

    /// confirmed는 실선 채움, suggested는 점선 테두리로 그린다.
    required MemoTagStatus status,
  }) = _MemoTagView;
}
