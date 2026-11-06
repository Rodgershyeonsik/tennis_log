import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/data/repositories/search_repository.dart';
import 'package:tennis_log/data/repositories/tag_repository.dart';
import 'package:tennis_log/domain/search/search_aggregator.dart';
import 'package:tennis_log/domain/search/search_filter.dart';
import 'package:tennis_log/domain/search/search_models.dart';
import 'package:tennis_log/domain/search/tag_hierarchy.dart';

void main() {
  late AppDatabase db;
  late SearchRepository repo;
  late TagRepository tags;

  final today = DateTime(2026, 10, 25);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SearchRepository(db);
    tags = TagRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> tagId(String name) async => (await tags.findByName(name))!.id;

  /// 기본값은 조회 대상 세션이다.
  Future<int> addSession({
    DateTime? date,
    int? startMinutes,
    SessionStatus status = SessionStatus.complete,
    bool tagReviewed = true,
    SessionType sessionType = SessionType.game,
    SurfaceType? surface,
    bool? isIndoor,
    int? placeId,
    int? conditionScore,
    CueApplied? cueApplied,
  }) {
    return db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: date ?? DateTime(2026, 10, 1),
            startMinutes: Value(startMinutes),
            status: Value(status),
            tagReviewed: Value(tagReviewed),
            sessionType: Value(sessionType),
            surfaceSnapshot: Value(surface),
            isIndoorSnapshot: Value(isIndoor),
            placeId: Value(placeId),
            conditionScore: Value(conditionScore),
            cueApplied: Value(cueApplied),
          ),
        );
  }

  Future<void> addMemoTag(
    int memoId,
    String name, {
    MemoTagStatus status = MemoTagStatus.confirmed,
  }) async {
    await db
        .into(db.memoTags)
        .insert(
          MemoTagsCompanion.insert(
            memoId: memoId,
            tagId: await tagId(name),
            source: MemoTagSource.auto,
            status: status,
          ),
        );
  }

  Future<int> addMemo(
    int sessionId, {
    String content = '메모',
    int orderIndex = 0,
    MemoEvaluation? evaluation = MemoEvaluation.none,
    EvaluationStatus? evaluationStatus = EvaluationStatus.confirmed,
    List<String> tagNames = const [],
  }) async {
    final memoId = await db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: orderIndex,
            evaluation: Value(evaluation),
            evaluationStatus: Value(evaluationStatus),
          ),
        );
    for (final name in tagNames) {
      await addMemoTag(memoId, name);
    }
    return memoId;
  }

  Future<List<SearchMemo>> search([
    SearchFilter filter = const SearchFilter(),
  ]) {
    return repo.watchMemos(filter, today: today).first;
  }

  Future<Set<String>> contents([
    SearchFilter filter = const SearchFilter(),
  ]) async {
    return {for (final memo in await search(filter)) memo.content};
  }

  Future<int> excluded([SearchScope scope = const SearchScope.all()]) {
    return repo.watchExcludedSessionCount(scope, today: today).first;
  }

  group('조회 대상', () {
    test('작성 중 세션은 제외하고 안내 N에 넣는다', () async {
      final id = await addSession(
        status: SessionStatus.draft,
        tagReviewed: false,
      );
      await addMemo(id);

      expect(await search(), isEmpty);
      expect(await excluded(), 1);
    });

    test('태그 확인 전 세션은 제외하고 안내 N에 넣는다', () async {
      final id = await addSession(tagReviewed: false);
      await addMemo(id);

      expect(await search(), isEmpty);
      expect(await excluded(), 1);
    });

    test('draft인데 tagReviewed가 true면 제외하고 안내 N에 넣는다', () async {
      final id = await addSession(status: SessionStatus.draft);
      await addMemo(id);

      expect(await search(), isEmpty);
      expect(await excluded(), 1);
    });

    test('complete이고 tagReviewed가 true면 포함하고 안내 N에는 없다', () async {
      final id = await addSession();
      await addMemo(id);

      expect(await search(), hasLength(1));
      expect(await excluded(), 0);
    });

    test('suggested와 rejected 태그는 담지 않는다', () async {
      final id = await addSession();
      final memoId = await addMemo(id, tagNames: ['서브']);
      await addMemoTag(memoId, '리턴', status: MemoTagStatus.suggested);
      await addMemoTag(memoId, '발리', status: MemoTagStatus.rejected);

      final memo = (await search()).single;
      expect(memo.tagIds, [await tagId('서브')]);

      final hierarchy = TagHierarchy(await repo.watchTags().first);
      expect(SearchAggregator.summarize([memo], hierarchy).map((i) => i.name), [
        '서브',
      ]);
      expect(SearchAggregator.tagStats([memo], hierarchy).map((r) => r.name), [
        '서브',
      ]);
    });

    test('확정이 아닌 평가는 쓰지 않는다', () async {
      final id = await addSession();
      await addMemo(
        id,
        evaluation: MemoEvaluation.bad,
        evaluationStatus: EvaluationStatus.suggested,
      );

      expect((await search()).single.evaluation, isNull);
    });

    test('태그가 없는 메모도 조회한다', () async {
      final id = await addSession();
      await addMemo(id);

      expect((await search()).single.tagIds, isEmpty);
    });

    test('태그가 여러 개여도 메모는 한 건이다', () async {
      final id = await addSession();
      await addMemo(id, tagNames: ['서브', '리턴']);

      final memo = (await search()).single;
      expect(memo.tagIds, hasLength(2));
    });
  });

  group('안내 N', () {
    test('메모가 없는 세션은 세지 않는다', () async {
      await addSession(status: SessionStatus.draft, tagReviewed: false);

      expect(await excluded(), 0);
    });

    test('메모가 여러 개여도 세션 하나로 센다', () async {
      final id = await addSession(tagReviewed: false);
      await addMemo(id);
      await addMemo(id, orderIndex: 1);

      expect(await excluded(), 1);
    });

    test('범위가 기간이면 그 기간 안에서만 센다', () async {
      final inside = await addSession(
        date: DateTime(2026, 10, 1),
        tagReviewed: false,
      );
      final outside = await addSession(
        date: DateTime(2026, 1, 1),
        tagReviewed: false,
      );
      await addMemo(inside);
      await addMemo(outside);

      expect(
        await excluded(const SearchScope.preset(PeriodPreset.threeMonths)),
        1,
      );
    });

    test('전체와 최근 N세션이면 전체에서 센다', () async {
      final first = await addSession(
        date: DateTime(2026, 10, 1),
        tagReviewed: false,
      );
      final second = await addSession(
        date: DateTime(2026, 1, 1),
        tagReviewed: false,
      );
      await addMemo(first);
      await addMemo(second);

      expect(await excluded(), 2);
      expect(await excluded(const SearchScope.recentSessions(1)), 2);
    });
  });

  group('범위', () {
    Future<void> addDated(DateTime date) async {
      final id = await addSession(date: date);
      await addMemo(id, content: '${date.month}-${date.day}');
    }

    test('최근 3개월은 양 끝 날짜를 포함한다', () async {
      await addDated(DateTime(2026, 7, 24));
      await addDated(DateTime(2026, 7, 25));
      await addDated(DateTime(2026, 10, 25));

      expect(
        await contents(
          const SearchFilter(
            scope: SearchScope.preset(PeriodPreset.threeMonths),
          ),
        ),
        {'7-25', '10-25'},
      );
    });

    test('오늘이 5월 31일이면 최근 1개월은 4월 30일부터다', () async {
      await addDated(DateTime(2026, 4, 29));
      await addDated(DateTime(2026, 4, 30));

      final memos = await repo
          .watchMemos(
            const SearchFilter(
              scope: SearchScope.preset(PeriodPreset.oneMonth),
            ),
            today: DateTime(2026, 5, 31),
          )
          .first;

      expect(memos.map((m) => m.content), ['4-30']);
    });

    test('세션 유형을 먼저 거른 뒤 최근 N세션을 고른다', () async {
      Future<void> add(int day, SessionType type) async {
        final id = await addSession(
          date: DateTime(2026, 10, day),
          sessionType: type,
        );
        await addMemo(id, content: '$day');
      }

      await add(4, SessionType.game);
      await add(3, SessionType.lesson);
      await add(2, SessionType.game);
      await add(1, SessionType.game);

      expect(
        await contents(
          const SearchFilter(
            scope: SearchScope.recentSessions(3),
            sessionTypes: {SessionType.game},
          ),
        ),
        {'4', '2', '1'},
      );
    });

    test('같은 날 세션 두 개면 시작 시각이 늦은 세션을 고른다', () async {
      final early = await addSession(startMinutes: 600);
      final late_ = await addSession(startMinutes: 1200);
      await addMemo(late_, content: '늦은 세션');
      await addMemo(early, content: '이른 세션');

      expect(
        await contents(
          const SearchFilter(scope: SearchScope.recentSessions(1)),
        ),
        {'늦은 세션'},
      );
    });

    test('평가 필터로 메모가 줄어도 세션을 더 찾아 내려가지 않는다', () async {
      Future<void> add(int day, MemoEvaluation evaluation) async {
        final id = await addSession(date: DateTime(2026, 10, day));
        await addMemo(id, content: '$day', evaluation: evaluation);
      }

      await add(3, MemoEvaluation.good);
      await add(2, MemoEvaluation.bad);
      await add(1, MemoEvaluation.good);

      expect(
        await contents(
          const SearchFilter(
            scope: SearchScope.recentSessions(2),
            evaluations: {MemoEvaluation.good},
          ),
        ),
        {'3'},
      );
    });

    test('메모가 없는 조회 대상 세션도 최근 N세션의 한 자리다', () async {
      final older = await addSession(date: DateTime(2026, 10, 1));
      await addSession(date: DateTime(2026, 10, 2));
      await addMemo(older, content: '오래된 메모');

      expect(
        await contents(
          const SearchFilter(scope: SearchScope.recentSessions(1)),
        ),
        isEmpty,
      );
    });
  });

  group('필터', () {
    test('평가 여러 개는 둘 중 하나인 메모다', () async {
      final id = await addSession();
      await addMemo(id, content: '잘함', evaluation: MemoEvaluation.good);
      await addMemo(id, content: '못함', evaluation: MemoEvaluation.bad);
      await addMemo(id, content: '물음표', evaluation: MemoEvaluation.question);

      expect(
        await contents(
          const SearchFilter(
            evaluations: {MemoEvaluation.good, MemoEvaluation.bad},
          ),
        ),
        {'잘함', '못함'},
      );
    });

    test('평가 없음은 evaluation이 none인 메모다', () async {
      final id = await addSession();
      await addMemo(id, content: '없음');
      await addMemo(id, content: '잘함', evaluation: MemoEvaluation.good);

      expect(
        await contents(const SearchFilter(evaluations: {MemoEvaluation.none})),
        {'없음'},
      );
    });

    test('부모 태그는 자식 태그가 붙은 메모도 포함한다', () async {
      final id = await addSession();
      await addMemo(id, content: '발리', tagNames: ['발리']);
      await addMemo(id, content: '포발리', tagNames: ['포발리']);
      await addMemo(id, content: '백발리', tagNames: ['백발리']);
      await addMemo(id, content: '서브', tagNames: ['서브']);

      expect(await contents(SearchFilter(tagIds: {await tagId('발리')})), {
        '발리',
        '포발리',
        '백발리',
      });
    });

    test('자식 태그를 고르면 부모만 붙은 메모는 빠진다', () async {
      final id = await addSession();
      await addMemo(id, content: '발리', tagNames: ['발리']);
      await addMemo(id, content: '백발리', tagNames: ['백발리']);

      expect(await contents(SearchFilter(tagIds: {await tagId('백발리')})), {
        '백발리',
      });
    });

    group('태그 서브 + 몸열림', () {
      late Set<int> selected;

      setUp(() async {
        selected = {await tagId('서브'), await tagId('몸열림')};
        final id = await addSession();
        await addMemo(id, content: '서브', tagNames: ['서브']);
        await addMemo(id, content: '몸열림', tagNames: ['몸열림']);
        await addMemo(id, content: '둘 다', tagNames: ['서브', '몸열림']);
        await addMemo(id, content: '리턴', tagNames: ['리턴']);
      });

      test('하나라도: 둘 중 하나라도 붙은 메모', () async {
        expect(await contents(SearchFilter(tagIds: selected)), {
          '서브',
          '몸열림',
          '둘 다',
        });
      });

      test('모두: 둘 다 붙은 메모만', () async {
        expect(
          await contents(
            SearchFilter(tagIds: selected, tagMatch: TagMatchMode.all),
          ),
          {'둘 다'},
        );
      });
    });

    test('모두일 때 각 조건은 그 태그 또는 자손이다', () async {
      final id = await addSession();
      await addMemo(id, content: '백발리 서브', tagNames: ['백발리', '서브']);
      await addMemo(id, content: '서브', tagNames: ['서브']);

      expect(
        await contents(
          SearchFilter(
            tagIds: {await tagId('발리'), await tagId('서브')},
            tagMatch: TagMatchMode.all,
          ),
        ),
        {'백발리 서브'},
      );
    });

    test('표면 클레이 + 실내는 클레이이면서 실내인 세션만이다', () async {
      Future<void> add(String content, SurfaceType surface, bool indoor) async {
        final id = await addSession(surface: surface, isIndoor: indoor);
        await addMemo(id, content: content);
      }

      await add('클레이 실내', SurfaceType.clay, true);
      await add('클레이 야외', SurfaceType.clay, false);
      await add('하드 실내', SurfaceType.hard, true);

      expect(
        await contents(
          const SearchFilter(
            surfaces: {SurfaceType.clay},
            indoorOptions: {true},
          ),
        ),
        {'클레이 실내'},
      );
    });

    test('특정 장소는 placeId로 거른다', () async {
      final placeId = await db
          .into(db.places)
          .insert(
            PlacesCompanion.insert(
              name: '귀뚜라미 실내',
              surface: SurfaceType.hard,
              isIndoor: true,
            ),
          );
      final here = await addSession(placeId: placeId);
      final elsewhere = await addSession();
      await addMemo(here, content: '여기');
      await addMemo(elsewhere, content: '다른 곳');

      expect(await contents(SearchFilter(placeIds: {placeId})), {'여기'});
    });

    test('큐 적용 기록 없음은 cueApplied가 null인 세션이다', () async {
      final lesson = await addSession(sessionType: SessionType.lesson);
      final applied = await addSession(cueApplied: CueApplied.yes);
      await addMemo(lesson, content: '레슨');
      await addMemo(applied, content: '적용');

      expect(await contents(const SearchFilter(cueApplied: {null})), {'레슨'});
    });

    test('컨디션 굿 + 기록 없음은 굿이거나 null이다', () async {
      final good = await addSession(conditionScore: 3);
      final soso = await addSession(conditionScore: 2);
      final none = await addSession();
      await addMemo(good, content: '굿');
      await addMemo(soso, content: '쏘쏘');
      await addMemo(none, content: '기록 없음');

      expect(await contents(const SearchFilter(conditionScores: {3, null})), {
        '굿',
        '기록 없음',
      });
    });

    test('그룹 사이는 AND다', () async {
      final game = await addSession();
      final lesson = await addSession(sessionType: SessionType.lesson);
      await addMemo(game, content: '게임 잘함', evaluation: MemoEvaluation.good);
      await addMemo(game, content: '게임 못함', evaluation: MemoEvaluation.bad);
      await addMemo(lesson, content: '레슨 잘함', evaluation: MemoEvaluation.good);

      expect(
        await contents(
          const SearchFilter(
            sessionTypes: {SessionType.game},
            evaluations: {MemoEvaluation.good},
          ),
        ),
        {'게임 잘함'},
      );
    });
  });

  group('갱신', () {
    test('메모를 지우면 결과가 다시 나온다', () async {
      final id = await addSession();
      final memoId = await addMemo(id);

      final emissions = repo.watchMemos(const SearchFilter(), today: today);
      final expectation = expectLater(
        emissions.map((memos) => memos.length),
        emitsInOrder([1, 0]),
      );
      await pumpEventQueue();

      await (db.delete(db.memos)..where((t) => t.id.equals(memoId))).go();

      await expectation;
    });

    test('태그 확인을 끝내면 안내 N이 줄어든다', () async {
      final id = await addSession(tagReviewed: false);
      await addMemo(id);

      final expectation = expectLater(
        repo.watchExcludedSessionCount(const SearchScope.all(), today: today),
        emitsInOrder([1, 0]),
      );
      await pumpEventQueue();

      await (db.update(db.sessions)..where((t) => t.id.equals(id))).write(
        const SessionsCompanion(tagReviewed: Value(true)),
      );

      await expectation;
    });
  });

  test('태그 사전에 보관된 태그도 담는다', () async {
    final id = await tagId('서브');
    await (db.update(db.tags)..where((t) => t.id.equals(id))).write(
      const TagsCompanion(isArchived: Value(true)),
    );

    final allTags = await repo.watchTags().first;
    expect(allTags.singleWhere((tag) => tag.id == id).isArchived, isTrue);
  });
}
