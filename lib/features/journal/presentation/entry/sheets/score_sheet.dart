import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/db/app_database.dart';
import '../../../../../core/db/enums.dart';
import '../../labels.dart';
import '../../widgets/app_choice_chips.dart';
import '../../widgets/score_stepper.dart';
import '../entry_providers.dart';
import '../journal_entry_notifier.dart';

/// 스코어 추가 하단 시트.
///
/// **추가해도 시트가 닫히지 않는다.** 한 세션에서 여러 게임을 연달아 넣는 게
/// 보통이라, 시트 안에서 지금까지 넣은 스코어를 보면서 계속 추가하게 한다.
/// 목록의 스코어를 누르면 바로 지워진다.
Future<void> showScoreSheet(BuildContext context, {required int? entryArg}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _ScoreSheet(entryArg: entryArg),
  );
}

class _ScoreSheet extends ConsumerStatefulWidget {
  const _ScoreSheet({required this.entryArg});

  final int? entryArg;

  @override
  ConsumerState<_ScoreSheet> createState() => _ScoreSheetState();
}

class _ScoreSheetState extends ConsumerState<_ScoreSheet> {
  GameFormat _format = GameFormat.mixedDoubles;
  bool _unknownScore = false;
  int _myScore = 0;
  int _opponentScore = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.read(journalEntryProvider(widget.entryArg).notifier);
    final sessionId = ref
        .watch(journalEntryProvider(widget.entryArg))
        .value
        ?.sessionId;
    final games =
        ref.watch(sessionGamesProvider(sessionId)).value ?? const <Game>[];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('스코어', style: theme.textTheme.titleMedium),
            if (games.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final game in games)
                    InputChip(
                      label: Text(scoreLabel(game)),
                      // 누르거나 x를 눌러도 바로 지워진다.
                      onPressed: () => notifier.removeGame(game.id),
                      onDeleted: () => notifier.removeGame(game.id),
                      deleteIcon: const Icon(Icons.close, size: 16),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '누르면 삭제돼요',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text('형태', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            AppChoiceChips<GameFormat>(
              chips: [
                for (final format in GameFormat.values)
                  AppChip(format, format.label),
              ],
              value: _format,
              // 형태는 비울 수 없다(테이블에서 필수값).
              onChanged: (value) => setState(() => _format = value ?? _format),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('스코어', style: theme.textTheme.titleSmall),
                const Spacer(),
                Text('스코어 모름', style: theme.textTheme.bodyMedium),
                Switch(
                  value: _unknownScore,
                  onChanged: (value) => setState(() => _unknownScore = value),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ScoreStepper(
                    label: '나',
                    value: _unknownScore ? null : _myScore,
                    onChanged: (value) => setState(() => _myScore = value),
                  ),
                ),
                Expanded(
                  child: ScoreStepper(
                    label: '상대',
                    value: _unknownScore ? null : _opponentScore,
                    onChanged: (value) =>
                        setState(() => _opponentScore = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                await notifier.addGame(
                  format: _format,
                  myScore: _unknownScore ? null : _myScore,
                  opponentScore: _unknownScore ? null : _opponentScore,
                );
                // 다음 게임을 바로 넣을 수 있게 스코어만 0으로 되돌린다.
                if (!mounted) return;
                setState(() {
                  _myScore = 0;
                  _opponentScore = 0;
                });
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }
}
