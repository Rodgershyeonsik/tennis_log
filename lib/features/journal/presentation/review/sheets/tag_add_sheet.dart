import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/db/enums.dart';
import '../../../data/memo_repository.dart';
import '../../../data/tag_repository.dart';
import '../../labels.dart';
import '../../widgets/app_choice_chips.dart';
import '../review_providers.dart';

/// `＋ 태그 추가` 칩의 시트(명세 5번).
///
/// 검색 입력에 입력할수록 자동완성 목록이 바뀐다. 고르면 manual/confirmed로
/// 붙고 시트가 닫힌다. **일치하는 태그가 없으면** 목록 끝의 "'입력값' 새 태그
/// 만들기"로 카테고리를 고르고 바로 만들어 붙인다.
///
/// 쓰기는 시트가 직접 한다 — 이 화면의 모든 변경은 즉시 DB에 반영되므로
/// 돌려줄 결과가 없다.
Future<void> showTagAddSheet(BuildContext context, {required int memoId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _TagAddSheet(memoId: memoId),
  );
}

class _TagAddSheet extends ConsumerStatefulWidget {
  const _TagAddSheet({required this.memoId});

  final int memoId;

  @override
  ConsumerState<_TagAddSheet> createState() => _TagAddSheetState();
}

class _TagAddSheetState extends ConsumerState<_TagAddSheet> {
  final _search = TextEditingController();
  String _query = '';

  /// 새 태그 만들기로 넘어갔을 때의 이름. null이면 검색 단계다.
  String? _creatingName;
  TagCategory _category = TagCategory.technique;
  bool _saving = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// 목록에서 기존 태그를 골랐을 때. manual/confirmed로 붙는다.
  Future<void> _add(int tagId) async {
    await ref.read(memoRepositoryProvider).addManualTag(widget.memoId, tagId);
    if (mounted) Navigator.of(context).pop();
  }

  /// "'입력값' 새 태그 만들기". 태그를 만든 뒤 그 태그를 메모에 붙인다.
  ///
  /// 같은 이름의 태그가 이미 있으면 [TagRepository.findOrCreate]가 그 태그를
  /// 돌려주므로, 목록에서 고른 것과 같은 결과가 된다.
  Future<void> _create() async {
    setState(() => _saving = true);
    final tag = await ref
        .read(tagRepositoryProvider)
        .findOrCreate(name: _creatingName!, category: _category);
    if (!mounted) return;
    await ref.read(memoRepositoryProvider).addManualTag(widget.memoId, tag.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: _creatingName == null ? _buildSearch() : _buildCreate(),
      ),
    );
  }

  Widget _buildSearch() {
    final theme = Theme.of(context);
    final tags = ref.watch(tagSearchProvider(_query)).value ?? const [];
    final query = _query.trim();
    // 이미 같은 이름의 태그가 있으면 "새 태그 만들기"를 보여줄 이유가 없다.
    final showCreate =
        query.isNotEmpty && !tags.any((tag) => tag.name == query);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('태그 추가', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _search,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '태그 검색',
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
              for (final tag in tags)
                ListTile(
                  title: Text(tag.name),
                  subtitle: Text(tag.category.label),
                  onTap: () => _add(tag.id),
                ),
              if (showCreate) ...[
                if (tags.isNotEmpty) const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: Text("'$query' 새 태그 만들기"),
                  onTap: () => setState(() => _creatingName = query),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCreate() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("새 태그 '$_creatingName'", style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(
            '분류',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          AppChoiceChips<TagCategory>(
            chips: [
              for (final category in TagCategory.values)
                AppChip(category, category.label),
            ],
            value: _category,
            // 분류는 비울 수 없다. 같은 칩을 다시 눌러도 그대로 둔다.
            onChanged: (value) =>
                setState(() => _category = value ?? _category),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _create,
            child: const Text('만들어 붙이기'),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => setState(() => _creatingName = null),
            child: const Text('뒤로'),
          ),
        ],
      ),
    );
  }
}
