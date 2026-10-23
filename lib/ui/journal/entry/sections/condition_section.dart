import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/db/enums.dart';
import '../../../core/labels.dart';
import '../../../core/widgets/app_choice_chips.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../core/widgets/entry_card.dart';
import '../../../core/widgets/form_section.dart';
import '../journal_entry_notifier.dart';
import '../journal_entry_state.dart';

/// 컨디션 · 마지막 식사. 둘 다 기본값이 없고, 다시 누르면 해제된다(명세 3번).
class ConditionSection extends ConsumerWidget {
  const ConditionSection({
    super.key,
    required this.state,
    required this.entryArg,
  });

  final JournalEntryState state;
  final int? entryArg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(journalEntryProvider(entryArg).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSection(
          label: '컨디션',
          child: SegmentedTabs<int>(
            tabs: const [
              SegmentedTab(1, '별로'),
              SegmentedTab(2, '쏘쏘'),
              SegmentedTab(3, '굿'),
            ],
            value: state.draft.conditionScore,
            onChanged: notifier.setConditionScore,
          ),
        ),
        const EntryGap(),
        FormSection(
          label: '마지막 식사',
          hint: '시작 기준',
          child: AppChoiceChips<LastMealBucket>(
            chips: [
              for (final bucket in LastMealBucket.values)
                AppChip(bucket, bucket.label),
            ],
            value: state.draft.lastMealBucket,
            onChanged: notifier.setLastMeal,
          ),
        ),
      ],
    );
  }
}
