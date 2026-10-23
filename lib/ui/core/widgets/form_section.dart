import 'package:flutter/material.dart';

/// 카드 안의 항목 하나. 라벨 + 보조 문구 + 인라인 오류를 공통으로 그린다.
///
/// 항목 사이 간격은 카드가 정한다([EntryGap]). 여기서 아래 여백을 가지면
/// 묶음마다 간격이 달라져서 화면이 들쭉날쭉해진다.
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    required this.label,
    required this.child,
    this.hint,
    this.trailing,
    this.error,
  });

  final String label;

  /// 라벨 옆 보조 문구. 예: 마지막 식사의 "시작 기준"
  final String? hint;

  /// 라벨 줄 오른쪽. 예: 시간의 총 시간
  final Widget? trailing;

  /// 인라인 오류 문구. null이면 자리를 차지하지 않는다.
  final String? error;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.1,
              ),
            ),
            if (hint != null) ...[
              const SizedBox(width: 6),
              Text(
                hint!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (trailing != null) ...[const Spacer(), trailing!],
          ],
        ),
        const SizedBox(height: 10),
        child,
        if (error != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
