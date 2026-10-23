import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/enums.dart';

part 'memo_with_tags.freezed.dart';

/// 태그 확인 화면(2단계)의 카드 한 장.
@freezed
abstract class MemoWithTags with _$MemoWithTags {
  // freezed는 getter를 둔 클래스에 private 생성자를 요구한다.
  const MemoWithTags._();

  const factory MemoWithTags({
    required Memo memo,

    /// 화면에 보여줄 태그들. **rejected는 담지 않는다** (명세: 화면에 표시하지 않음).
    required List<MemoTagView> tags,
  }) = _MemoWithTags;

  /// 확인이 필요한 추천(점선)이 하나라도 있는가. "모두 확인"을 켤지 정한다.
  bool get hasSuggestions {
    return memo.evaluationStatus == EvaluationStatus.suggested ||
        tags.any((tag) => !tag.isConfirmed);
  }
}

/// 메모에 붙은 태그 하나를 화면에 그리는 데 필요한 정보.
@freezed
abstract class MemoTagView with _$MemoTagView {
  const MemoTagView._();

  const factory MemoTagView({
    required int tagId,
    required String name,
    required TagCategory category,
    required MemoTagSource source,

    /// confirmed는 실선 채움, suggested는 점선 테두리로 그린다.
    required MemoTagStatus status,
  }) = _MemoTagView;

  /// rejected는 여기까지 오지 않으므로, confirmed가 아니면 suggested다.
  bool get isConfirmed => status == MemoTagStatus.confirmed;
}
