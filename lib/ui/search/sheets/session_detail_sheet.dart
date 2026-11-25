import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../../domain/search/search_models.dart';
import '../../core/formatters.dart';
import '../../core/labels.dart';
import '../../core/widgets/form_section.dart';
import '../search_providers.dart';
import '../widgets/memo_content.dart';
import '../widgets/score_table.dart';

/// 세션 상세 시트(읽기 전용). 세션 요약 카드 아래에 누른 메모를 먼저 보여주고, 같은 세션의 다른
/// 메모는 접어 둔다. [memoId]를 넘기지 않으면 모든 메모를 쓴 순서대로 펼쳐 보여준다.
/// 펼치기 말고는 눌러도 아무 동작이 없다.
///
/// 내비게이션 바까지 덮도록 루트 내비게이터에 띄운다.
Future<void> showSessionDetailSheet(
  BuildContext context, {
  required int sessionId,
  int? memoId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) =>
        _SessionDetailSheet(sessionId: sessionId, memoId: memoId),
  );
}

class _SessionDetailSheet extends ConsumerWidget {
  const _SessionDetailSheet({required this.sessionId, this.memoId});

  final int sessionId;
  final int? memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(sessionDetailProvider(sessionId));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        final value = detail.value;
        if (value == null) {
          // 로딩 중이거나 그사이 일지가 지워졌다.
          return Center(
            child: detail.isLoading
                ? const CircularProgressIndicator()
                : const Text('일지를 찾을 수 없어요.'),
          );
        }

        // useSafeArea는 위·좌·우만 피한다. 아래는 Android 내비게이션 바에
        // 가리지 않게 직접 띄운다.
        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          child: _DetailBody(detail: value, memoId: memoId),
        );
      },
    );
  }
}

/// 시트의 내용. 제목(날짜·시간·유형·장소) → 세션 요약(문장, 스코어) → 메모 순이고
/// 사이를 구분선으로 나눈다.
class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail, this.memoId});

  final SessionDetail detail;

  /// 누른 메모. null이거나 그사이 지워졌으면 모든 메모를 펼쳐 보여준다.
  final int? memoId;

  @override
  Widget build(BuildContext context) {
    final session = detail.session;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TitleHeader(session: session),
        const _SectionDivider(),
        // 세션 요약은 제목·메모보다 조금 안쪽으로 들인다.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SessionSentences(detail: detail),
              if (session.sessionType == SessionType.game) ...[
                const SizedBox(height: 16),
                if (detail.games.isEmpty)
                  Text(
                    '스코어는 기록하지 않았어요.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                else
                  FormSection(
                    label: '스코어',
                    child: ScoreTable(games: detail.games),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        _MemoList(memos: detail.memos, memoId: memoId),
      ],
    );
  }
}

/// 시트 맨 위의 제목. 가운데 정렬로 `[게임] 2026년 10월 10일 토요일` 줄과 그 아래
/// `20:00 – 22:30 · 2시간 30분 소요` 줄과 `📍 고척 · 야외 하드` 줄을 둔다.
/// 표시 전용이다.
class _TitleHeader extends StatelessWidget {
  const _TitleHeader({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final start = session.startMinutes;
    final end = session.endMinutes;
    final place = _placeLine(session);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    final time = start != null && end != null
        ? '${Formatters.minutesOfDay(start)} – '
              '${Formatters.minutesOfDay(end)}'
              '${end > start ? ' · ${Formatters.duration(end - start)} 소요' : ''}'
        : null;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 칩 모양이지만 표지일 뿐이라 누를 수 없다.
            DecoratedBox(
              decoration: ShapeDecoration(
                color: scheme.secondaryContainer,
                shape: const StadiumBorder(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                child: Text(
                  session.sessionType.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                Formatters.koreanDate(session.date),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        if (time != null) ...[
          const SizedBox(height: 6),
          Text(
            time,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (place != null) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.place_outlined,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 2),
              Flexible(child: Text(place, style: muted)),
            ],
          ),
        ],
      ],
    );
  }
}

/// `고척 · 야외 하드`. 값이 하나도 없으면 null이다.
String? _placeLine(Session session) {
  final court = [
    if (session.isIndoorSnapshot case final indoor?) indoor ? '실내' : '야외',
    ?session.surfaceSnapshot?.label,
  ].join(' ');
  final parts = [?session.placeNameSnapshot, if (court.isNotEmpty) court];
  return parts.isEmpty ? null : parts.join(' · ');
}

/// 컨디션·마지막 식사 문장과 큐 문장(레슨이 아닐 때만).
class _SessionSentences extends StatelessWidget {
  const _SessionSentences({required this.detail});

  final SessionDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = detail.session;
    final cueText = detail.cueText;
    final condition = conditionSentence(
      conditionScore: session.conditionScore,
      lastMeal: session.lastMealBucket,
    );
    final cueResult = cueText == null
        ? null
        : cueResultSentence(session.sessionType, session.cueApplied);
    final style = theme.textTheme.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (condition == null)
          const _MutedText('컨디션과 마지막 식사 기록이 없어요')
        else
          Text.rich(condition, style: style),
        if (session.sessionType != SessionType.lesson)
          if (cueText == null)
            Text('의식적으로 적용한 큐는 없었어요.', style: style)
          else
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: cueText, style: _bold),
                  const TextSpan(text: ' 큐를 적용하려고 했어요.'),
                  if (cueResult != null) TextSpan(text: '\n$cueResult'),
                ],
              ),
              style: style,
            ),
      ],
    );
  }
}

/// `컨디션은 **쏘쏘**, 마지막 식사는 **2–3시간 전**이었어요.` 값만 굵게 쓴다.
/// 둘 다 없으면 null이다.
@visibleForTesting
TextSpan? conditionSentence({int? conditionScore, LastMealBucket? lastMeal}) {
  final condition = conditionScore == null
      ? null
      : conditionLabel(conditionScore);
  final meal = switch (lastMeal) {
    null => null,
    LastMealBucket.within1h => '1시간 이내',
    LastMealBucket.h1to2 => '1–2시간 전',
    LastMealBucket.h2to3 => '2–3시간 전',
    LastMealBucket.over3 => '3시간 이상 전',
  };
  TextSpan bold(String text) => TextSpan(text: text, style: _bold);

  return switch ((condition, meal)) {
    (null, null) => null,
    (final c?, null) => TextSpan(
      children: [
        const TextSpan(text: '컨디션은 '),
        bold(c),
        _wasSpan(c),
      ],
    ),
    (null, final m?) => TextSpan(
      children: [
        const TextSpan(text: '마지막 식사는 '),
        bold(m),
        _wasSpan(m),
      ],
    ),
    (final c?, final m?) => TextSpan(
      children: [
        const TextSpan(text: '컨디션은 '),
        bold(c),
        const TextSpan(text: ', 마지막 식사는 '),
        bold(m),
        _wasSpan(m),
      ],
    ),
  };
}

const _bold = TextStyle(fontWeight: FontWeight.w700);

/// 큐 문장의 둘째 줄. `게임 중에 큐를 의식해서 적용했어요.` 적용 결과가 없으면
/// null이다. 랠리·연습 세션은 `랠리 중에`로 쓴다.
@visibleForTesting
String? cueResultSentence(SessionType sessionType, CueApplied? applied) {
  final during = sessionType == SessionType.game ? '게임 중에' : '랠리 중에';
  return switch (applied) {
    null => null,
    CueApplied.yes => '$during 큐를 의식해서 적용했어요.',
    CueApplied.partial => '$during 큐를 어느 정도 적용했어요.',
    CueApplied.no => '$during 큐를 떠올리기 어려웠어요.',
  };
}

/// [word] 뒤에 붙는 `이었어요.`(받침 있음) 또는 `였어요.`(받침 없음).
TextSpan _wasSpan(String word) {
  final last = word.codeUnitAt(word.length - 1);
  final isHangul = last >= 0xAC00 && last <= 0xD7A3;
  final hasFinal = isHangul && (last - 0xAC00) % 28 != 0;
  return TextSpan(text: hasFinal ? '이었어요.' : '였어요.');
}

/// 누른 메모를 맨 위에 두고, 같은 세션의 다른 메모는 펼치기 전까지 숨긴다. 누른 메모가
/// 없으면 모든 메모를 쓴 순서대로 보여준다.
class _MemoList extends StatefulWidget {
  const _MemoList({required this.memos, this.memoId});

  final List<SessionDetailMemo> memos;
  final int? memoId;

  @override
  State<_MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<_MemoList> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tapped = widget.memos.where((memo) => memo.id == widget.memoId);
    final others = [
      for (final memo in widget.memos)
        if (memo.id != widget.memoId) memo,
    ];
    // 누른 메모가 없거나 그사이 지워졌으면 접을 기준이 없으니 모두 보여준다.
    final showOthers = tapped.isEmpty || _expanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        if (widget.memoId == null)
          Padding(
            // 세션 요약의 스코어 라벨과 왼쪽을 맞춘다.
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              '메모 ${widget.memos.length}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 0.1,
              ),
            ),
          ),
        for (final memo in tapped)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '선택한 메모',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _MemoItem(memo: memo),
            ],
          ),
        if (tapped.isNotEmpty && others.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              label: Text(
                _expanded ? '다른 메모 접기' : '같은 세션 다른 메모 ${others.length}개 펼쳐보기',
              ),
            ),
          ),
        if (showOthers)
          for (final memo in others) _MemoItem(memo: memo),
      ],
    );
  }
}

/// 메모 한 건. 본문은 조회 결과 카드와 같은 [MemoContent]이고, 시트 면 위에서
/// 구분되도록 흰 면에 담는다.
class _MemoItem extends StatelessWidget {
  const _MemoItem({required this.memo});

  final SessionDetailMemo memo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: MemoContent(
        content: memo.content,
        tagNames: memo.tagNames,
        evaluation: memo.evaluation,
      ),
    );
  }
}

/// 제목과 세션 요약 사이의 구분선.
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(height: 1),
    );
  }
}

class _MutedText extends StatelessWidget {
  const _MutedText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
