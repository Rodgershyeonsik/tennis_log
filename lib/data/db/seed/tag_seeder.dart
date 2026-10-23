import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';
import 'tag_seed_data.dart';

/// [tagSeeds]를 DB에 넣는다. 앱 첫 실행 시 한 번만 실행된다.
///
/// `tags`가 비어 있을 때만 동작하므로 여러 번 불러도 안전하고, 전체가 하나의
/// 트랜잭션이라 중간에 실패하면 아무것도 남지 않는다(=다음 실행에서 다시 시도한다).
///
/// 사전에 항목을 **추가**하려면 이 함수로는 안 된다. 이미 태그가 있는 DB는
/// 건너뛰기 때문에 마이그레이션에서 따로 넣어야 한다.
Future<void> seedTagDictionary(AppDatabase db) async {
  final tagCount = db.tags.id.count();
  final existing = await (db.selectOnly(
    db.tags,
  )..addColumns([tagCount])).map((row) => row.read(tagCount)!).getSingle();
  if (existing > 0) return;

  await db.transaction(() async {
    // 1차: 태그를 먼저 전부 넣고 이름 → id 표를 만든다.
    // 부모를 바로 연결하지 않는 이유는 시드 목록에서 부모가 자식보다
    // 뒤에 올 수도 있기 때문이다.
    final idByName = <String, int>{};
    for (final seed in tagSeeds) {
      idByName[seed.name] = await db
          .into(db.tags)
          .insert(
            TagsCompanion.insert(name: seed.name, category: seed.category),
          );
    }

    // 2차: 부모 태그를 이름으로 찾아 연결한다.
    for (final seed in tagSeeds) {
      final parentName = seed.parentName;
      if (parentName == null) continue;

      final parentId = idByName[parentName];
      assert(
        parentId != null,
        '태그 "${seed.name}"의 부모 "$parentName"이 시드 목록에 없다.',
      );
      if (parentId == null) continue;

      await (db.update(db.tags)
            ..where((t) => t.id.equals(idByName[seed.name]!)))
          .write(TagsCompanion(parentTagId: Value(parentId)));
    }

    // 3차: 인식 표현과 제외 단어. 건수가 많아 batch로 한 번에 보낸다.
    await db.batch((batch) {
      for (final seed in tagSeeds) {
        final tagId = idByName[seed.name]!;

        void addAliases(List<String> aliases, AliasConfidence confidence) {
          batch.insertAll(db.tagAliases, [
            for (final alias in aliases)
              TagAliasesCompanion.insert(
                tagId: tagId,
                alias: alias,
                confidence: confidence,
              ),
          ], mode: InsertMode.insertOrIgnore);
        }

        addAliases(seed.sure, AliasConfidence.sure);
        addAliases(seed.ambiguous, AliasConfidence.ambiguous);

        batch.insertAll(db.tagExclusions, [
          for (final word in seed.exclusions)
            TagExclusionsCompanion.insert(tagId: tagId, word: word),
        ], mode: InsertMode.insertOrIgnore);
      }
    });
  });
}
