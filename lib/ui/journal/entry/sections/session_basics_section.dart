import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/db/enums.dart';
import '../../../core/formatters.dart';
import '../../../../domain/models/session_time_math.dart';
import '../../../core/labels.dart';
import '../../../core/widgets/entry_text.dart';
import '../../../core/widgets/form_section.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../core/widgets/value_stepper.dart';
import '../journal_entry_notifier.dart';
import '../journal_entry_state.dart';
import '../sheets/time_range_sheet.dart';

/// 세션 유형.
class SessionTypeSection extends ConsumerWidget {
  const SessionTypeSection({
    super.key,
    required this.state,
    required this.entryArg,
  });

  final JournalEntryState state;

  /// 작성 화면 notifier의 family 키(= 페이지에 들어올 때의 sessionId).
  final int? entryArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(journalEntryProvider(entryArg).notifier);
    return FormSection(
      label: '세션 유형',
      child: SegmentedTabs<SessionType>(
        tabs: [
          for (final type in SessionType.values) SegmentedTab(type, type.label),
        ],
        value: state.draft.sessionType,
        // 기본값 게임. 해제할 수 없다.
        allowEmpty: false,
        onChanged: (value) =>
            notifier.setSessionType(value ?? SessionType.game),
      ),
    );
  }
}

/// 일시 — 날짜와 시작·종료 시간.
class DateTimeSection extends ConsumerWidget {
  const DateTimeSection({
    super.key,
    required this.state,
    required this.entryArg,
    required this.onBeforeSheet,
  });

  final JournalEntryState state;
  final int? entryArg;

  /// 시트나 팝업을 열기 전에 호출한다(입력칸 포커스 해제).
  final VoidCallback onBeforeSheet;

  Future<void> _pickDate(
    BuildContext context,
    JournalEntryNotifier notifier,
  ) async {
    onBeforeSheet();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.draft.date,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked != null) notifier.setDate(picked);
  }

  Future<void> _pickTime(
    BuildContext context,
    JournalEntryNotifier notifier,
  ) async {
    onBeforeSheet();
    final picked = await showTimeRangeSheet(
      context,
      initial: state.timeRange,
      frequent: state.frequentRanges,
    );
    if (picked != null) notifier.setTimeRange(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(journalEntryProvider(entryArg).notifier);
    final range = state.timeRange;

    return FormSection(
      label: '일시',
      // 모바일에서 두 가지 조작법을 알 수 있게 라벨 옆에 한 줄로 둔다.
      hint: '시간을 누르면 휠 · ±는 10분',
      // 종료가 시작보다 이른 값은 ±·휠에서 막으므로, 이 오류는 과거 데이터를
      // 불러왔을 때만 보인다. ± 한계 안내도 같은 자리에 띄운다.
      error: state.timeErrorText ?? state.timeLimitText,
      child: Column(
        children: [
          // 날짜 표시와 선택을 한 블록으로 묶는다. 어디를 눌러도 선택기가 열린다.
          Tooltip(
            message: '날짜 선택',
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _pickDate(context, notifier),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          Formatters.koreanDate(state.draft.date),
                          style: entryValueStyle(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ValueStepper(
            label: '시작',
            text: Formatters.minutesOfDay(range.startMinutes),
            onDecrease: () => notifier.stepStart(-SessionTimeMath.stepMinutes),
            onIncrease: () => notifier.stepStart(SessionTimeMath.stepMinutes),
            onTapValue: () => _pickTime(context, notifier),
          ),
          const SizedBox(height: 10),
          ValueStepper(
            label: '종료',
            text: Formatters.minutesOfDay(range.endMinutes),
            onDecrease: () => notifier.stepEnd(-SessionTimeMath.stepMinutes),
            onIncrease: () => notifier.stepEnd(SessionTimeMath.stepMinutes),
            onTapValue: () => _pickTime(context, notifier),
          ),
        ],
      ),
    );
  }
}
