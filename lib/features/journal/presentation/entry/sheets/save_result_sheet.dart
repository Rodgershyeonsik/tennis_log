import 'package:flutter/material.dart';

/// 저장 후 하단 시트의 선택.
enum SaveNextStep {
  /// 태그 확인하기 → 2단계 화면
  reviewTags,

  /// 나중에 → 메인
  later,
}

/// 저장 직후 "저장했어요. 추천 태그 N개" 시트(명세 4번).
///
/// 메모가 없으면 이 시트를 띄우지 않고 바로 메인으로 간다 — 그 판단은 화면에서
/// 한다(메모 목록을 이미 알고 있다).
Future<SaveNextStep?> showSaveResultSheet(
  BuildContext context, {
  required int suggestedTagCount,
}) {
  return showModalBottomSheet<SaveNextStep>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('저장했어요', style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                '추천 태그 $suggestedTagCount개',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(SaveNextStep.reviewTags),
                child: const Text('태그 확인하기'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(SaveNextStep.later),
                child: const Text('나중에'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
