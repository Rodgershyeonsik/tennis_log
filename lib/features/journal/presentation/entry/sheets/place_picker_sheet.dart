import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/db/app_database.dart';
import '../../labels.dart';
import '../entry_providers.dart';
import 'place_create_sheet.dart';

/// 장소 더보기 시트. 고른 장소를 돌려준다(그냥 닫으면 null).
///
/// 목록은 이름 오름차순이고, 검색어가 있으면 이름에 그 말이 들어간 장소만 남는다.
/// **정확히 같은 이름이 없으면 목록 끝에 "'<검색어>' 새 장소로 추가"** 가 붙어서,
/// 찾다가 없으면 그 자리에서 바로 등록으로 넘어갈 수 있다.
Future<Place?> showPlacePickerSheet(
  BuildContext context, {
  required int? entryArg,
}) {
  return showModalBottomSheet<Place>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PlacePickerSheet(entryArg: entryArg),
  );
}

class _PlacePickerSheet extends ConsumerStatefulWidget {
  const _PlacePickerSheet({required this.entryArg});

  final int? entryArg;

  @override
  ConsumerState<_PlacePickerSheet> createState() => _PlacePickerSheetState();
}

class _PlacePickerSheetState extends ConsumerState<_PlacePickerSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// 등록 시트로 넘어간다. 검색어가 있으면 이름 칸을 채워서 연다.
  Future<void> _create() async {
    final created = await showPlaceCreateSheet(
      context,
      entryArg: widget.entryArg,
      initialName: _query.trim(),
    );
    if (created != null && mounted) Navigator.of(context).pop(created);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final places = ref.watch(placeSearchProvider(_query)).value ?? const [];
    final query = _query.trim();
    // 이미 같은 이름이 있으면 "새 장소로 추가"를 보여줄 이유가 없다.
    final showCreate =
        query.isEmpty || !places.any((place) => place.name == query);

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
                  Text('장소 선택', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _search,
                    decoration: const InputDecoration(
                      hintText: '장소 검색',
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final place in places)
                    ListTile(
                      title: Text(place.name),
                      subtitle: Text(
                        placeDetailLabel(
                          isIndoor: place.isIndoor,
                          surface: place.surface,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(place),
                    ),
                  if (showCreate) ...[
                    if (places.isNotEmpty) const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: Text(
                        query.isEmpty ? '새 장소 추가' : "'$query' 새 장소로 추가",
                      ),
                      onTap: _create,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
