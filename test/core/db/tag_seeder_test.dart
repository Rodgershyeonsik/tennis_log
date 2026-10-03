// drift도 isNull을 내보내서 matcher의 isNull과 겹친다.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/enums.dart';
import 'package:tennis_log/core/db/seed/tag_seed_data.dart';
import 'package:tennis_log/core/db/seed/tag_seeder.dart';

/// 시드는 앱 첫 실행 때 한 번만 도는데다 태그 엔진의 정확도가 전부 여기에
/// 달려 있어서, 명세 7번과 어긋나면 뒤늦게 발견된다. 그래서 명세의 까다로운
/// 항목들을 직접 확인한다.
void main() {
  late AppDatabase db;

  setUp(() async {
    // AppDatabase를 직접 열면 beforeOpen에서 시드가 자동으로 돈다.
    db = AppDatabase(NativeDatabase.memory());
    // 첫 쿼리를 날려서 beforeOpen이 실행되게 한다.
    await db.select(db.tags).get();
  });

  tearDown(() async {
    await db.close();
  });

  /// 태그 이름으로 인식 표현을 confidence와 함께 읽어온다.
  Future<Map<String, AliasConfidence>> aliasesOf(String tagName) async {
    final query = db.select(db.tagAliases).join([
      innerJoin(db.tags, db.tags.id.equalsExp(db.tagAliases.tagId)),
    ])..where(db.tags.name.equals(tagName));

    final rows = await query.get();
    return {
      for (final row in rows)
        row.readTable(db.tagAliases).alias: row
            .readTable(db.tagAliases)
            .confidence,
    };
  }

  Future<List<String>> exclusionsOf(String tagName) async {
    final query = db.select(db.tagExclusions).join([
      innerJoin(db.tags, db.tags.id.equalsExp(db.tagExclusions.tagId)),
    ])..where(db.tags.name.equals(tagName));

    final rows = await query.get();
    return rows.map((r) => r.readTable(db.tagExclusions).word).toList();
  }

  test('앱을 처음 열면 태그 사전이 들어가 있다', () async {
    final tags = await db.select(db.tags).get();
    expect(tags, hasLength(tagSeeds.length));
    expect(tags, hasLength(58));
  });

  test('카테고리별 태그 수가 명세와 같다', () async {
    final tags = await db.select(db.tags).get();
    final countByCategory = <TagCategory, int>{};
    for (final tag in tags) {
      countByCategory.update(tag.category, (v) => v + 1, ifAbsent: () => 1);
    }

    expect(countByCategory, {
      TagCategory.technique: 15,
      TagCategory.form: 14,
      TagCategory.footwork: 3,
      TagCategory.situation: 10,
      TagCategory.body: 7,
      TagCategory.conditionFactor: 9,
    });
  });

  test('시드 목록에 중복된 태그 이름이 없다', () {
    final names = tagSeeds.map((s) => s.name).toList();
    expect(names.toSet(), hasLength(names.length));
  });

  test('모든 태그에 인식 표현이 최소 하나 있다', () {
    for (final seed in tagSeeds) {
      expect(
        seed.sure.length + seed.ambiguous.length,
        greaterThan(0),
        reason: '태그 "${seed.name}"에 인식 표현이 없다.',
      );
    }
  });

  test('부모 태그가 이름이 아니라 id로 연결된다', () async {
    final tags = await db.select(db.tags).get();
    final byName = {for (final t in tags) t.name: t};

    // 발리 계열
    expect(byName['포발리']!.parentTagId, byName['발리']!.id);
    expect(byName['백발리']!.parentTagId, byName['발리']!.id);
    // 구질 계열
    for (final child in ['탑스핀', '플랫', '슬라이스', '킥']) {
      expect(
        byName[child]!.parentTagId,
        byName['구질']!.id,
        reason: '$child의 부모가 구질이어야 한다.',
      );
    }
    // 유닛턴 계열
    for (final child in ['왼팔사용', '상체프레임', '몸열림']) {
      expect(
        byName[child]!.parentTagId,
        byName['유닛턴']!.id,
        reason: '$child의 부모가 유닛턴이어야 한다.',
      );
    }
    // 부모가 없는 태그는 null이어야 한다.
    for (final root in ['발리', '구질', '유닛턴', '서브']) {
      expect(byName[root]!.parentTagId, isNull);
    }
  });

  test('부모로 지정한 이름이 모두 시드 목록에 있다', () {
    final names = tagSeeds.map((s) => s.name).toSet();
    for (final seed in tagSeeds) {
      final parent = seed.parentName;
      if (parent == null) continue;
      expect(
        names,
        contains(parent),
        reason: '"${seed.name}"의 부모 "$parent"가 없다.',
      );
    }
  });

  group('명세 7번의 confidence 표기', () {
    test('포핸드: * 붙은 표현만 ambiguous다', () async {
      expect(await aliasesOf('포핸드'), {
        '포핸드': AliasConfidence.sure,
        '포 스트로크': AliasConfidence.sure,
        '포로 받': AliasConfidence.ambiguous,
        '포로': AliasConfidence.ambiguous,
      });
    });

    test('높은공: 모든 표현이 ambiguous다', () async {
      expect(await aliasesOf('높은공'), {
        '높이 뜨': AliasConfidence.ambiguous,
        '높이 튀': AliasConfidence.ambiguous,
        '뜨는 공': AliasConfidence.ambiguous,
      });
    });

    test('어깨·광배: "어깨"만 ambiguous다', () async {
      expect(await aliasesOf('어깨·광배'), {
        '광배': AliasConfidence.sure,
        '어깨 통증': AliasConfidence.sure,
        '어깨': AliasConfidence.ambiguous,
      });
    });

    test('더위: 찜통은 sure, 더워·더운은 ambiguous다', () async {
      expect(await aliasesOf('더위'), {
        '더위': AliasConfidence.sure,
        '찜통': AliasConfidence.sure,
        '더워': AliasConfidence.ambiguous,
        '더운': AliasConfidence.ambiguous,
      });
    });
  });

  group('제외 단어', () {
    test('서브는 리턴·리시브 표현을 제외한다', () async {
      expect(
        await exclusionsOf('서브'),
        containsAll(['서브 리턴', '서브리턴', '서브 리시브', '서브리시브']),
      );
    });

    test('백핸드는 백스텝을 제외한다', () async {
      expect(await exclusionsOf('백핸드'), ['백스텝']);
    });

    test('상체프레임은 라켓 프레임 샷 표현을 제외한다', () async {
      // "프레임에 맞았다"는 라켓 프레임 얘기라 상체 프레임과 무관하다.
      expect(await exclusionsOf('상체프레임'), containsAll(['프레임에 맞', '프레임 샷']));
    });

    test('제외 단어가 있는 태그는 서브·백핸드·상체프레임뿐이다', () {
      final withExclusions = tagSeeds
          .where((s) => s.exclusions.isNotEmpty)
          .map((s) => s.name)
          .toSet();
      expect(withExclusions, {'서브', '백핸드', '상체프레임'});
    });
  });

  group('엔진이 걸려 넘어질 수 있는 표현들', () {
    test('"어깨"로 시작하는 긴 표현들이 "어깨"와 함께 사전에 있다', () async {
      // 긴 표현 우선 규칙이 동작하려면 긴 쪽과 짧은 쪽이 둘 다 사전에 있어야
      // 한다. '어깨'(어깨·광배, ambiguous)가 가장 짧으므로, 아래 표현들이
      // 매칭될 때 '어깨'가 끼어들지 않아야 한다.
      expect(await aliasesOf('유닛턴'), containsPair('왼쪽 어깨', anything));
      expect(await aliasesOf('유닛턴'), containsPair('어깨 회전', anything));
      expect(await aliasesOf('몸열림'), containsPair('어깨가 열', anything));
      expect(
        await aliasesOf('어깨·광배'),
        allOf(containsPair('어깨 통증', anything), containsPair('어깨', anything)),
      );
    });

    test('"킥서브"와 "스핀서브"가 서브와 킥 양쪽에 등록돼 있다', () async {
      // 명세 6번 3-1: 완전히 같은 표현이 여러 태그에 있으면 모두 붙인다.
      // 그 규칙이 성립하려면 같은 문자열이 두 태그에 중복 등록돼 있어야 한다.
      for (final alias in ['킥서브', '스핀서브']) {
        expect(await aliasesOf('서브'), containsPair(alias, anything));
        expect(await aliasesOf('킥'), containsPair(alias, anything));
      }
    });

    test('서브에 "플랫서브"/"슬라이스서브" 복합어를 넣지 않는다', () async {
      // 상대 태그(#플랫, #슬라이스)가 같은 문자열을 갖고 있지 않아서 3-1 규칙이
      // 걸리지 않는다. 넣으면 긴 표현 우선 규칙 때문에 '플랫'/'슬라이스'가
      // 삼켜져서 명세 6번 테스트가 깨진다.
      final aliases = await aliasesOf('서브');
      expect(aliases.keys, isNot(contains('플랫서브')));
      expect(aliases.keys, isNot(contains('슬라이스서브')));
    });

    test('왼쪽 어깨 계열은 ambiguous다', () async {
      // 부상 메모일 수도 있어서 #유닛턴을 자동 확정하지 않는다.
      final aliases = await aliasesOf('유닛턴');
      for (final a in ['왼쪽 어깨', '왼어깨', '왼 어깨']) {
        expect(aliases[a], AliasConfidence.ambiguous, reason: a);
      }
      expect(aliases['어깨 회전'], AliasConfidence.sure);
    });

    test('"무릎 굽"이 body의 "무릎"보다 긴 표현으로 사전에 있다', () async {
      // "무릎 굽혀"는 하체로딩(기술) 얘기라 부상 태그로 가면 안 된다.
      expect(await aliasesOf('하체로딩'), containsPair('무릎 굽', anything));
      expect(await aliasesOf('무릎'), containsPair('무릎', anything));
    });

    test('"프레임"이 상체프레임의 ambiguous 표현이다', () async {
      // 제외 단어와 짝을 이뤄야 오탐이 막힌다.
      expect(
        await aliasesOf('상체프레임'),
        containsPair('프레임', AliasConfidence.ambiguous),
      );
    });

    test('"잠 "의 뒤 공백이 보존된다', () async {
      // 의도적인 공백이다. "잠깐", "잠수"에 걸리지 않게 하려는 표현이라
      // trim하면 안 된다. 3단계 엔진에서 공백 제거 버전과의 충돌을 처리한다.
      final aliases = await aliasesOf('수면');
      expect(aliases.keys, contains('잠 '));
      expect(aliases.keys, isNot(contains('잠')));
    });

    test('"백스텝"은 물러나기의 표현이면서 백핸드의 제외 단어다', () async {
      expect(await aliasesOf('물러나기'), containsPair('백스텝', anything));
      expect(await exclusionsOf('백핸드'), contains('백스텝'));
    });
  });

  test('시드를 다시 돌려도 중복이 생기지 않는다', () async {
    final tagsBefore = (await db.select(db.tags).get()).length;
    final aliasesBefore = (await db.select(db.tagAliases).get()).length;
    final exclusionsBefore = (await db.select(db.tagExclusions).get()).length;

    await seedTagDictionary(db);
    await seedTagDictionary(db);

    expect((await db.select(db.tags).get()).length, tagsBefore);
    expect((await db.select(db.tagAliases).get()).length, aliasesBefore);
    expect((await db.select(db.tagExclusions).get()).length, exclusionsBefore);
  });

  test('사용자가 만든 태그가 있으면 시드를 다시 넣지 않는다', () async {
    await db
        .into(db.tags)
        .insert(
          TagsCompanion.insert(
            name: '직접 만든 태그',
            category: TagCategory.situation,
          ),
        );
    final before = (await db.select(db.tags).get()).length;

    await seedTagDictionary(db);

    expect((await db.select(db.tags).get()).length, before);
  });
}
