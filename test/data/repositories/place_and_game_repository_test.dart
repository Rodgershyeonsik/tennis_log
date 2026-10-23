import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/data/repositories/game_repository.dart';
import 'package:tennis_log/data/repositories/place_repository.dart';

void main() {
  late AppDatabase db;
  late PlaceRepository places;
  late GameRepository games;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    places = PlaceRepository(db);
    games = GameRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PlaceRepository', () {
    test('등록한 장소를 바로 돌려준다 (등록하면 바로 선택된다)', () async {
      final place = await places.create(
        name: '  귀뚜라미 실내  ',
        surface: SurfaceType.clay,
        isIndoor: true,
      );

      expect(place.name, '귀뚜라미 실내');
      expect(place.surface, SurfaceType.clay);
      expect(place.isIndoor, isTrue);
    });

    test('칩은 최근 사용 순이고 limit만큼만 나온다', () async {
      for (final name in ['첫째', '둘째', '셋째', '넷째', '다섯째']) {
        final place = await places.create(
          name: name,
          surface: SurfaceType.hard,
          isIndoor: false,
        );
        // 등록 순서와 사용 순서를 반대로 만든다.
        await places.touch(
          place.id,
          at: DateTime(2026, 1, 1).add(Duration(days: -place.id)),
        );
      }

      final recent = await places.watchRecent().first;
      expect(recent, hasLength(4));
      expect(recent.map((p) => p.name), ['첫째', '둘째', '셋째', '넷째']);
    });

    test('touch로 최근 사용 시각을 갱신한다', () async {
      final older = await places.create(
        name: '예전 코트',
        surface: SurfaceType.hard,
        isIndoor: false,
      );
      final newer = await places.create(
        name: '새 코트',
        surface: SurfaceType.hard,
        isIndoor: false,
      );
      await places.touch(older.id, at: DateTime(2020, 1, 1));
      await places.touch(newer.id, at: DateTime(2026, 1, 1));

      expect((await places.watchRecent().first).first.name, '새 코트');

      await places.touch(older.id, at: DateTime(2026, 9, 29));
      expect((await places.watchRecent().first).first.name, '예전 코트');
    });

    test('없는 장소를 찾으면 null이다', () async {
      expect(await places.findById(999), isNull);
    });
  });

  group('PlaceRepository.watchByName', () {
    Future<void> seed() async {
      for (final name in ['양재 야외', '귀뚜라미 실내', '강남 실내', '귀뚜라미 야외']) {
        await places.create(
          name: name,
          surface: SurfaceType.hard,
          isIndoor: false,
        );
      }
    }

    test('검색어가 없으면 이름 오름차순 전체', () async {
      await seed();

      final result = await places.watchByName().first;

      expect(result.map((p) => p.name), [
        '강남 실내',
        '귀뚜라미 실내',
        '귀뚜라미 야외',
        '양재 야외',
      ]);
    });

    test('검색어가 있으면 이름에 들어간 것만 남는다', () async {
      await seed();

      final result = await places.watchByName(query: '귀뚜라미').first;

      expect(result.map((p) => p.name), ['귀뚜라미 실내', '귀뚜라미 야외']);
    });

    test('가운데 글자로도 찾고, 앞뒤 공백은 무시한다', () async {
      await seed();

      final result = await places.watchByName(query: '  실내 ').first;

      expect(result.map((p) => p.name), ['강남 실내', '귀뚜라미 실내']);
    });

    test('없는 이름이면 빈 목록', () async {
      await seed();

      expect(await places.watchByName(query: '없는곳').first, isEmpty);
    });
  });

  group('GameRepository', () {
    late int sessionId;

    setUp(() async {
      sessionId = await db
          .into(db.sessions)
          .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 29)));
    });

    test('게임을 목록 맨 끝에 추가한다', () async {
      await games.add(
        sessionId: sessionId,
        format: GameFormat.mixedDoubles,
        myScore: 6,
        opponentScore: 4,
      );
      final second = await games.add(
        sessionId: sessionId,
        format: GameFormat.womenDoubles,
      );

      expect(second.orderIndex, 1);
      final list = await games.watchBySession(sessionId).first;
      expect(list.map((g) => g.format), [
        GameFormat.mixedDoubles,
        GameFormat.womenDoubles,
      ]);
    });

    test('스코어를 비우면 "스코어 모름"으로 저장된다', () async {
      final game = await games.add(
        sessionId: sessionId,
        format: GameFormat.singles,
      );

      expect(game.myScore, isNull);
      expect(game.opponentScore, isNull);
    });

    test('수정해도 순서는 그대로다', () async {
      final first = await games.add(
        sessionId: sessionId,
        format: GameFormat.mixedDoubles,
      );
      await games.add(sessionId: sessionId, format: GameFormat.singles);

      await games.update(
        gameId: first.id,
        format: GameFormat.menDoubles,
        myScore: 3,
        opponentScore: 6,
      );

      final list = await games.watchBySession(sessionId).first;
      expect(list.first.format, GameFormat.menDoubles);
      expect(list.first.myScore, 3);
      expect(list.first.orderIndex, 0);
    });

    test('수정으로 스코어를 "모름"으로 되돌릴 수 있다', () async {
      final game = await games.add(
        sessionId: sessionId,
        format: GameFormat.singles,
        myScore: 6,
        opponentScore: 4,
      );

      await games.update(gameId: game.id, format: GameFormat.singles);

      final updated = (await games.watchBySession(sessionId).first).single;
      expect(updated.myScore, isNull);
    });

    test('삭제한다', () async {
      final game = await games.add(
        sessionId: sessionId,
        format: GameFormat.singles,
      );
      await games.delete(game.id);

      expect(await games.watchBySession(sessionId).first, isEmpty);
    });

    test('다른 세션의 게임은 섞이지 않는다', () async {
      await games.add(sessionId: sessionId, format: GameFormat.singles);
      final other = await db
          .into(db.sessions)
          .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 28)));
      await games.add(sessionId: other, format: GameFormat.openDoubles);

      expect(await games.watchBySession(sessionId).first, hasLength(1));
    });
  });
}
