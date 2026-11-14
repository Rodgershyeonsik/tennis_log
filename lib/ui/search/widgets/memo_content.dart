import 'package:flutter/material.dart';

import '../../../data/db/enums.dart';
import '../../core/labels.dart';
import '../../core/widgets/evaluation_display.dart';

/// 메모 본문 전체 + 확정 태그 + 평가 아이콘. 조회 결과 카드와 세션 상세
/// 시트가 같이 쓴다.
///
/// 태그는 칩이 아니라 `#서브  #발리`처럼 굵은 글자로 늘어놓고(띄어쓰기의 1.5배
/// 간격), 평가는 작은 아이콘 하나만 오른쪽 끝에 둔다. 표시 전용이라 눌러도 아무 동작이 없다.
class MemoContent extends StatelessWidget {
  const MemoContent({
    super.key,
    required this.content,
    required this.tagNames,
    required this.evaluation,
  });

  final String content;
  final List<String> tagNames;

  /// 확정된 평가. null이거나 없음(none)이면 아이콘을 생략한다.
  final MemoEvaluation? evaluation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final evaluation = this.evaluation;
    final showEvaluation =
        evaluation != null && evaluation != MemoEvaluation.none;
    final tagStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.primary,
    );

    // 카드의 다른 줄(날짜·장소)보다 조금 안쪽으로 들인다.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content, style: theme.textTheme.bodyLarge),
          if (tagNames.isNotEmpty || showEvaluation) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: _tagGap(context, tagStyle),
                    children: [
                      for (final name in tagNames)
                        Text('#$name', style: tagStyle),
                    ],
                  ),
                ),
                if (showEvaluation) ...[
                  const SizedBox(width: 8),
                  Tooltip(
                    message: evaluation.label,
                    child: Icon(
                      evaluationIcon(evaluation),
                      size: 18,
                      color: evaluationColor(context, evaluation),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 태그 사이 간격. 같은 글자 모양의 띄어쓰기 한 칸의 1.5배다.
///
/// 글자 크기 설정을 따라 커지도록 화면의 글자 배율을 함께 쓴다.
double _tagGap(BuildContext context, TextStyle? style) {
  final painter = TextPainter(
    text: TextSpan(text: ' ', style: style),
    textDirection: TextDirection.ltr,
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width * 1.5;
}
