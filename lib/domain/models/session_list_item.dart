import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';

part 'session_list_item.freezed.dart';

/// 메인 화면 일지 목록의 한 줄.
///
/// [DraftSummary]는 "작성 중인 일지 이어쓰기"만 담아서 작성 중인 것만 나오는데,
/// 이쪽은 저장을 끝낸 일지까지 전부 담아 **어디까지 진행됐는지**를 보여준다.
@freezed
abstract class SessionListItem with _$SessionListItem {
  const SessionListItem._();

  const factory SessionListItem({
    required int id,
    required DateTime date,
    required SessionType sessionType,

    /// 저장 시점 스냅샷을 먼저 쓰고, 없으면(아직 저장 안 함) 현재 장소 이름.
    /// 장소를 아직 안 골랐으면 null.
    String? placeName,
    required int memoCount,
    required SessionStatus status,
    required bool tagReviewed,
  }) = _SessionListItem;

  JournalProgress get progress {
    if (status == SessionStatus.draft) return JournalProgress.writing;
    return tagReviewed ? JournalProgress.reviewed : JournalProgress.saved;
  }
}

/// 일지가 어디까지 진행됐는지.
enum JournalProgress {
  /// 1단계를 쓰다 말았다(저장 버튼을 누르지 않았거나 메모가 없다).
  writing,

  /// 1단계 저장까지 끝났고 2단계 태그 확인이 남았다.
  saved,

  /// 2단계 태그 확인까지 끝났다.
  reviewed,
}
