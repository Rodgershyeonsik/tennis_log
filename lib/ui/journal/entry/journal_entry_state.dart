import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/db/enums.dart';
import '../../../domain/models/session_draft.dart';
import '../../../domain/models/session_time_math.dart';
import '../../../domain/models/session_time_range.dart';

part 'journal_entry_state.freezed.dart';

/// 상단 바의 자동 저장 표시.
enum AutoSaveState {
  /// 아직 저장할 변경이 없었다(표시하지 않음).
  idle,

  /// 변경이 있고 저장을 기다리는 중이다.
  pending,

  /// 마지막 변경까지 저장됐다.
  saved,
}

/// 일지 작성 1단계 화면의 상태.
///
/// 게임·메모 목록은 여기 담지 않는다. 둘은 DB에 바로 쓰고 스트림으로 읽는 쪽이
/// 단순해서, `entry_providers.dart`의 watch 프로바이더로 그린다.
@freezed
abstract class JournalEntryState with _$JournalEntryState {
  const factory JournalEntryState({
    /// draft 세션이 아직 안 만들어졌으면 null.
    int? sessionId,
    required SessionDraft draft,

    /// 큐 입력칸의 텍스트. **큐 행(cueId)의 원본은 이 텍스트다.**
    /// 텍스트 → cueId 변환은 저장할 때 한다(명세 3번).
    @Default('') String cueText,

    /// 시간 시트의 "자주 쓴 시간" 칩.
    @Default(<SessionTimeRange>[]) List<SessionTimeRange> frequentRanges,
    @Default(AutoSaveState.idle) AutoSaveState autoSave,

    /// 저장 버튼을 눌렀는데 장소가 없을 때만 true.
    @Default(false) bool placeMissing,

    /// ± 버튼이 한계에 걸려 값이 움직이지 않았을 때의 이유.
    TimeLimit? timeLimit,

    /// 저장 버튼 처리 중(중복 실행 방지 + 버튼 비활성).
    @Default(false) bool finalizing,
  }) = _JournalEntryState;

  const JournalEntryState._();

  /// 화면이 쓰는 시작~종료. 값이 비어 있으면 기본값으로 메운다.
  SessionTimeRange get timeRange => SessionTimeRange(
    startMinutes:
        draft.startMinutes ?? SessionTimeMath.defaultRange.startMinutes,
    endMinutes: draft.endMinutes ?? SessionTimeMath.defaultRange.endMinutes,
  );

  bool get isTimeOrdered => SessionTimeMath.isOrdered(timeRange);

  /// 종료가 시작보다 이른 값은 입력 지점에서 막으므로, 이 오류는 과거 데이터를
  /// 불러왔을 때만 나타난다. 그래도 저장은 막는다.
  String? get timeErrorText =>
      isTimeOrdered ? null : '종료 시간이 시작보다 빨라요. 시간을 다시 선택해 주세요.';

  /// ± 버튼이 한계에 걸렸을 때 시간 줄 아래에 띄우는 안내.
  String? get timeLimitText => switch (timeLimit) {
    TimeLimit.dayStart => '06:00보다 이른 시간은 설정할 수 없어요.',
    TimeLimit.dayEnd => '24:00보다 늦은 시간은 설정할 수 없어요.',
    TimeLimit.order => '종료는 시작보다 뒤여야 해요.',
    null => null,
  };

  String? get placeErrorText => placeMissing ? '장소를 선택해 주세요.' : null;

  /// 큐 적용 분할 버튼은 큐 입력칸이 비어 있지 않을 때만 보여준다(명세 3번).
  bool get showCueApplied => cueText.trim().isNotEmpty;

  bool get canFinalize => !finalizing && isTimeOrdered;
}

/// 저장 버튼 처리 결과. 화면은 이 값으로 저장 후 하단 시트를 그린다.
class FinalizeOutcome {
  const FinalizeOutcome({
    required this.sessionId,
    required this.status,
    required this.suggestedTagCount,
    required this.suggestedEvaluationCount,
  });

  final int sessionId;
  final SessionStatus status;
  final int suggestedTagCount;
  final int suggestedEvaluationCount;
}
