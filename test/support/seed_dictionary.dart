import 'package:tennis_log/core/db/enums.dart';
import 'package:tennis_log/core/db/seed/tag_seed_data.dart';
import 'package:tennis_log/features/journal/domain/tag_dictionary.dart';

/// 시드 상수(`tagSeeds`)를 DB 없이 [TagDictionary]로 바꾼 것.
///
/// 자동 태그 엔진 테스트를 실제 사전으로 돌리면서도 DB를 띄우지 않기 위한
/// 헬퍼다. id는 시드 목록의 순서대로 1부터 붙이고, 부모는 이름으로 연결한다
/// (`TagRepository.loadDictionary()`가 DB에서 하는 일과 같다).
///
/// 태그 이름으로 결과를 확인할 수 있게 id ↔ 이름 표도 함께 들고 있다.
class SeedDictionary {
  SeedDictionary._(this.dictionary, this._nameById, this._idByName);

  factory SeedDictionary.load() {
    final idByName = <String, int>{};
    for (var i = 0; i < tagSeeds.length; i++) {
      idByName[tagSeeds[i].name] = i + 1;
    }

    final entries = [
      for (final seed in tagSeeds)
        TagDictionaryEntry(
          tagId: idByName[seed.name]!,
          name: seed.name,
          category: seed.category,
          parentTagId: seed.parentName == null
              ? null
              : idByName[seed.parentName]!,
          aliases: [
            for (final alias in seed.sure)
              TagAlias(alias: alias, confidence: AliasConfidence.sure),
            for (final alias in seed.ambiguous)
              TagAlias(alias: alias, confidence: AliasConfidence.ambiguous),
          ],
          exclusions: seed.exclusions,
        ),
    ];

    return SeedDictionary._(TagDictionary(entries: entries), {
      for (final entry in entries) entry.tagId: entry.name,
    }, idByName);
  }

  final TagDictionary dictionary;
  final Map<int, String> _nameById;
  final Map<String, int> _idByName;

  String nameOf(int tagId) => _nameById[tagId] ?? '(없는 태그 $tagId)';

  int idOf(String name) {
    final id = _idByName[name];
    if (id == null) throw ArgumentError('시드에 없는 태그 이름: $name');
    return id;
  }
}
