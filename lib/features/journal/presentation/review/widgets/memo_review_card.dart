import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/memo_repository.dart';
import '../../../domain/memo_with_tags.dart';
import '../../widgets/entry_card.dart';
import '../sheets/tag_add_sheet.dart';
import 'evaluation_picker.dart';
import 'tag_status_chip.dart';

/// 태그 확인 화면의 카드 한 장 = 메모 하나(명세 5번).
///
/// 내용 → 태그 칩들 → `＋ 태그 추가` 칩 → 평가 아이콘 순으로 쌓는다. 모든 변경은
/// 바로 DB에 쓰고, 화면은 조인 스트림이 다시 흘려보내는 값을 그린다.
class MemoReviewCard extends ConsumerWidget {
  const MemoReviewCard({super.key, required this.entry});

  final MemoWithTags entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final memos = ref.watch(memoRepositoryProvider);
    final memo = entry.memo;

    return EntryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(memo.content, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final tag in entry.tags)
                TagStatusChip(
                  label: tag.name,
                  confirmed: tag.isConfirmed,
                  onConfirm: () => memos.confirmTag(memo.id, tag.tagId),
                  onDelete: () => memos.rejectTag(memo.id, tag.tagId),
                ),
              AddTagChip(
                onTap: () => showTagAddSheet(context, memoId: memo.id),
              ),
            ],
          ),
          const SizedBox(height: 10),
          EvaluationPicker(
            evaluation: memo.evaluation,
            status: memo.evaluationStatus,
            onChanged: (value) => memos.setEvaluation(memo.id, value),
          ),
        ],
      ),
    );
  }
}
