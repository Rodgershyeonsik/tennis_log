import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/db/enums.dart';
import '../widgets/entry_card.dart';
import 'entry_providers.dart';
import 'journal_entry_notifier.dart';
import 'journal_entry_state.dart';
import 'sections/condition_section.dart';
import 'sections/cue_section.dart';
import 'sections/score_section.dart';
import 'sections/memos_section.dart';
import 'sections/place_section.dart';
import 'sections/session_basics_section.dart';
import 'sheets/save_result_sheet.dart';

/// 일지 작성 1단계. 세션 기본 정보 + 게임 + 메모를 한 페이지에서 입력한다.
///
/// [sessionId]가 null이면 새 일지, 값이 있으면 작성 중인 일지 이어쓰기다.
/// 이 값이 notifier의 family 키이기도 하다 — 작성 중에 draft가 만들어져도
/// 키는 그대로 두고, 실제 세션 id는 상태(`state.sessionId`)에서 읽는다.
class JournalEntryPage extends ConsumerStatefulWidget {
  const JournalEntryPage({super.key, this.sessionId});

  final int? sessionId;

  @override
  ConsumerState<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends ConsumerState<JournalEntryPage>
    with WidgetsBindingObserver {
  final _cueController = TextEditingController();
  final _memoController = TextEditingController();
  final _memoFocus = FocusNode();

  /// 저장 검증에 걸렸을 때 그 위치로 스크롤하기 위한 키.
  final _placeKey = GlobalKey();

  /// 이어쓰기로 들어왔을 때 큐 입력칸을 한 번만 채운다.
  bool _cueFilled = false;

  /// 직전 키보드 높이. 키보드가 "내려간 순간"만 잡아내려고 들고 있다.
  double _lastBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _memoController.addListener(_handleMemoChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _memoController.removeListener(_handleMemoChanged);
    _cueController.dispose();
    _memoController.dispose();
    _memoFocus.dispose();
    super.dispose();
  }

  JournalEntryNotifier get _notifier =>
      ref.read(journalEntryProvider(widget.sessionId).notifier);

  /// 줄바꿈이 들어오면 메모를 추가한다.
  ///
  /// 입력칸을 멀티라인으로 둔 이유는 **여러 줄 붙여넣기**를 그대로 받기
  /// 위해서다(명세 3번). 그래서 엔터도 줄바꿈으로 들어오고, 여기서 추가로
  /// 해석한다. 붙여넣은 여러 줄은 리포지토리가 줄 단위로 나눠 저장한다.
  void _handleMemoChanged() {
    if (!_memoController.text.contains('\n')) return;
    _submitMemo();
  }

  void _submitMemo() {
    final raw = _memoController.text;
    if (raw.trim().isEmpty) {
      _memoController.clear();
      return;
    }
    // 추가 후 입력칸을 비우고 포커스는 유지한다(명세 3번).
    _memoController.clear();
    _memoFocus.requestFocus();
    _notifier.addMemos(raw);
  }

  /// 안드로이드의 키보드 내림 버튼 대응.
  ///
  /// 키보드만 닫히고 입력칸은 포커스를 쥔 채로 남아서(커서가 계속 깜빡인다)
  /// 다음에 아무 데나 눌러도 키보드가 도로 올라온다. 키보드 높이가 양수에서
  /// 0으로 바뀐 순간에만 포커스를 푼다 — 웹·데스크톱은 늘 0이라 영향이 없다.
  @override
  void didChangeMetrics() {
    final inset = View.of(context).viewInsets.bottom;
    final wasOpen = _lastBottomInset > 0;
    _lastBottomInset = inset;
    if (wasOpen && inset == 0) _unfocus();
  }

  /// 입력칸 포커스를 푼다. 빈 공간을 눌렀을 때와 시트를 열기 전에 쓴다.
  ///
  /// 시트를 열기 전에 풀어 두지 않으면 시트가 닫힐 때 Flutter가 직전 포커스를
  /// 되돌려서, 스코어만 넣었는데 메모 입력칸이 다시 올라온다.
  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  /// "지난 큐"나 불러오기 시트로 큐를 채운다.
  void _fillCue(String text) {
    _cueController.text = text;
    _notifier.setCueText(text);
  }

  Future<void> _scrollToPlace() async {
    final context = _placeKey.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      alignment: 0.1,
      duration: const Duration(milliseconds: 250),
    );
  }

  Future<void> _save(JournalEntryState state) async {
    // 메모가 없으면 저장 후 시트 없이 메인으로 간다(명세 4번).
    final memos = ref.read(sessionMemosProvider(state.sessionId)).value ?? [];

    final outcome = await _notifier.finalize();
    if (!mounted) return;

    if (outcome == null) {
      // 검증 실패. 장소가 비었으면 그 위치로 스크롤한다.
      final current = ref.read(journalEntryProvider(widget.sessionId)).value;
      if (current?.placeMissing ?? false) await _scrollToPlace();
      return;
    }

    if (memos.isEmpty) {
      context.go(JournalRoutes.home);
      return;
    }

    final next = await showSaveResultSheet(
      context,
      suggestedTagCount: outcome.suggestedTagCount,
    );
    if (!mounted) return;
    if (next == SaveNextStep.reviewTags) {
      context.go(JournalRoutes.tagReview(outcome.sessionId));
    } else {
      // "나중에"와 시트를 그냥 닫은 경우 모두 메인으로.
      context.go(JournalRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(journalEntryProvider(widget.sessionId));
    final state = asyncState.value;
    // **Scaffold 안에서는 키보드 높이가 0으로 보인다**(body의 MediaQuery에서
    // 아래쪽 viewInsets를 빼 주기 때문). 그래서 Scaffold 바깥인 여기서 읽는다.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    if (state != null && !_cueFilled) {
      _cueFilled = true;
      final text = state.cueText;
      if (text.isNotEmpty) {
        // 빌드 중에 컨트롤러를 건드리면 안 되므로 프레임 뒤로 넘긴다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _cueController.text = text;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        // 제목은 날짜가 아니라 "지금 뭘 하는 화면인지"를 보여준다.
        title: Text(widget.sessionId == null ? '새 일지 작성' : '일지 수정'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
          tooltip: '뒤로',
        ),
        actions: [
          if (state != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: _AutoSaveLabel(autoSave: state.autoSave)),
            ),
        ],
      ),
      // 빈 공간을 누르면 입력칸 포커스를 푼다(키보드 내리기).
      body: state != null
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _unfocus,
              child: _EntryForm(
                state: state,
                entryArg: widget.sessionId,
                placeKey: _placeKey,
                cueController: _cueController,
                memoController: _memoController,
                memoFocus: _memoFocus,
                onPickCue: _fillCue,
                onSubmitMemo: _submitMemo,
                onBeforeSheet: _unfocus,
                keyboardOpen: keyboardOpen,
                onSave: () => _save(state),
              ),
            )
          : asyncState.hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('일지를 불러오지 못했어요.\n${asyncState.error}'),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _EntryForm extends StatelessWidget {
  const _EntryForm({
    required this.state,
    required this.entryArg,
    required this.placeKey,
    required this.cueController,
    required this.memoController,
    required this.memoFocus,
    required this.onPickCue,
    required this.onSubmitMemo,
    required this.onBeforeSheet,
    required this.keyboardOpen,
    required this.onSave,
  });

  final JournalEntryState state;
  final int? entryArg;
  final Key placeKey;
  final TextEditingController cueController;
  final TextEditingController memoController;
  final FocusNode memoFocus;
  final ValueChanged<String> onPickCue;
  final VoidCallback onSubmitMemo;
  final VoidCallback onBeforeSheet;

  /// 키보드가 올라와 있는가. 페이지가 Scaffold 바깥에서 읽어 넘겨준다.
  final bool keyboardOpen;
  final VoidCallback onSave;

  /// 카드 사이 간격.
  static const _gap = SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                EntryCard(
                  child: SessionTypeSection(state: state, entryArg: entryArg),
                ),
                _gap,
                EntryCard(
                  child: DateTimeSection(
                    state: state,
                    entryArg: entryArg,
                    onBeforeSheet: onBeforeSheet,
                  ),
                ),
                _gap,
                EntryCard(
                  // 저장 검증에 걸리면 이 카드로 스크롤한다.
                  key: placeKey,
                  child: PlaceSection(
                    state: state,
                    entryArg: entryArg,
                    onBeforeSheet: onBeforeSheet,
                  ),
                ),
                _gap,
                EntryCard(
                  child: ConditionSection(state: state, entryArg: entryArg),
                ),
                // 큐는 게임·연습에서 쓰는 것이라 레슨에서는 감춘다.
                if (state.draft.sessionType != SessionType.lesson) ...[
                  _gap,
                  EntryCard(
                    child: CueSection(
                      state: state,
                      entryArg: entryArg,
                      controller: cueController,
                      onPickCue: onPickCue,
                      onBeforeSheet: onBeforeSheet,
                    ),
                  ),
                ],
                // 스코어는 게임 세션에서만 쓴다(레슨·연습에는 스코어가 없다).
                if (state.draft.sessionType == SessionType.game) ...[
                  _gap,
                  EntryCard(
                    child: ScoreSection(
                      state: state,
                      entryArg: entryArg,
                      onBeforeSheet: onBeforeSheet,
                    ),
                  ),
                ],
                _gap,
                EntryCard(
                  child: MemosSection(
                    state: state,
                    entryArg: entryArg,
                    controller: memoController,
                    focusNode: memoFocus,
                    onSubmit: onSubmitMemo,
                    onBeforeSheet: onBeforeSheet,
                  ),
                ),
              ],
            ),
          ),
          // 저장 버튼은 페이지 하단에 고정한다. 스크롤 안에 두면 긴 폼에서
          // 끝까지 내려야 보인다.
          //
          // 키보드가 올라와 있는 동안에는 감춘다. 키보드 바로 위에 버튼이 붙어
          // 있으면 글자를 누르려다 저장이 눌린다. 키보드를 내리면 다시 나온다.
          if (!keyboardOpen)
            Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: scheme.outlineVariant)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: FilledButton(
                onPressed: state.canFinalize ? onSave : null,
                child: state.finalizing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('일지 저장'),
              ),
            ),
        ],
      ),
    );
  }
}

/// 상단 바 오른쪽의 자동 저장 표시.
class _AutoSaveLabel extends StatelessWidget {
  const _AutoSaveLabel({required this.autoSave});

  final AutoSaveState autoSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = switch (autoSave) {
      AutoSaveState.idle => null,
      AutoSaveState.pending => '저장 중…',
      AutoSaveState.saved => '자동 저장됨',
    };
    if (text == null) return const SizedBox.shrink();

    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
