import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/enums.dart';
import 'package:tennis_log/features/journal/data/cue_repository.dart';
import 'package:tennis_log/features/journal/data/place_repository.dart';
import 'package:tennis_log/features/journal/data/session_repository.dart';
import 'package:tennis_log/features/journal/domain/session_draft.dart';
import 'package:tennis_log/features/journal/domain/session_list_item.dart';

void main() {
  late AppDatabase db;
  late SessionRepository repo;
  late PlaceRepository places;
  late CueRepository cues;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SessionRepository(db);
    places = PlaceRepository(db);
    cues = CueRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertSession({
    required DateTime date,
    int? startMinutes,
    int? endMinutes,
  }) {
    return db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: date,
            startMinutes: Value(startMinutes),
            endMinutes: Value(endMinutes),
          ),
        );
  }

  group('dateOnly', () {
    test('시각을 잘라 로컬 자정으로 만든다', () {
      expect(
        SessionRepository.dateOnly(DateTime(2026, 9, 29, 18, 40, 12)),
        DateTime(2026, 9, 29),
      );
    });
  });

  group('draft 저장과 복원', () {
    test('createDraft로 만든 세션은 draft 상태다', () async {
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29)),
      );

      final session = (await repo.findById(id))!;
      expect(session.status, SessionStatus.draft);
      expect(session.sessionType, SessionType.game);
      expect(session.tagReviewed, isFalse);
    });

    test('날짜는 자정으로 정규화해서 저장한다', () async {
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29, 18, 40)),
      );

      expect((await repo.findById(id))!.date, DateTime(2026, 9, 29));
    });

    test('saveDraft 후 loadDraft로 값이 그대로 복원된다', () async {
      final place = await places.create(
        name: '귀뚜라미 야외',
        surface: SurfaceType.hard,
        isIndoor: false,
      );
      final cue = await cues.findOrCreate('왼팔 늦게 내리기');

      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29)),
      );
      final edited = SessionDraft(
        sessionType: SessionType.lesson,
        date: DateTime(2026, 9, 30),
        startMinutes: 1080,
        endMinutes: 1200,
        placeId: place.id,
        conditionScore: 3,
        lastMealBucket: LastMealBucket.h1to2,
        cueId: cue!.id,
        cueApplied: CueApplied.partial,
      );

      await repo.saveDraft(id, edited);

      expect(await repo.loadDraft(id), edited);
    });

    test('값을 비우는 수정도 반영된다', () async {
      final id = await repo.createDraft(
        SessionDraft(
          date: DateTime(2026, 9, 29),
          conditionScore: 3,
          startMinutes: 1080,
        ),
      );

      // 컨디션 버튼을 다시 눌러 해제한 상황.
      await repo.saveDraft(id, SessionDraft(date: DateTime(2026, 9, 29)));

      final loaded = (await repo.loadDraft(id))!;
      expect(loaded.conditionScore, isNull);
      expect(loaded.startMinutes, isNull);
    });

    test('없는 세션을 loadDraft하면 null이다', () async {
      expect(await repo.loadDraft(999), isNull);
    });
  });

  group('watchDrafts', () {
    test('complete 세션은 빼고 draft만 돌려준다', () async {
      final draftId = await insertSession(date: DateTime(2026, 9, 29));
      final completeId = await insertSession(date: DateTime(2026, 9, 28));
      await (db.update(
        db.sessions,
      )..where((t) => t.id.equals(completeId))).write(
        const SessionsCompanion(status: Value(SessionStatus.complete)),
      );

      final drafts = await repo.watchDrafts().first;
      expect(drafts.map((d) => d.id), [draftId]);
    });

    test('장소를 아직 안 골랐으면 placeName이 null이다', () async {
      await insertSession(date: DateTime(2026, 9, 29));
      expect((await repo.watchDrafts().first).single.placeName, isNull);
    });

    test('스냅샷이 없으면 현재 장소 이름을 쓴다', () async {
      final place = await places.create(
        name: '귀뚜라미 야외',
        surface: SurfaceType.hard,
        isIndoor: false,
      );
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29), placeId: place.id),
      );

      final draft = (await repo.watchDrafts().first).single;
      expect(draft.id, id);
      expect(draft.placeName, '귀뚜라미 야외');
    });

    test('최근 수정 순으로 정렬한다', () async {
      final older = await insertSession(date: DateTime(2026, 9, 29));
      final newer = await insertSession(date: DateTime(2026, 9, 1));
      await (db.update(db.sessions)..where((t) => t.id.equals(older))).write(
        SessionsCompanion(updatedAt: Value(DateTime(2026, 9, 29, 10))),
      );
      await (db.update(db.sessions)..where((t) => t.id.equals(newer))).write(
        SessionsCompanion(updatedAt: Value(DateTime(2026, 9, 29, 20))),
      );

      expect((await repo.watchDrafts().first).map((d) => d.id), [newer, older]);
    });
  });

  group('시간 기본값', () {
    test('과거 세션이 없으면 latestTimeRange는 null이다', () async {
      expect(await repo.latestTimeRange(), isNull);
    });

    test('시간이 비어 있는 세션은 건너뛴다', () async {
      await insertSession(date: DateTime(2026, 9, 29));
      expect(await repo.latestTimeRange(), isNull);
    });

    test('가장 최근 날짜 세션의 시작~종료를 돌려준다', () async {
      await insertSession(
        date: DateTime(2026, 9, 1),
        startMinutes: 600,
        endMinutes: 720,
      );
      await insertSession(
        date: DateTime(2026, 9, 29),
        startMinutes: 1080,
        endMinutes: 1200,
      );

      final range = (await repo.latestTimeRange())!;
      expect(range.startMinutes, 1080);
      expect(range.endMinutes, 1200);
      expect(range.durationMinutes, 120);
    });
  });

  group('frequentTimeRanges', () {
    test('가장 많이 쓴 조합 순으로 최대 3개를 돌려준다', () async {
      // 18:00~20:00 세 번
      for (final day in [1, 2, 3]) {
        await insertSession(
          date: DateTime(2026, 9, day),
          startMinutes: 1080,
          endMinutes: 1200,
        );
      }
      // 10:00~12:00 두 번
      for (final day in [4, 5]) {
        await insertSession(
          date: DateTime(2026, 9, day),
          startMinutes: 600,
          endMinutes: 720,
        );
      }
      // 06:00~08:00 한 번
      await insertSession(
        date: DateTime(2026, 9, 6),
        startMinutes: 360,
        endMinutes: 480,
      );
      // 21:00~23:00 한 번 — 4번째라 잘려야 한다.
      await insertSession(
        date: DateTime(2026, 9, 7),
        startMinutes: 1260,
        endMinutes: 1380,
      );

      final ranges = await repo.frequentTimeRanges();
      expect(ranges, hasLength(3));
      expect(ranges[0].startMinutes, 1080);
      expect(ranges[1].startMinutes, 600);
    });

    test('횟수가 같으면 최근에 쓴 조합이 먼저 온다', () async {
      await insertSession(
        date: DateTime(2026, 9, 1),
        startMinutes: 600,
        endMinutes: 720,
      );
      await insertSession(
        date: DateTime(2026, 9, 29),
        startMinutes: 1080,
        endMinutes: 1200,
      );

      final ranges = await repo.frequentTimeRanges();
      expect(ranges.first.startMinutes, 1080);
    });

    test('시간이 비어 있는 세션은 집계에서 빠진다', () async {
      await insertSession(date: DateTime(2026, 9, 29));
      expect(await repo.frequentTimeRanges(), isEmpty);
    });
  });

  group('finalizeSession', () {
    Future<void> addMemo(int sessionId) async {
      await db
          .into(db.memos)
          .insert(
            MemosCompanion.insert(
              sessionId: sessionId,
              content: '백발리 안 됨',
              orderIndex: 0,
            ),
          );
    }

    test('장소 정보를 스냅샷으로 복사한다', () async {
      final place = await places.create(
        name: '귀뚜라미 실내',
        surface: SurfaceType.clay,
        isIndoor: true,
      );
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29), placeId: place.id),
      );

      final session = await repo.finalizeSession(id);

      expect(session.placeNameSnapshot, '귀뚜라미 실내');
      expect(session.surfaceSnapshot, SurfaceType.clay);
      expect(session.isIndoorSnapshot, isTrue);
    });

    test('스냅샷은 장소 정보가 나중에 바뀌어도 유지된다', () async {
      final place = await places.create(
        name: '귀뚜라미 실내',
        surface: SurfaceType.clay,
        isIndoor: true,
      );
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29), placeId: place.id),
      );
      await repo.finalizeSession(id);

      // 장소 정보를 수정한다(이번 범위 밖 기능이지만 스냅샷의 존재 이유를 확인).
      await (db.update(db.places)..where((t) => t.id.equals(place.id))).write(
        const PlacesCompanion(
          name: Value('이름 바뀐 코트'),
          surface: Value(SurfaceType.hard),
        ),
      );

      final session = (await repo.findById(id))!;
      expect(session.placeNameSnapshot, '귀뚜라미 실내');
      expect(session.surfaceSnapshot, SurfaceType.clay);
    });

    test('메모가 1개 이상이면 complete가 된다', () async {
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29)),
      );
      await addMemo(id);

      expect((await repo.finalizeSession(id)).status, SessionStatus.complete);
    });

    test('메모가 없으면 draft로 남는다', () async {
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29)),
      );

      expect((await repo.finalizeSession(id)).status, SessionStatus.draft);
    });

    test('장소가 없어도 실패하지 않고 스냅샷만 비어 있다', () async {
      // 필수값 검사는 화면에서 하므로 리포지토리는 막지 않는다.
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29)),
      );

      final session = await repo.finalizeSession(id);
      expect(session.placeNameSnapshot, isNull);
      expect(session.surfaceSnapshot, isNull);
    });

    test('장소와 큐의 lastUsedAt을 갱신한다', () async {
      final place = await places.create(
        name: '귀뚜라미 야외',
        surface: SurfaceType.hard,
        isIndoor: false,
      );
      final cue = await cues.findOrCreate('왼팔 늦게 내리기');
      await places.touch(place.id, at: DateTime(2020, 1, 1));
      await cues.touch(cue!.id, at: DateTime(2020, 1, 1));

      final id = await repo.createDraft(
        SessionDraft(
          date: DateTime(2026, 9, 29),
          placeId: place.id,
          cueId: cue.id,
        ),
      );
      await repo.finalizeSession(id);

      expect(
        (await places.findById(place.id))!.lastUsedAt.year,
        DateTime.now().year,
      );
      expect((await cues.mostRecent())!.id, cue.id);
    });

    test('없는 세션이면 에러를 던진다', () async {
      expect(() => repo.finalizeSession(999), throwsStateError);
    });
  });

  test('markTagReviewed로 2단계 완료를 기록한다', () async {
    final id = await repo.createDraft(
      SessionDraft(date: DateTime(2026, 9, 29)),
    );

    await repo.markTagReviewed(id);

    expect((await repo.findById(id))!.tagReviewed, isTrue);
  });

  group('remove / restore (일지 삭제와 실행 취소)', () {
    /// 게임·메모·태그 연결까지 달린 일지 하나를 만든다.
    Future<int> fullSession() async {
      final id = await insertSession(date: DateTime(2026, 9, 29));
      await db
          .into(db.games)
          .insert(
            GamesCompanion.insert(
              sessionId: id,
              format: GameFormat.mixedDoubles,
              myScore: const Value(6),
              opponentScore: const Value(4),
              orderIndex: 0,
            ),
          );
      final memo = await db
          .into(db.memos)
          .insertReturning(
            MemosCompanion.insert(
              sessionId: id,
              content: '백발리 안 됨',
              orderIndex: 0,
            ),
          );
      final tag =
          await (db.select(db.tags)
                ..where((t) => t.name.equals('백발리'))
                ..limit(1))
              .getSingle();
      await db
          .into(db.memoTags)
          .insert(
            MemoTagsCompanion.insert(
              memoId: memo.id,
              tagId: tag.id,
              source: MemoTagSource.auto,
              status: MemoTagStatus.suggested,
            ),
          );
      return id;
    }

    test('딸린 게임·메모·태그 연결까지 함께 지운다', () async {
      final id = await fullSession();

      final removed = await repo.remove(id);

      expect(removed, isNotNull);
      expect(await repo.findById(id), isNull);
      expect(await db.select(db.games).get(), isEmpty);
      expect(await db.select(db.memos).get(), isEmpty);
      expect(await db.select(db.memoTags).get(), isEmpty);
    });

    test('restore로 id와 태그 연결까지 그대로 되돌린다', () async {
      final id = await fullSession();
      final removed = await repo.remove(id);

      await repo.restore(removed!);

      expect((await repo.findById(id))!.id, id);
      expect((await db.select(db.games).getSingle()).myScore, 6);
      final memo = await db.select(db.memos).getSingle();
      expect(memo.content, '백발리 안 됨');
      final link = await db.select(db.memoTags).getSingle();
      expect(link.memoId, memo.id);
      expect(link.status, MemoTagStatus.suggested);
    });

    test('장소와 큐는 참조 관계라 일지를 지워도 남는다', () async {
      final place = await places.create(
        name: '귀뚜라미 실내',
        surface: SurfaceType.hard,
        isIndoor: true,
      );
      final cue = (await cues.findOrCreate('왼팔 뻗기'))!;
      final id = await repo.createDraft(
        SessionDraft(
          date: DateTime(2026, 9, 29),
          placeId: place.id,
          cueId: cue.id,
        ),
      );

      await repo.remove(id);

      expect(await places.findById(place.id), isNotNull);
      expect(await cues.mostRecent(), isNotNull);
    });

    test('없는 일지를 지우면 null이다', () async {
      expect(await repo.remove(999), isNull);
    });
  });

  group('watchAll (메인 화면 목록)', () {
    Future<void> addMemos(int sessionId, List<String> contents) async {
      for (final (index, content) in contents.indexed) {
        await db
            .into(db.memos)
            .insert(
              MemosCompanion.insert(
                sessionId: sessionId,
                content: content,
                orderIndex: index,
              ),
            );
      }
    }

    test('날짜가 최근인 것부터 돌려준다', () async {
      await insertSession(date: DateTime(2026, 9, 20));
      await insertSession(date: DateTime(2026, 9, 29));
      await insertSession(date: DateTime(2026, 9, 25));

      final items = await repo.watchAll().first;

      expect(items.map((i) => i.date.day), [29, 25, 20]);
    });

    test('메모 개수를 세고, 메모가 없으면 0이다', () async {
      final withMemos = await insertSession(date: DateTime(2026, 9, 29));
      await addMemos(withMemos, ['서브 개굿', '백발리 안 됨', '포칭 먹힘']);
      await insertSession(date: DateTime(2026, 9, 20));

      final items = await repo.watchAll().first;

      expect(items.map((i) => i.memoCount), [3, 0]);
    });

    test('진행 단계를 상태와 tagReviewed로 가른다', () async {
      final writing = await insertSession(date: DateTime(2026, 9, 29));
      final saved = await insertSession(date: DateTime(2026, 9, 25));
      final reviewed = await insertSession(date: DateTime(2026, 9, 20));
      await addMemos(saved, ['저장까지 함']);
      await addMemos(reviewed, ['태그까지 봄']);
      await repo.finalizeSession(saved);
      await repo.finalizeSession(reviewed);
      await repo.markTagReviewed(reviewed);

      final items = await repo.watchAll().first;
      final byId = {for (final item in items) item.id: item.progress};

      expect(byId[writing], JournalProgress.writing);
      expect(byId[saved], JournalProgress.saved);
      expect(byId[reviewed], JournalProgress.reviewed);
    });

    test('장소는 스냅샷을 먼저 쓰고, 저장 전에는 현재 이름을 쓴다', () async {
      final place = await places.create(
        name: '귀뚜라미 실내',
        surface: SurfaceType.hard,
        isIndoor: true,
      );
      final id = await repo.createDraft(
        SessionDraft(date: DateTime(2026, 9, 29), placeId: place.id),
      );

      // 저장 전에는 스냅샷이 비어 있어서 현재 장소 이름이 나온다.
      expect((await repo.watchAll().first).single.placeName, '귀뚜라미 실내');

      await addMemos(id, ['메모']);
      await repo.finalizeSession(id);
      // 장소 수정 기능은 아직 없어서 DB를 직접 고친다.
      await (db.update(db.places)..where((t) => t.id.equals(place.id))).write(
        const PlacesCompanion(name: Value('이름 바뀜')),
      );

      // 저장 뒤에는 스냅샷이 남아서 장소 이름을 고쳐도 그대로다.
      expect((await repo.watchAll().first).single.placeName, '귀뚜라미 실내');
    });
  });
}
