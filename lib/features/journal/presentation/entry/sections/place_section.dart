import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/db/app_database.dart';
import '../../labels.dart';
import '../../widgets/form_section.dart';
import '../entry_providers.dart';
import '../journal_entry_notifier.dart';
import '../journal_entry_state.dart';
import '../sheets/place_create_sheet.dart';
import '../sheets/place_picker_sheet.dart';

/// 장소. 최근 사용 순 칩 4개 + **+** 칩(명세 3번).
class PlaceSection extends ConsumerWidget {
  const PlaceSection({
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
    final notifier = ref.read(journalEntryProvider(entryArg).notifier);
    final recent = ref.watch(recentPlacesProvider).value ?? const [];
    final selectedId = state.draft.placeId;
    final selected = ref.watch(selectedPlaceProvider(selectedId)).value;

    // 고른 장소가 최근 4개 안에 없을 수 있다(오래 전에 쓴 장소를 이어쓰는 경우).
    // 그럴 때도 선택된 칩은 보여야 한다.
    final chips = <Place>[
      ...recent,
      if (selected != null && !recent.any((p) => p.id == selected.id)) selected,
    ];

    return FormSection(
      label: '장소',
      error: state.placeErrorText,
      // 메모 추가 버튼과 같은 모양·자리.
      trailing: IconButton.filled(
        onPressed: () async {
          onBeforeSheet();
          await showPlaceCreateSheet(context, entryArg: entryArg);
        },
        icon: const Icon(Icons.add),
        tooltip: '장소 추가',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final place in chips)
                ChoiceChip(
                  label: Text(place.name),
                  selected: place.id == selectedId,
                  onSelected: (_) => notifier.setPlace(place.id),
                ),
              ActionChip(
                avatar: const Icon(Icons.search, size: 18),
                label: const Text('더보기'),
                onPressed: () async {
                  onBeforeSheet();
                  final picked = await showPlacePickerSheet(
                    context,
                    entryArg: entryArg,
                  );
                  if (picked != null) notifier.setPlace(picked.id);
                },
              ),
            ],
          ),
          if (selected != null) ...[
            const SizedBox(height: 8),
            Text(
              placeDetailLabel(
                isIndoor: selected.isIndoor,
                surface: selected.surface,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
