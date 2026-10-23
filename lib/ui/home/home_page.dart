import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../core/formatters.dart';
import '../../data/repositories/session_repository.dart';
import '../../domain/models/session_list_item.dart';
import '../core/labels.dart';
import '../core/widgets/swipe_delete_background.dart';
import 'home_providers.dart';

/// 메인 화면. 새 일지 쓰기 + 일지 목록.
///
/// 명세 2번은 "작성 중인 일지 이어쓰기"만 두기로 했지만, 2단계 화면을 보려고
/// 매번 1단계를 새로 쓰는 게 번거로워서 **저장을 끝낸 일지까지 모두** 목록으로
/// 두고 어디까지 진행됐는지 배지로 표시한다. 줄을 탭하면 1단계, 오른쪽 태그
/// 버튼을 누르면 2단계로 바로 간다.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  /// 일지를 지우고 실행 취소 스낵바를 띄운다.
  ///
  /// 메모 삭제와 같은 방식이다 — 지운 뒤에 되돌릴 길이 있으니 따로 확인을 묻지
  /// 않는다. 되돌리면 게임·메모·태그 연결까지 그대로 돌아온다.
  Future<void> _delete(
    ScaffoldMessengerState messenger,
    SessionRepository repository,
    int sessionId,
  ) async {
    final removed = await repository.remove(sessionId);
    if (removed == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: const Text('일지를 지웠어요.'),
        duration: const Duration(seconds: 5),
        // SnackBar는 action이 있으면 persist가 기본 true라서 duration을 무시하고
        // 사용자가 끌 때까지 남는다. 5초 뒤 저절로 사라지게 명시적으로 끈다.
        persist: false,
        action: SnackBarAction(
          label: '실행 취소',
          onPressed: () => repository.restore(removed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessions = ref.watch(sessionListProvider).value;
    final repository = ref.watch(sessionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('테니스 일지')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: sessions == null
                  ? const Center(child: CircularProgressIndicator())
                  : sessions.isEmpty
                  ? Center(
                      child: Text(
                        '아직 쓴 일지가 없어요.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      // 마지막 칸은 "밀어서 삭제" 안내다.
                      itemCount: sessions.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index == sessions.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 2, left: 4),
                            child: Text(
                              '밀어서 삭제',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }

                        final item = sessions[index];
                        return Dismissible(
                          key: ValueKey('session-${item.id}'),
                          // 안내 문구대로 어느 쪽으로 밀어도 지워진다.
                          direction: DismissDirection.horizontal,
                          background: const SwipeDeleteBackground(
                            alignment: Alignment.centerLeft,
                          ),
                          secondaryBackground: const SwipeDeleteBackground(),
                          onDismissed: (_) => _delete(
                            ScaffoldMessenger.of(context),
                            repository,
                            item.id,
                          ),
                          child: _SessionRow(item: item),
                        );
                      },
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: FilledButton.icon(
                onPressed: () => context.push(JournalRoutes.newJournal),
                icon: const Icon(Icons.edit_note),
                label: const Text('새 일지 쓰기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.item});

  static const _radius = 12.0;

  final SessionListItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(_radius);

    final subtitle = [
      item.sessionType.label,
      item.placeName ?? '장소 없음',
      '메모 ${item.memoCount}',
    ].join(' · ');

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => context.push(JournalRoutes.entry(item.id)),
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Formatters.dateWithWeekday(item.date),
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(width: 8),
                        _ProgressBadge(progress: item.progress),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // 2단계로 바로 가는 길. 목록을 둔 이유가 이것이다.
              // 메모가 없으면 확인할 태그도 없어서 감춘다. 자리는 그대로 비워
              // 둬야 버튼 있는 줄과 높이가 같다.
              if (item.memoCount > 0)
                IconButton(
                  onPressed: () =>
                      context.push(JournalRoutes.tagReview(item.id)),
                  icon: const Icon(Icons.sell_outlined),
                  tooltip: '태그 확인',
                )
              else
                const SizedBox.square(dimension: kMinInteractiveDimension),
            ],
          ),
        ),
      ),
    );
  }
}

/// 어디까지 진행됐는지 알려 주는 배지.
class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.progress});

  final JournalProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (label, background, foreground) = switch (progress) {
      JournalProgress.writing => (
        '작성 중',
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      JournalProgress.saved => (
        '태그 확인 전',
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      JournalProgress.reviewed => (
        '확인 완료',
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}
