import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/db/enums.dart';
import '../../../core/labels.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../core/widgets/entry_card.dart';
import '../../../core/widgets/form_section.dart';
import '../entry_providers.dart';
import '../journal_entry_notifier.dart';
import '../journal_entry_state.dart';
import '../sheets/cue_picker_sheet.dart';

/// 큐 입력 + 지난 큐 불러오기 + 큐 적용.
///
/// 입력칸 컨트롤러는 페이지가 들고 있다. 시트나 "지난 큐"로 값을 채울 때
/// 컨트롤러와 상태를 함께 바꿔야 해서 [onPickCue]로 페이지에 올린다.
class CueSection extends ConsumerWidget {
  const CueSection({
    super.key,
    required this.state,
    required this.entryArg,
    required this.controller,
    required this.onPickCue,
    required this.onBeforeSheet,
  });

  final JournalEntryState state;
  final int? entryArg;
  final TextEditingController controller;
  final ValueChanged<String> onPickCue;

  /// 시트를 열기 전에 호출한다(입력칸 포커스 해제).
  final VoidCallback onBeforeSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(journalEntryProvider(entryArg).notifier);
    final lastCue = ref.watch(lastUsedCueProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSection(
          label: '큐',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: '예: 임팩트까지 왼팔 유지'),
                onChanged: notifier.setCueText,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  // 과거 큐가 없으면 숨긴다(명세 3번).
                  if (lastCue != null)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => onPickCue(lastCue.cueText),
                          child: Text(
                            '지난 큐: ${lastCue.cueText}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  TextButton.icon(
                    onPressed: () async {
                      onBeforeSheet();
                      final picked = await showCuePickerSheet(context);
                      if (picked != null) onPickCue(picked);
                    },
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text('지난 큐 불러오기'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 큐 입력칸이 비어 있으면 큐 적용은 묻지 않는다(명세 3번).
        if (state.showCueApplied) ...[
          const EntryGap(),
          FormSection(
            label: '큐 적용',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '게임 중에 의식적으로 적용했나요?',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedTabs<CueApplied>(
                  tabs: [
                    for (final applied in CueApplied.values)
                      SegmentedTab(applied, applied.label),
                  ],
                  value: state.draft.cueApplied,
                  onChanged: notifier.setCueApplied,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
