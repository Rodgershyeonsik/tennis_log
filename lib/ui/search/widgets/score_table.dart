import 'package:flutter/material.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../core/labels.dart';

/// 세션 상세 시트의 스코어 표. `혼복 | 6:4  5:6`처럼 한 줄이 경기 유형 하나다.
///
/// 작성 화면의 스코어 묶음과 같은 배치(유형 순으로 묶고 한 유형 안은 입력 순)를
/// 표 모양으로 그린다. 첫 열은 제목 열이라 면 색을 다르게 하고, 이긴 경기는
/// 글자 색과 굵기로 구분한다. 표시 전용이라 눌러도 아무 동작이 없다.
class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key, required this.games});

  static const _radius = 12.0;
  static const _titleWidth = 64.0;

  /// 입력 순(orderIndex)이어야 한다.
  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final groups = <GameFormat, List<Game>>{};
    for (final game in games) {
      groups.putIfAbsent(game.format, () => []).add(game);
    }
    final formats = GameFormat.values.where(groups.containsKey).toList();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < formats.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: _titleWidth,
                    color: scheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Text(
                      formats[i].label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        children: [
                          for (final game in groups[formats[i]]!)
                            _Score(game: game),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 스코어 하나. 이긴 경기는 진한 강조색, 나머지는 흐린 보통 굵기다.
class _Score extends StatelessWidget {
  const _Score({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final win = isWin(game);
    final my = game.myScore;
    final opponent = game.opponentScore;

    return Text(
      my == null || opponent == null ? '스코어 모름' : '$my:$opponent',
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: win ? FontWeight.w700 : FontWeight.w400,
        color: win ? scheme.primary : scheme.onSurfaceVariant,
      ),
    );
  }
}
