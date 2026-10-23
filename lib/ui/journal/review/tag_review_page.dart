import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../data/repositories/memo_repository.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../domain/models/memo_with_tags.dart';
import 'review_providers.dart';
import 'widgets/memo_review_card.dart';

/// 일지 작성 2단계: 태그·평가 확인(명세 5번).
///
/// 저장 때 자동으로 붙은 태그·평가를 메모별로 훑어보고 확정하거나 지우는
/// 화면이다. **변경 사항은 즉시 DB에 반영**하고, 화면은 조인 스트림이 다시
/// 흘려보내는 값을 그린다 — 그래서 따로 들고 있는 편집 상태가 없다.
class TagReviewPage extends ConsumerWidget {
  const TagReviewPage({super.key, required this.sessionId});

  final int sessionId;

  /// 1단계에서 저장 시트를 거쳐 들어오면 `/journal/:id` 위에 쌓여서 pop으로
  /// 돌아갈 수 있다. 메인에서 바로 이 경로로 들어온 경우에는 돌아갈 자리가
  /// 없으므로 메인으로 보낸다.
  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(JournalRoutes.home);
    }
  }

  /// 하단 "완료". 2단계를 지났다고 기록하고 메인으로.
  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    await ref.read(sessionRepositoryProvider).markTagReviewed(sessionId);
    if (context.mounted) context.go(JournalRoutes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntries = ref.watch(sessionMemosWithTagsProvider(sessionId));
    final entries = asyncEntries.value;
    final hasSuggestions =
        entries?.any((entry) => entry.hasSuggestions) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('태그 확인'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _back(context),
          tooltip: '뒤로',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: hasSuggestions
                  ? () => ref
                        .read(memoRepositoryProvider)
                        .confirmAllSuggestions(sessionId)
                  : null,
              child: const Text('모두 확인'),
            ),
          ),
        ],
      ),
      body: entries != null
          ? _ReviewList(
              entries: entries,
              onComplete: () => _complete(context, ref),
            )
          : asyncEntries.hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('메모를 불러오지 못했어요.\n${asyncEntries.error}'),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList({required this.entries, required this.onComplete});

  final List<MemoWithTags> entries;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Text(
                      '메모가 없어요.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: entries.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      // 안내 문구는 목록의 첫 칸으로 둬서 함께 스크롤되게 한다.
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '추천 태그/평가는 점선으로 표시돼요. 터치하면 태그/평가가 확정돼요.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }
                      return MemoReviewCard(entry: entries[index - 1]);
                    },
                  ),
          ),
          // 1단계 저장 버튼과 같은 자리·같은 모양으로 하단에 고정한다.
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: FilledButton(onPressed: onComplete, child: const Text('완료')),
          ),
        ],
      ),
    );
  }
}
