import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/db/app_database.dart';
import '../../../../data/db/enums.dart';
import '../../../core/labels.dart';
import '../../../core/widgets/app_choice_chips.dart';
import '../../../core/widgets/app_segmented_button.dart';
import '../journal_entry_notifier.dart';

/// 장소 등록 하단 시트. 등록하면 만든 장소를 돌려주고, 그 장소가 바로 선택된다.
///
/// [entryArg]는 작성 화면 notifier의 family 키(= 페이지에 들어올 때의 sessionId)다.
Future<Place?> showPlaceCreateSheet(
  BuildContext context, {
  required int? entryArg,
  String initialName = '',
}) {
  return showModalBottomSheet<Place>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _PlaceCreateSheet(entryArg: entryArg, initialName: initialName),
  );
}

class _PlaceCreateSheet extends ConsumerStatefulWidget {
  const _PlaceCreateSheet({required this.entryArg, required this.initialName});

  final int? entryArg;

  /// 더보기 시트에서 검색하던 말. 이름 칸을 채운 채로 연다.
  final String initialName;

  @override
  ConsumerState<_PlaceCreateSheet> createState() => _PlaceCreateSheetState();
}

class _PlaceCreateSheetState extends ConsumerState<_PlaceCreateSheet> {
  late final _name = TextEditingController(text: widget.initialName);
  SurfaceType _surface = SurfaceType.hard;
  bool _isIndoor = false;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = '장소 이름을 입력해 주세요.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final place = await ref
          .read(journalEntryProvider(widget.entryArg).notifier)
          .createPlace(name: name, surface: _surface, isIndoor: _isIndoor);
      if (mounted) Navigator.of(context).pop(place);
    } catch (_) {
      // places.name은 유일 제약이다. 같은 이름이면 여기로 온다.
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = '같은 이름의 장소가 이미 있어요. 이름을 바꿔 주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        // 키보드가 올라와도 입력칸과 저장 버튼이 가려지지 않게 한다.
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('장소 등록', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '장소 하나가 코트 하나예요. 같은 시설의 실내·야외는 따로 등록해 주세요.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: '이름',
                hintText: '예: 귀뚜라미 실내',
                errorText: _error,
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            Text('코트 표면', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            AppChoiceChips<SurfaceType>(
              chips: [
                for (final surface in SurfaceType.values)
                  AppChip(surface, surface.label),
              ],
              value: _surface,
              // 표면은 비울 수 없다(테이블에서 필수값).
              onChanged: (value) =>
                  setState(() => _surface = value ?? _surface),
            ),
            const SizedBox(height: 12),
            AppSegmentedButton<bool>(
              segments: const [AppSegment(false, '야외'), AppSegment(true, '실내')],
              value: _isIndoor,
              allowEmpty: false,
              onChanged: (value) => setState(() => _isIndoor = value ?? false),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
