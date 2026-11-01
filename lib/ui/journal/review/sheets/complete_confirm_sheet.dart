import 'package:flutter/material.dart';

import '../../../../domain/models/review_pending.dart';

/// "완료"를 눌렀는데 확정되지 않은 것이 남아 있을 때의 확인 시트(02 명세 5번).
///
/// "확정하고 완료"를 고르면 true, 돌아가기나 바깥을 눌러 닫으면 false/null이다.
Future<bool?> showCompleteConfirmSheet(
  BuildContext context, {
  required ReviewPending pending,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      // 문구는 명세에 정한 줄만 둔다. 제목을 따로 달지 않으므로 본문을 한
      // 단계 크게 쓴다.
      final bodyStyle = theme.textTheme.bodyLarge;
      final suggested = [
        if (pending.suggestedTagCount > 0)
          '추천 태그 ${pending.suggestedTagCount}개',
        if (pending.suggestedEvaluationCount > 0)
          '추천 평가 ${pending.suggestedEvaluationCount}개',
      ];

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              if (suggested.isNotEmpty)
                Text(
                  '${suggested.join(', ')}는 추천된 그대로 확정돼요.',
                  style: bodyStyle,
                ),
              if (suggested.isNotEmpty && pending.unsetEvaluationCount > 0)
                const SizedBox(height: 6),
              if (pending.unsetEvaluationCount > 0)
                Text(
                  "평가를 고르지 않은 메모 ${pending.unsetEvaluationCount}개는 '없음'으로 확정돼요.",
                  style: bodyStyle,
                ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('확정하고 완료'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
