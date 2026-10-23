import 'package:flutter/material.dart';

/// 메모 수정 시트의 결과.
class MemoEditResult {
  const MemoEditResult.save(this.text) : deleted = false;
  const MemoEditResult.delete() : text = null, deleted = true;

  /// 고친 내용. 삭제를 고르면 null.
  final String? text;
  final bool deleted;
}

/// 메모 수정 하단 시트. 수정과 삭제를 함께 한다(취소하면 null).
///
/// 메모 한 줄이 조회·집계의 기본 단위라, 수정에서는 줄을 나누지 않고
/// 한 줄만 고치게 한다.
Future<MemoEditResult?> showMemoEditSheet(
  BuildContext context, {
  required String initial,
}) {
  return showModalBottomSheet<MemoEditResult>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _MemoEditSheet(initial: initial),
  );
}

class _MemoEditSheet extends StatefulWidget {
  const _MemoEditSheet({required this.initial});

  final String initial;

  @override
  State<_MemoEditSheet> createState() => _MemoEditSheetState();
}

class _MemoEditSheetState extends State<_MemoEditSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Navigator.of(context).pop(MemoEditResult.save(text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('메모 수정', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('저장')),
            const SizedBox(height: 4),
            // 지운 뒤에는 실행 취소 스낵바가 뜨므로 따로 확인을 묻지 않는다.
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(const MemoEditResult.delete()),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: const Text('삭제'),
            ),
          ],
        ),
      ),
    );
  }
}
