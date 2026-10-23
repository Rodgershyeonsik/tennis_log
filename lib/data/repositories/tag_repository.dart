import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../db/enums.dart';
import '../../domain/tagging/tag_dictionary.dart';

part 'tag_repository.g.dart';

/// 태그 사전 읽기·쓰기. 메모-태그 연결은 [MemoRepository]가 담당한다.
class TagRepository {
  TagRepository(this._db);

  final AppDatabase _db;

  /// 자동 태그 엔진(3단계)에 넘길 사전 전체.
  ///
  /// 태그 58개 + 표현 180여 개 규모라 한 번에 읽어서 메모리에 올린다.
  /// 보관 처리된(isArchived) 태그는 더 이상 자동으로 붙이지 않으므로 제외한다.
  Future<TagDictionary> loadDictionary() async {
    final tags = await (_db.select(
      _db.tags,
    )..where((t) => t.isArchived.equals(false))).get();

    final aliases = await _db.select(_db.tagAliases).get();
    final exclusions = await _db.select(_db.tagExclusions).get();

    final aliasesByTag = <int, List<TagAlias>>{};
    for (final row in aliases) {
      aliasesByTag
          .putIfAbsent(row.tagId, () => [])
          .add(TagAlias(alias: row.alias, confidence: row.confidence));
    }

    final exclusionsByTag = <int, List<String>>{};
    for (final row in exclusions) {
      exclusionsByTag.putIfAbsent(row.tagId, () => []).add(row.word);
    }

    return TagDictionary(
      entries: [
        for (final tag in tags)
          TagDictionaryEntry(
            tagId: tag.id,
            name: tag.name,
            category: tag.category,
            parentTagId: tag.parentTagId,
            aliases: aliasesByTag[tag.id] ?? const [],
            exclusions: exclusionsByTag[tag.id] ?? const [],
          ),
      ],
    );
  }

  /// 태그 추가 시트의 자동완성. 부분 일치, 이름 순.
  Future<List<Tag>> search(String query, {int limit = 20}) {
    final trimmed = query.trim();
    final select = _db.select(_db.tags)
      ..where((t) => t.isArchived.equals(false));

    if (trimmed.isNotEmpty) {
      select.where((t) => t.name.like('%$trimmed%'));
    }

    select
      ..orderBy([(t) => OrderingTerm.asc(t.name)])
      ..limit(limit);
    return select.get();
  }

  Future<Tag?> findByName(String name) {
    return (_db.select(_db.tags)
          ..where((t) => t.name.equals(name.trim()))
          ..limit(1))
        .getSingleOrNull();
  }

  /// "'입력값' 새 태그 만들기". 이름이 유일해야 하므로, 같은 이름이 이미 있으면
  /// 새로 만들지 않고 그 태그를 돌려준다.
  Future<Tag> findOrCreate({
    required String name,
    required TagCategory category,
  }) async {
    final trimmed = name.trim();
    final existing = await findByName(trimmed);
    if (existing != null) return existing;

    return _db
        .into(_db.tags)
        .insertReturning(
          TagsCompanion.insert(name: trimmed, category: category),
        );
  }
}

@riverpod
TagRepository tagRepository(Ref ref) {
  return TagRepository(ref.watch(appDatabaseProvider));
}
