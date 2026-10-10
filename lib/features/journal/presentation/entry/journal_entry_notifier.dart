import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/db/enums.dart';
import '../../data/auto_tag_applier.dart';
import '../../data/cue_repository.dart';
import '../../data/game_repository.dart';
import '../../data/memo_repository.dart';
import '../../data/place_repository.dart';
import '../../data/session_repository.dart';
import '../../domain/session_draft.dart';
import '../../domain/session_time_math.dart';
import '../../domain/session_time_range.dart';
import 'journal_entry_state.dart';

part 'journal_entry_notifier.g.dart';

/// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
///
/// 자동 저장 규칙(명세 4번):
/// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
/// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
/// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
/// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
///
/// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
/// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).
@riverpod
class JournalEntryNotifier extends _$JournalEntryNotifier {
  static const _debounce = Duration(milliseconds: 800);

  Timer? _timer;

  /// dispose 후에는 `state`를 읽거나 쓸 수 없다. 떠날 때의 즉시 저장이
  /// 마지막 값을 보려면 별도 사본이 필요하다.
  JournalEntryState? _latest;
  bool _disposed = false;

  /// 변경 횟수. 저장이 끝난 뒤 "그 사이 또 바뀌었는지" 판단에 쓴다.
  int _revision = 0;

  /// 중복 createDraft 방지. 빠른 연속 입력에도 세션은 하나만 만들어야 한다.
  Future<int>? _creating;

  SessionRepository get _sessions => ref.read(sessionRepositoryProvider);
  CueRepository get _cues => ref.read(cueRepositoryProvider);
  MemoRepository get _memos => ref.read(memoRepositoryProvider);
  GameRepository get _games => ref.read(gameRepositoryProvider);
  PlaceRepository get _places => ref.read(placeRepositoryProvider);

  @override
  Future<JournalEntryState> build(int? sessionId) async {
    ref.onDispose(_handleDispose);
    final initial = await _load(sessionId);
    _latest = initial;
    return initial;
  }

  Future<JournalEntryState> _load(int? sessionId) async {
    final frequent = await _sessions.frequentTimeRanges();

    if (sessionId != null) {
      final draft = await _sessions.loadDraft(sessionId);
      if (draft != null) {
        final cueId = draft.cueId;
        final cue = cueId == null ? null : await _cues.findById(cueId);
        final fallback = SessionTimeMath.defaultRange;
        return JournalEntryState(
          sessionId: sessionId,
          draft: draft.copyWith(
            startMinutes: draft.startMinutes ?? fallback.startMinutes,
            endMinutes: draft.endMinutes ?? fallback.endMinutes,
          ),
          cueText: cue?.cueText ?? '',
          frequentRanges: frequent,
          // 불러온 값은 이미 DB에 있는 상태다.
          autoSave: AutoSaveState.saved,
        );
      }
      // 세션이 사라졌으면 새 일지로 취급한다.
    }

    // 기본 시간: 가장 최근 세션의 시작~종료, 없으면 18:00~20:00.
    final latest =
        await _sessions.latestTimeRange() ?? SessionTimeMath.defaultRange;
    return JournalEntryState(
      draft: SessionDraft(
        date: SessionRepository.dateOnly(DateTime.now()),
        startMinutes: latest.startMinutes,
        endMinutes: latest.endMinutes,
      ),
      frequentRanges: frequent,
    );
  }

  // --------------------------------------------------------------- 입력 반영

  void setSessionType(SessionType value) {
    _editDraft((draft) => draft.copyWith(sessionType: value));
  }

  void setDate(DateTime value) {
    _editDraft(
      (draft) => draft.copyWith(date: SessionRepository.dateOnly(value)),
    );
  }

  /// 시간 시트의 확인 버튼. 시트가 유효한 값만 돌려주므로 그대로 받는다.
  void setTimeRange(SessionTimeRange range) {
    _editDraft(
      (draft) => draft.copyWith(
        startMinutes: range.startMinutes,
        endMinutes: range.endMinutes,
      ),
    );
  }

  /// 시작의 ± 버튼. 종료는 세션 길이를 유지하며 따라 움직인다.
  void stepStart(int delta) => _step(SessionTimeMath.stepStart, delta);

  /// 종료의 ± 버튼. 시작 이하로는 내려가지 않는다.
  void stepEnd(int delta) => _step(SessionTimeMath.stepEnd, delta);

  void _step(TimeStepResult Function(SessionTimeRange, int) step, int delta) {
    final current = _latest;
    if (current == null) return;

    final result = step(current.timeRange, delta);
    _write(
      current.copyWith(
        draft: current.draft.copyWith(
          startMinutes: result.range.startMinutes,
          endMinutes: result.range.endMinutes,
        ),
        // 한계에 걸렸으면 왜 안 움직였는지 알려 준다.
        timeLimit: result.limit,
        autoSave: AutoSaveState.pending,
      ),
    );
    _schedule();
  }

  void setPlace(int placeId) {
    final current = _latest;
    if (current == null) return;
    _write(
      current.copyWith(
        draft: current.draft.copyWith(placeId: placeId),
        placeMissing: false,
        autoSave: AutoSaveState.pending,
      ),
    );
    _schedule();
  }

  /// 1=별로, 2=쏘쏘, 3=굿. null이면 해제.
  void setConditionScore(int? score) {
    _editDraft((draft) => draft.copyWith(conditionScore: score));
  }

  void setLastMeal(LastMealBucket? bucket) {
    _editDraft((draft) => draft.copyWith(lastMealBucket: bucket));
  }

  void setCueApplied(CueApplied? value) {
    _editDraft((draft) => draft.copyWith(cueApplied: value));
  }

  /// 큐 입력칸. 비우면 큐 적용 값도 함께 지운다(버튼이 사라지므로).
  void setCueText(String text) {
    final current = _latest;
    if (current == null) return;
    final cleared = text.trim().isEmpty;
    _write(
      current.copyWith(
        cueText: text,
        draft: cleared
            ? current.draft.copyWith(cueId: null, cueApplied: null)
            : current.draft,
        autoSave: AutoSaveState.pending,
      ),
    );
    _schedule();
  }

  /// ± 안내 문구를 지운다(값을 다시 움직이면 사라지게).
  void clearTimeLimit() {
    final current = _latest;
    if (current == null || current.timeLimit == null) return;
    _write(current.copyWith(timeLimit: null));
  }

  // ------------------------------------------------------------- 장소 등록

  /// 하단 시트에서 등록한 장소. 등록하면 바로 선택된다(명세 3번).
  Future<Place> createPlace({
    required String name,
    required SurfaceType surface,
    required bool isIndoor,
  }) async {
    final place = await _places.create(
      name: name,
      surface: surface,
      isIndoor: isIndoor,
    );
    setPlace(place.id);
    return place;
  }

  // --------------------------------------------------------------- 게임

  Future<void> addGame({
    required GameFormat format,
    int? myScore,
    int? opponentScore,
  }) async {
    final sessionId = await ensureSession();
    await _games.add(
      sessionId: sessionId,
      format: format,
      myScore: myScore,
      opponentScore: opponentScore,
    );
    _schedule();
  }

  Future<void> updateGame({
    required int gameId,
    required GameFormat format,
    int? myScore,
    int? opponentScore,
  }) async {
    await _games.update(
      gameId: gameId,
      format: format,
      myScore: myScore,
      opponentScore: opponentScore,
    );
    _schedule();
  }

  Future<void> removeGame(int gameId) async {
    await _games.delete(gameId);
    _schedule();
  }

  // --------------------------------------------------------------- 메모

  /// 입력칸 내용을 메모로 추가한다. 여러 줄이면 줄 단위로 나뉜다.
  Future<void> addMemos(String rawInput) async {
    if (rawInput.trim().isEmpty) return;
    final sessionId = await ensureSession();
    await _memos.addLines(sessionId, rawInput);
    _schedule();
  }

  Future<void> updateMemo(int memoId, String content) async {
    if (content.trim().isEmpty) return;
    await _memos.updateContent(memoId, content);
    _schedule();
  }

  /// 메모를 지우고 실행 취소에 필요한 값을 돌려준다.
  Future<RemovedMemo?> removeMemo(int memoId) async {
    final removed = await _memos.remove(memoId);
    _schedule();
    return removed;
  }

  Future<void> restoreMemo(RemovedMemo removed) async {
    await _memos.restore(removed);
    _schedule();
  }

  // ------------------------------------------------------------- 저장 버튼

  /// 저장 버튼. 검증을 통과하면 마무리 저장 + 자동 태그까지 하고 결과를 돌려준다.
  ///
  /// 검증에 걸리면 null을 돌려주고 상태에 오류를 남긴다(화면이 그 위치로
  /// 스크롤한다). 자동 저장은 검증과 무관하게 이미 저장을 해 둔 상태다.
  Future<FinalizeOutcome?> finalize() async {
    var current = _latest;
    if (current == null || current.finalizing) return null;

    // 날짜는 기본값이 오늘이고 비울 수 없으므로 실패하지 않는다.
    // 장소는 선택하지 않을 수 있어 여기서 막는다(명세 4번).
    if (current.draft.placeId == null) {
      _write(current.copyWith(placeMissing: true));
      return null;
    }
    if (!current.isTimeOrdered) return null;

    _write(current.copyWith(finalizing: true, placeMissing: false));

    try {
      // 남은 변경을 먼저 반영한다. 저장 버튼에서는 큐를 새로 만든다.
      current = _latest!;
      final draft = await _resolveDraft(current, createCue: true);
      final sessionId = await ensureSession();
      _timer?.cancel();
      await _sessions.saveDraft(sessionId, draft);

      final session = await _sessions.finalizeSession(sessionId);
      final tagResult = await ref
          .read(autoTagApplierProvider)
          .applyToSession(sessionId);

      final latest = _latest;
      if (latest != null) {
        _write(
          latest.copyWith(
            sessionId: sessionId,
            finalizing: false,
            autoSave: AutoSaveState.saved,
          ),
        );
      }

      return FinalizeOutcome(
        sessionId: sessionId,
        status: session.status,
        suggestedTagCount: tagResult.suggestedTagCount,
        suggestedEvaluationCount: tagResult.suggestedEvaluationCount,
      );
    } catch (_) {
      final latest = _latest;
      if (latest != null) _write(latest.copyWith(finalizing: false));
      rethrow;
    }
  }

  // ------------------------------------------------------------- 자동 저장

  /// 세션이 없으면 만든다. 메모·게임처럼 sessionId가 필요한 작업이 먼저
  /// 호출한다(그것도 "값이 바뀌는 순간"이라 draft를 만들 때다).
  Future<int> ensureSession() async {
    final existing = _latest?.sessionId;
    if (existing != null) return existing;
    return _creating ??= _createSession();
  }

  Future<int> _createSession() async {
    final current = _latest!;
    final draft = await _resolveDraft(current, createCue: false);
    final sessionId = await _sessions.createDraft(draft);
    final latest = _latest;
    if (latest != null) _write(latest.copyWith(sessionId: sessionId));
    return sessionId;
  }

  void _editDraft(SessionDraft Function(SessionDraft draft) change) {
    final current = _latest;
    if (current == null) return;
    _write(
      current.copyWith(
        draft: change(current.draft),
        autoSave: AutoSaveState.pending,
      ),
    );
    _schedule();
  }

  void _write(JournalEntryState next) {
    _latest = next;
    if (!_disposed) state = AsyncData(next);
  }

  void _schedule() {
    _revision++;
    _timer?.cancel();
    _timer = Timer(_debounce, _save);
  }

  Future<void> _save() async {
    _timer?.cancel();
    final current = _latest;
    if (current == null) return;

    final revision = _revision;
    final draft = await _resolveDraft(current, createCue: false);
    final sessionId = await ensureSession();
    await _sessions.saveDraft(sessionId, draft);

    final latest = _latest;
    if (latest == null) return;
    _write(
      latest.copyWith(
        sessionId: sessionId,
        // 저장하는 동안 또 바뀌었으면 다음 디바운스가 돌고 있다.
        autoSave: _revision == revision ? AutoSaveState.saved : latest.autoSave,
      ),
    );
  }

  /// 저장할 draft를 만든다. 큐 텍스트를 cueId로 바꾸는 게 핵심이다.
  ///
  /// [createCue]가 false(자동 저장)면 **이미 있는 큐와 일치할 때만** 연결한다.
  /// 타이핑 중간값으로 큐 행이 쌓이지 않게 하려는 것이고, 새 큐를 만드는 건
  /// 저장 버튼에서만 한다(명세 3번).
  Future<SessionDraft> _resolveDraft(
    JournalEntryState current, {
    required bool createCue,
  }) async {
    final text = CueRepository.normalize(current.cueText);
    if (text.isEmpty) {
      return current.draft.copyWith(cueId: null, cueApplied: null);
    }
    final cue = createCue
        ? await _cues.findOrCreate(text)
        : await _cues.findByText(text);
    return current.draft.copyWith(cueId: cue?.id);
  }

  /// 페이지를 떠날 때. 남은 변경이 있으면 즉시 저장한다.
  ///
  /// `await`할 수 없지만 DB 프로바이더는 keepAlive라 쓰기는 끝까지 진행된다.
  void _handleDispose() {
    _disposed = true;
    final pending = _timer?.isActive ?? false;
    _timer?.cancel();
    if (pending) _save();
  }
}
