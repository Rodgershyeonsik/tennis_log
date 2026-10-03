import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/enums.dart';
import 'package:tennis_log/features/journal/data/tag_repository.dart';

void main() {
  late AppDatabase db;
  late TagRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = TagRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('loadDictionary', () {
    test('시드된 태그 전체를 표현·제외 단어와 함께 돌려준다', () async {
      final dictionary = await repo.loadDictionary();
      expect(dictionary.entries, hasLength(58));
    });

    test('표현의 confidence가 함께 들어온다', () async {
      final dictionary = await repo.loadDictionary();
      final forehand = dictionary.entries.firstWhere((e) => e.name == '포핸드');

      final byAlias = {for (final a in forehand.aliases) a.alias: a.confidence};
      expect(byAlias['포핸드'], AliasConfidence.sure);
      expect(byAlias['포로'], AliasConfidence.ambiguous);
    });

    test('제외 단어가 함께 들어온다', () async {
      final dictionary = await repo.loadDictionary();
      final serve = dictionary.entries.firstWhere((e) => e.name == '서브');

      expect(serve.exclusions, containsAll(['서브 리턴', '서브 리시브']));
    });

    test('제외 단어가 없는 태그는 빈 목록이다', () async {
      final dictionary = await repo.loadDictionary();
      final poaching = dictionary.entries.firstWhere((e) => e.name == '포칭');

      expect(poaching.exclusions, isEmpty);
    });

    test('부모 태그 id가 들어온다', () async {
      final dictionary = await repo.loadDictionary();
      final volley = dictionary.entries.firstWhere((e) => e.name == '발리');
      final backVolley = dictionary.entries.firstWhere((e) => e.name == '백발리');

      expect(backVolley.parentTagId, volley.tagId);
      expect(volley.parentTagId, isNull);
    });

    test('보관 처리된 태그는 제외한다', () async {
      // 자동으로 더 붙이고 싶지 않은 태그라 엔진에 넘기지 않는다.
      await (db.update(db.tags)..where((t) => t.name.equals('포칭'))).write(
        const TagsCompanion(isArchived: Value(true)),
      );

      final dictionary = await repo.loadDictionary();
      expect(dictionary.entries, hasLength(57));
      expect(dictionary.entries.map((e) => e.name), isNot(contains('포칭')));
    });
  });

  group('search (자동완성)', () {
    test('부분 일치로 찾는다', () async {
      final results = await repo.search('발리');
      expect(results.map((t) => t.name), containsAll(['발리', '포발리', '백발리']));
    });

    test('이름 순으로 정렬한다', () async {
      final results = await repo.search('발리');
      final names = results.map((t) => t.name).toList();
      expect(names, orderedEquals([...names]..sort()));
    });

    test('검색어가 비어 있으면 전체에서 limit만큼 돌려준다', () async {
      expect(await repo.search('  ', limit: 5), hasLength(5));
    });

    test('일치하는 태그가 없으면 빈 목록이다 (새 태그 만들기로 간다)', () async {
      expect(await repo.search('존재하지않는태그이름'), isEmpty);
    });

    test('보관 처리된 태그는 제외한다', () async {
      await (db.update(db.tags)..where((t) => t.name.equals('포칭'))).write(
        const TagsCompanion(isArchived: Value(true)),
      );

      expect(await repo.search('포칭'), isEmpty);
    });
  });

  group('findOrCreate', () {
    test('새 이름이면 만든다', () async {
      final tag = await repo.findOrCreate(
        name: '드롭샷',
        category: TagCategory.technique,
      );

      expect(tag.name, '드롭샷');
      expect(tag.category, TagCategory.technique);
      expect(await repo.findByName('드롭샷'), isNotNull);
    });

    test('앞뒤 공백을 제거한다', () async {
      final tag = await repo.findOrCreate(
        name: '  드롭샷  ',
        category: TagCategory.technique,
      );

      expect(tag.name, '드롭샷');
    });

    test('이미 있는 이름이면 그 태그를 돌려주고 새로 만들지 않는다', () async {
      final before = (await db.select(db.tags).get()).length;

      final tag = await repo.findOrCreate(
        name: '포칭',
        category: TagCategory.form, // 다른 카테고리로 넣어도
      );

      expect(tag.category, TagCategory.situation); // 기존 값이 유지된다
      expect((await db.select(db.tags).get()).length, before);
    });
  });
}
