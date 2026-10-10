import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/db/app_database.dart';
import '../../../../../core/db/enums.dart';
import '../../labels.dart';
import '../../widgets/form_section.dart';
import '../entry_providers.dart';
import '../journal_entry_state.dart';
import '../sheets/score_sheet.dart';

/// 스코어. **세션 유형이 게임일 때만 보인다.**
///
/// 경기 유형별로 묶어서, 유형 이름 옆에 스코어만 입력 순으로 늘어놓는다.
/// 추가·삭제는 모두 하단 시트에서 한다.
class ScoreSection extends ConsumerWidget {
  const ScoreSection({
    super.key,
    required this.state,
    required this.entryArg,
    required this.onBeforeSheet,
  });

  final JournalEntryState state;
  final int? entryArg;

  /// 시트를 열기 전에 호출한다(입력칸 포커스 해제).
  final VoidCallback onBeforeSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final games =
        ref.watch(sessionGamesProvider(state.sessionId)).value ??
        const <Game>[];

    // 유형 순서는 열거형 순서를 따른다(여복 → … → 단식). 한 유형 안에서는
    // 입력 순(orderIndex)이고, 그건 리포지토리가 이미 맞춰서 준다.
    final groups = <GameFormat, List<Game>>{};
    for (final game in games) {
      groups.putIfAbsent(game.format, () => []).add(game);
    }
    final formats = GameFormat.values
        .where(groups.containsKey)
        .toList(growable: false);

    return FormSection(
      label: '스코어',
      // 추가·삭제는 모두 시트에서 하므로 "편집" 아이콘을 카드 맨 위 오른쪽에 둔다.
      trailing: IconButton.filled(
        onPressed: () {
          onBeforeSheet();
          showScoreSheet(context, entryArg: entryArg);
        },
        icon: const Icon(Icons.edit),
        tooltip: '스코어 편집',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (formats.isEmpty)
            Text(
              '스코어 기록 없음',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (var i = 0; i < formats.length; i++) ...[
              // 유형이 바뀌는 자리에만 구분선을 둔다.
              if (i > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
              _FormatRow(format: formats[i], games: groups[formats[i]]!),
            ],
        ],
      ),
    );
  }
}

/// 유형 하나와 그 유형의 스코어들.
class _FormatRow extends StatelessWidget {
  const _FormatRow({required this.format, required this.games});

  final GameFormat format;
  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Text(
              format.label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [for (final game in games) _ScoreChip(game: game)],
          ),
        ),
      ],
    );
  }
}

/// 스코어 하나. **이긴 경기만** 연한 파란 면이고 나머지는 흰 면이다.
class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final win = isWin(game);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: win
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        scoreValueLabel(game),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: win ? FontWeight.w700 : FontWeight.w500,
          color: win
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
