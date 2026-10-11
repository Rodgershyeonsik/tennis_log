import 'package:flutter/material.dart';

import '../../../../../core/db/enums.dart';
import '../../labels.dart';
import '../../widgets/dashed_border.dart';
import 'chip_metrics.dart';

/// 메모 평가 아이콘 3개(명세 5번).
///
/// 하나만 선택되고, **선택된 것을 다시 누르면 해제**된다. 자동 추천된 평가
/// (suggested)는 점선 테두리로 표시하고, 그 아이콘을 누르면 confirmed가 된다 —
/// 그래서 "다시 누르면 해제"는 **confirmed일 때만** 적용한다.
class EvaluationPicker extends StatelessWidget {
  const EvaluationPicker({
    super.key,
    required this.evaluation,
    required this.status,
    required this.onChanged,
  });

  /// 자동 추천이 든 쪽은 초록 계열이 colorScheme에 없어서 직접 정한다.
  /// bad는 `error`, question은 `primary`를 그대로 쓰므로 어두운 테마에서도
  /// 테마가 알아서 맞춰 준다. 초록만 두 가지를 들고 있는다.
  static const _goodLight = Color(0xFF1B8A4B);
  static const _goodDark = Color(0xFF6BD69B);

  final MemoEvaluation? evaluation;

  /// 평가가 자동 추천값인지 사용자가 확인한 값인지. 평가가 없으면 null이다.
  final EvaluationStatus? status;

  /// null을 넘기면 평가 해제다.
  final ValueChanged<MemoEvaluation?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      // 48dp 터치 영역 안에서 네모가 가운데 놓이며 좌우 2dp씩이 남는다. 그것만
      // 으로는 버튼이 서로 붙어 보여서 조금 보탠다.
      spacing: 4,
      children: [
        for (final value in MemoEvaluation.values)
          _EvaluationIcon(
            value: value,
            state: _stateOf(value),
            color: _colorOf(context, value),
            onTap: () => _handleTap(value),
          ),
      ],
    );
  }

  _IconState _stateOf(MemoEvaluation value) {
    if (evaluation != value) return _IconState.idle;
    // 평가가 있으면 status도 있다(데이터 모델). 없으면 확정으로 본다.
    return status == EvaluationStatus.suggested
        ? _IconState.suggested
        : _IconState.confirmed;
  }

  void _handleTap(MemoEvaluation value) {
    final isConfirmedSame =
        evaluation == value && status == EvaluationStatus.confirmed;
    // 확인해 둔 평가를 다시 누르면 해제, 그 밖에는 그 평가로 확정한다.
    onChanged(isConfirmedSame ? null : value);
  }

  static Color _colorOf(BuildContext context, MemoEvaluation value) {
    final theme = Theme.of(context);
    return switch (value) {
      MemoEvaluation.good =>
        theme.brightness == Brightness.dark ? _goodDark : _goodLight,
      MemoEvaluation.bad => theme.colorScheme.error,
      MemoEvaluation.question => theme.colorScheme.primary,
    };
  }
}

/// 아이콘 하나가 가질 수 있는 세 가지 모습.
///
/// 면은 **고르지 않음과 추천이 모두 흰색**이고, 둘은 테두리로만 갈린다
/// (실선 / 점선). 확정만 색 면을 쓴다.
enum _IconState {
  /// 고르지 않은 상태. `＋` 태그 칩과 같은 **실선 테두리 + 흰 면**이다.
  idle,

  /// 자동 추천된 평가. **점선 테두리 + 흰 면.**
  suggested,

  /// 사용자가 확정한 평가. **테두리 없이 색 면만** 채운다.
  confirmed,
}

class _EvaluationIcon extends StatelessWidget {
  const _EvaluationIcon({
    required this.value,
    required this.state,
    required this.color,
    required this.onTap,
  });

  /// 아이콘 글리프 크기. 네모 한 변의 절반쯤 되게 둬서 속이 비어 보이지 않는다.
  static const _iconSize = 22.0;

  final MemoEvaluation value;
  final _IconState state;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = state != _IconState.idle;
    // 태그 칩과 같은 둥근 정도를 쓴다. 한 카드 안에 같이 놓이므로 모서리가
    // 어긋나면 바로 눈에 띈다.
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ChipMetrics.radius),
    );

    final face = Material(
      color: switch (state) {
        // 카드 위에 올라가므로 한 단계 밝은 면이 "흰 배경"이 된다.
        // 고르지 않음과 추천은 면이 같고 테두리(실선/점선)로만 갈린다.
        _IconState.idle || _IconState.suggested => scheme.surface,
        _IconState.confirmed => color.withValues(alpha: 0.14),
      },
      shape: state == _IconState.idle
          // `＋` 태그 칩과 같은 테두리 색.
          ? shape.copyWith(side: BorderSide(color: scheme.outlineVariant))
          : shape,
      child: Center(
        child: Icon(
          _iconOf(value, filled: selected),
          size: _iconSize,
          color: selected ? color : scheme.onSurfaceVariant,
        ),
      ),
    );

    // 보이는 네모보다 손가락이 닿는 영역을 크게 잡는다.
    // **탭을 받는 건 바깥 48dp 쪽이다** — 네모 안에 두면 터치 영역도 함께
    // 줄어든다. 누를 때의 효과는 앱 전체에서 끄므로 InkWell이 보이는 면
    // 바깥에 있어도 달라 보이지 않는다.
    return SizedBox.square(
      dimension: ChipMetrics.touchSize,
      child: Tooltip(
        message: value.label,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: SizedBox(
              width: ChipMetrics.evaluationWidth,
              height: ChipMetrics.evaluationHeight,
              child: state == _IconState.suggested
                  ? DashedBorder(
                      color: color,
                      radius: ChipMetrics.radius,
                      child: face,
                    )
                  : face,
            ),
          ),
        ),
      ),
    );
  }

  static IconData _iconOf(MemoEvaluation value, {required bool filled}) {
    return switch (value) {
      MemoEvaluation.good => filled ? Icons.thumb_up : Icons.thumb_up_outlined,
      MemoEvaluation.bad =>
        filled ? Icons.thumb_down : Icons.thumb_down_outlined,
      MemoEvaluation.question => filled ? Icons.help : Icons.help_outline,
    };
  }
}
