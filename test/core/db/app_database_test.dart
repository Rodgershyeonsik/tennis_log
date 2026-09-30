import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/enums.dart';

/// 이 테스트는 스키마의 "조용히 깨질 수 있는 부분"을 못 박아 두는 용도다.
/// 특히 외래키 제약은 SQLite에서 커넥션마다 켜줘야 하는데, 안 켜져 있어도
/// insert/delete가 에러 없이 통과하므로 테스트 없이는 알아차리기 어렵다.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  /// 테스트용 세션 하나를 만들고 id를 돌려준다.
  Future<int> insertSession({int? placeId, int? cueId}) {
    return db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: DateTime(2026, 9, 29),
            placeId: Value.absentIfNull(placeId),
            cueId: Value.absentIfNull(cueId),
          ),
        );
  }

  Future<int> insertPlace({String name = '귀뚜라미 야외'}) {
    return db
        .into(db.places)
        .insert(
          PlacesCompanion.insert(
            name: name,
            surface: SurfaceType.hard,
            isIndoor: false,
          ),
        );
  }

  Future<int> insertTag({String name = '백발리', int? parentTagId}) {
    return db
        .into(db.tags)
        .insert(
          TagsCompanion.insert(
            name: name,
            category: TagCategory.technique,
            parentTagId: Value.absentIfNull(parentTagId),
          ),
        );
  }

  Future<int> insertMemo(int sessionId, {String content = '백발리 안 됨'}) {
    return db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: 0,
          ),
        );
  }

  test('9개 테이블이 모두 생성된다', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    final names = rows.map((r) => r.read<String>('name')).toSet();

    expect(
      names,
      containsAll([
        'places',
        'cues',
        'sessions',
        'games',
        'memos',
        'tags',
        'tag_aliases',
        'tag_exclusions',
        'memo_tags',
      ]),
    );
  });

  test('외래키 제약이 켜져 있다', () async {
    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.read<int>('foreign_keys'), 1);
  });

  group('소유 관계는 cascade로 함께 삭제된다', () {
    test('세션을 지우면 games, memos, memo_tags까지 사라진다', () async {
      final sessionId = await insertSession();
      final memoId = await insertMemo(sessionId);
      final tagId = await insertTag();
      await db
          .into(db.games)
          .insert(
            GamesCompanion.insert(
              sessionId: sessionId,
              format: GameFormat.mixedDoubles,
              orderIndex: 0,
            ),
          );
      await db.into(db.memoTags).insert(
        MemoTagsCompanion.insert(
          memoId: memoId,
          tagId: tagId,
          source: MemoTagSource.auto,
          status: MemoTagStatus.confirmed,
        ),
      );

      await (db.delete(db.sessions)..where((t) => t.id.equals(sessionId))).go();

      expect(await db.select(db.games).get(), isEmpty);
      expect(await db.select(db.memos).get(), isEmpty);
      expect(await db.select(db.memoTags).get(), isEmpty);
      // 태그 자체는 세션에 속한 데이터가 아니므로 남아 있어야 한다.
      expect(await db.select(db.tags).get(), hasLength(1));
    });

    test('태그를 지우면 인식 표현과 제외 단어가 사라진다', () async {
      final tagId = await insertTag(name: '서브');
      await db.into(db.tagAliases).insert(
        TagAliasesCompanion.insert(
          tagId: tagId,
          alias: '퍼스트',
          confidence: AliasConfidence.sure,
        ),
      );
      await db
          .into(db.tagExclusions)
          .insert(TagExclusionsCompanion.insert(tagId: tagId, word: '서브 리턴'));

      await (db.delete(db.tags)..where((t) => t.id.equals(tagId))).go();

      expect(await db.select(db.tagAliases).get(), isEmpty);
      expect(await db.select(db.tagExclusions).get(), isEmpty);
    });
  });

  group('참조 관계는 부모 삭제를 거부한다', () {
    test('세션이 참조 중인 장소는 지울 수 없다', () async {
      final placeId = await insertPlace();
      await insertSession(placeId: placeId);

      await expectLater(
        (db.delete(db.places)..where((t) => t.id.equals(placeId))).go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test('세션이 참조 중인 큐는 지울 수 없다', () async {
      final cueId = await db
          .into(db.cues)
          .insert(CuesCompanion.insert(cueText: '왼팔 늦게 내리기'));
      await insertSession(cueId: cueId);

      await expectLater(
        (db.delete(db.cues)..where((t) => t.id.equals(cueId))).go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test('자식이 부모로 가리키는 태그는 지울 수 없다', () async {
      final parentId = await insertTag(name: '발리');
      await insertTag(name: '백발리', parentTagId: parentId);

      await expectLater(
        (db.delete(db.tags)..where((t) => t.id.equals(parentId))).go(),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('유니크 제약', () {
    test('같은 이름의 장소는 두 번 등록할 수 없다', () async {
      await insertPlace(name: '귀뚜라미 실내');
      await expectLater(
        insertPlace(name: '귀뚜라미 실내'),
        throwsA(isA<SqliteException>()),
      );
    });

    test('같은 텍스트의 큐는 두 번 만들 수 없다', () async {
      await db.into(db.cues).insert(CuesCompanion.insert(cueText: '유닛턴 먼저'));
      await expectLater(
        db.into(db.cues).insert(CuesCompanion.insert(cueText: '유닛턴 먼저')),
        throwsA(isA<SqliteException>()),
      );
    });

    test('같은 이름의 태그는 두 번 만들 수 없다', () async {
      await insertTag(name: '포칭');
      await expectLater(insertTag(name: '포칭'), throwsA(isA<SqliteException>()));
    });

    test('같은 태그에 같은 인식 표현은 한 번만 들어간다', () async {
      final tagId = await insertTag(name: '서브');
      Future<int> addAlias(int forTag) => db.into(db.tagAliases).insert(
        TagAliasesCompanion.insert(
          tagId: forTag,
          alias: '세컨',
          confidence: AliasConfidence.sure,
        ),
      );

      await addAlias(tagId);
      await expectLater(addAlias(tagId), throwsA(isA<SqliteException>()));

      // 같은 표현이 **다른** 태그에 붙는 건 허용한다.
      final otherTagId = await insertTag(name: '토스');
      await expectLater(addAlias(otherTagId), completes);
    });

    test('memo_tags는 (memoId, tagId) 복합 기본키다', () async {
      final sessionId = await insertSession();
      final memoId = await insertMemo(sessionId);
      final tagId = await insertTag();
      Future<int> link() => db.into(db.memoTags).insert(
        MemoTagsCompanion.insert(
          memoId: memoId,
          tagId: tagId,
          source: MemoTagSource.auto,
          status: MemoTagStatus.suggested,
        ),
      );

      await link();
      await expectLater(link(), throwsA(isA<SqliteException>()));
    });
  });

  group('값 제약', () {
    test('시작·종료 시간은 06:00~24:00 범위를 벗어날 수 없다', () async {
      final sessionId = await insertSession();
      final update = db.update(db.sessions)
        ..where((t) => t.id.equals(sessionId));

      await expectLater(
        update.write(const SessionsCompanion(startMinutes: Value(300))),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        update.write(const SessionsCompanion(endMinutes: Value(1450))),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        update.write(
          const SessionsCompanion(
            startMinutes: Value(1080),
            endMinutes: Value(1440),
          ),
        ),
        completes,
      );
    });

    test('컨디션 점수는 1~3만 허용한다', () async {
      final sessionId = await insertSession();
      final update = db.update(db.sessions)
        ..where((t) => t.id.equals(sessionId));

      await expectLater(
        update.write(const SessionsCompanion(conditionScore: Value(0))),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        update.write(const SessionsCompanion(conditionScore: Value(4))),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        update.write(const SessionsCompanion(conditionScore: Value(3))),
        completes,
      );
    });

    test('종료가 시작보다 이른 값도 저장은 된다 (검증은 화면에서 한다)', () async {
      // 자동 저장은 필수값 검사 없이 저장하므로 DB가 막으면 안 된다.
      final sessionId = await insertSession();
      await expectLater(
        (db.update(db.sessions)..where((t) => t.id.equals(sessionId))).write(
          const SessionsCompanion(
            startMinutes: Value(1200),
            endMinutes: Value(1080),
          ),
        ),
        completes,
      );
    });
  });

  group('저장 형식', () {
    test('날짜는 텍스트로 저장되고 그대로 돌아온다', () async {
      // 유닉스 초로 저장하면 타임존에 따라 날짜가 하루 밀릴 수 있어서
      // storeDateTimeAsText를 켰다. 그 설정이 살아 있는지 확인한다.
      final sessionId = await insertSession();
      final raw = await db
          .customSelect(
            'SELECT typeof(date) AS t, date FROM sessions WHERE id = ?',
            variables: [Variable<int>(sessionId)],
          )
          .getSingle();
      expect(raw.read<String>('t'), 'text');

      final session = await (db.select(
        db.sessions,
      )..where((t) => t.id.equals(sessionId))).getSingle();
      expect(session.date, DateTime(2026, 9, 29));
    });

    test('enum은 name 문자열로 저장되고 enum으로 돌아온다', () async {
      final placeId = await insertPlace();
      final raw = await db
          .customSelect(
            'SELECT surface FROM places WHERE id = ?',
            variables: [Variable<int>(placeId)],
          )
          .getSingle();
      expect(raw.read<String>('surface'), 'hard');

      final place = await (db.select(
        db.places,
      )..where((t) => t.id.equals(placeId))).getSingle();
      expect(place.surface, SurfaceType.hard);
    });

    test('새 세션의 기본값은 game / draft / tagReviewed=false 다', () async {
      final sessionId = await insertSession();
      final session = await (db.select(
        db.sessions,
      )..where((t) => t.id.equals(sessionId))).getSingle();

      expect(session.sessionType, SessionType.game);
      expect(session.status, SessionStatus.draft);
      expect(session.tagReviewed, isFalse);
    });
  });
}
