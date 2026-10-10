import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/db/app_database.dart';
import '../../widgets/entry_list_row.dart';
import '../../widgets/form_section.dart';
import '../../widgets/swipe_delete_background.dart';
import '../entry_providers.dart';
import '../journal_entry_notifier.dart';
import '../journal_entry_state.dart';
import '../sheets/memo_edit_sheet.dart';

/// 메모 목록 + 입력칸. 메모 한 줄이 조회·집계의 기본 단위다.
///
/// 입력칸 컨트롤러와 포커스는 페이지가 들고 있다. 추가 후에도 포커스를 유지해야
/// 해서(명세 3번) 페이지의 [onSubmit]이 추가와 비우기를 함께 처리한다.
class MemosSection extends ConsumerWidget {
  const MemosSection({
    super.key,
    required this.state,
    required this.entryArg,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    required this.onBeforeSheet,
  });

  final JournalEntryState state;
  final int? entryArg;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  /// 시트를 열기 전에 호출한다(입력칸 포커스 해제).
  final VoidCallback onBeforeSheet;

  /// 메모를 지우고 실행 취소 스낵바를 띄운다.
  ///
  /// 수정 시트의 삭제와 왼쪽으로 밀어 삭제가 똑같이 동작해야 해서 한곳에 둔다.
  Future<void> _delete(
    ScaffoldMessengerState messenger,
    JournalEntryNotifier notifier,
    int memoId,
  ) async {
    final removed = await notifier.removeMemo(memoId);
    if (removed == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: const Text('메모를 지웠어요.'),
        duration: const Duration(seconds: 5),
        // SnackBar는 action이 있으면 persist가 기본 true라서 duration을 무시하고
        // 사용자가 끌 때까지 남는다. 5초 뒤 자동으로 사라지게 명시적으로 끈다.
        persist: false,
        action: SnackBarAction(
          label: '실행 취소',
          // 태그 연결까지 그대로 되돌린다.
          onPressed: () => notifier.restoreMemo(removed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(journalEntryProvider(entryArg).notifier);
    final memos =
        ref.watch(sessionMemosProvider(state.sessionId)).value ??
        const <Memo>[];

    return FormSection(
      label: '메모 ${memos.length}',
      trailing: IconButton.filled(
        onPressed: onSubmit,
        icon: const Icon(Icons.add),
        tooltip: '메모 추가',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final memo in memos) ...[
            Dismissible(
              key: ValueKey('memo-${memo.id}'),
              // 안내 문구대로 오른쪽으로 밀어도, 반대로 밀어도 지워진다.
              direction: DismissDirection.horizontal,
              background: const SwipeDeleteBackground(
                alignment: Alignment.centerLeft,
              ),
              secondaryBackground: const SwipeDeleteBackground(),
              onDismissed: (_) =>
                  _delete(ScaffoldMessenger.of(context), notifier, memo.id),
              child: EntryListRow(
                text: memo.content,
                onTap: () async {
                  onBeforeSheet();
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await showMemoEditSheet(
                    context,
                    initial: memo.content,
                  );
                  if (result == null) return;
                  if (result.deleted) {
                    await _delete(messenger, notifier, memo.id);
                  } else {
                    await notifier.updateMemo(memo.id, result.text!);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (memos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '밀어서 삭제',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            focusNode: focusNode,
            // 여러 줄 붙여넣기를 그대로 받으려면 멀티라인이어야 한다.
            // 엔터는 페이지가 줄바꿈으로 감지해서 추가로 처리한다.
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 4,
            decoration: const InputDecoration(hintText: '메모 한 줄'),
          ),
        ],
      ),
    );
  }
}
