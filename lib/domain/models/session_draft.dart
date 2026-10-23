import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';

part 'session_draft.freezed.dart';

/// 일지 작성 1단계에서 편집 중인 세션 값들.
///
/// 리포지토리가 drift companion 대신 이 모델을 주고받는다. 그래야 화면·notifier가
/// drift를 모르는 상태로 있을 수 있다(CLAUDE.md: 위젯에 DB 접근 코드를 두지 않는다).
///
/// 게임과 메모는 별도 테이블이라 여기 들어 있지 않다.
@freezed
abstract class SessionDraft with _$SessionDraft {
  const factory SessionDraft({
    @Default(SessionType.game) SessionType sessionType,
    required DateTime date,
    int? startMinutes,
    int? endMinutes,
    int? placeId,

    /// 1=별로, 2=쏘쏘, 3=굿
    int? conditionScore,
    LastMealBucket? lastMealBucket,

    /// 이미 cues 테이블에 만들어진 큐의 id.
    /// 입력칸의 **텍스트**는 여기 담지 않는다 — 텍스트를 큐 행으로 바꾸는 시점은
    /// 화면이 정한다(`CueRepository.findOrCreate`).
    int? cueId,
    CueApplied? cueApplied,
  }) = _SessionDraft;
}
