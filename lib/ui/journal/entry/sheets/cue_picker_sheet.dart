import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/db/enums.dart';
import '../../../core/formatters.dart';
import '../../../../domain/models/cue_summary.dart';
import '../../../core/labels.dart';
import '../entry_providers.dart';

/// "지난 큐 불러오기" 시트. 고른 큐의 텍스트를 돌려준다.
Future<String?> showCuePickerSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _CuePickerSheet(),
  );
}

class _CuePickerSheet extends ConsumerStatefulWidget {
  const _CuePickerSheet();

  @override
  ConsumerState<_CuePickerSheet> createState() => _CuePickerSheetState();
}

class _CuePickerSheetState extends ConsumerState<_CuePickerSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cues = ref.watch(cueSummariesProvider(_query));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('지난 큐', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _search,
                    decoration: const InputDecoration(
                      hintText: '큐 검색',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 남는 높이만큼만 쓴다. 고정 비율로 잡으면 키보드가 올라왔을 때
            // 시트가 화면을 넘쳐서 bottom overflow가 난다.
            Flexible(
              child: switch (cues) {
                AsyncData(:final value) when value.isEmpty => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('아직 큐가 없어요.'),
                ),
                AsyncData(:final value) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (context, index) =>
                      _CueTile(summary: value[index]),
                ),
                AsyncError() => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('큐를 불러오지 못했어요.'),
                ),
                _ => const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _CueTile extends StatelessWidget {
  const _CueTile({required this.summary});

  final CueSummary summary;

  @override
  Widget build(BuildContext context) {
    final date = summary.lastUsedDate;
    return ListTile(
      title: Text(summary.text),
      subtitle: Text(
        [
          if (date != null) Formatters.dateWithWeekday(date),
          '${summary.useCount}회',
        ].join(' · '),
      ),
      // 적용 결과 기록이 없으면 배지를 보여주지 않는다(명세 3번).
      trailing: summary.latestApplied == null
          ? null
          : _AppliedBadge(applied: summary.latestApplied!),
      onTap: () => Navigator.of(context).pop(summary.text),
    );
  }
}

/// 최근 큐 적용 결과 배지. 됨/일부/안 됨을 색으로 구분한다.
class _AppliedBadge extends StatelessWidget {
  const _AppliedBadge({required this.applied});

  final CueApplied applied;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (applied) {
      CueApplied.yes => Colors.green,
      CueApplied.partial => Colors.orange,
      CueApplied.no => scheme.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        applied.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
