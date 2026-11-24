import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/search/search_aggregator.dart';
import 'package:tennis_log/domain/search/search_filter.dart';
import 'package:tennis_log/domain/search/search_matcher.dart';
import 'package:tennis_log/domain/search/search_models.dart';
import 'package:tennis_log/domain/search/search_stats.dart';
import 'package:tennis_log/domain/search/tag_hierarchy.dart';

void main() {
  const serve = 1;
  const forehand = 2;
  const backhand = 3;
  const volley = 4;
  const frontVolley = 5;
  const backVolley = 6;
  const topspin = 7;
  const unitTurn = 8;
  const split = 9;
  const shortBall = 10;
  const downTheLine = 11;
  const judgment = 12;
  const shoulder = 13;
  const heat = 14;

  final hierarchy = TagHierarchy(const [
    SearchTag(id: serve, name: '서브', category: TagCategory.technique),
    SearchTag(id: forehand, name: '포핸드', category: TagCategory.technique),
    SearchTag(id: backhand, name: '백핸드', category: TagCategory.technique),
    SearchTag(id: volley, name: '발리', category: TagCategory.technique),
    SearchTag(
      id: frontVolley,
      name: '포발리',
      category: TagCategory.technique,
      parentTagId: volley,
    ),
    SearchTag(
      id: backVolley,
      name: '백발리',
      category: TagCategory.technique,
      parentTagId: volley,
    ),
    SearchTag(id: topspin, name: '탑스핀', category: TagCategory.technique),
    SearchTag(id: unitTurn, name: '유닛턴', category: TagCategory.form),
    SearchTag(id: split, name: '스플릿', category: TagCategory.footwork),
    SearchTag(id: shortBall, name: '짧은공', category: TagCategory.situation),
    SearchTag(id: downTheLine, name: '다운더라인', category: TagCategory.situation),
    SearchTag(id: judgment, name: '판단', category: TagCategory.situation),
    SearchTag(id: shoulder, name: '어깨', category: TagCategory.body),
    SearchTag(id: heat, name: '더위', category: TagCategory.conditionFactor),
  ]);

  const good = MemoEvaluation.good;
  const bad = MemoEvaluation.bad;
  const question = MemoEvaluation.question;
  const none = MemoEvaluation.none;

  SearchSession session(
    int id,
    DateTime date, {
    int? startMinutes,
    SessionType type = SessionType.game,
  }) {
    return SearchSession(
      id: id,
      date: date,
      startMinutes: startMinutes,
      sessionType: type,
    );
  }

  final s1 = session(1, DateTime(2026, 10, 1));
  final s2 = session(2, DateTime(2026, 10, 2));
  final s3 = session(3, DateTime(2026, 10, 3));

  var nextId = 1;

  SearchMemo memo(
    List<int> tagIds, {
    MemoEvaluation? evaluation = none,
    SearchSession? of,
    int orderIndex = 0,
  }) {
    final id = nextId++;
    return SearchMemo(
      id: id,
      content: '메모 $id',
      orderIndex: orderIndex,
      evaluation: evaluation,
      session: of ?? s1,
      tagIds: tagIds,
    );
  }

  List<SearchMemo> memos(
    int count,
    List<int> tagIds, {
    MemoEvaluation? evaluation = none,
    SearchSession? of,
  }) {
    return [
      for (var i = 0; i < count; i++)
        memo(tagIds, evaluation: evaluation, of: of, orderIndex: i),
    ];
  }

  SearchStats stats(List<SearchMemo> memos, {int? chartTagId}) {
    return SearchStats(
      memos: memos,
      hierarchy: hierarchy,
      chartTagId: chartTagId,
    );
  }

  /// 페이지 필터를 화면과 같은 방식으로 적용한 통계.
  SearchStats filteredStats(
    SearchFilter filter,
    List<SearchMemo> memos, {
    int? chartTagId,
  }) {
    return stats(
      SearchMatcher.apply(
        filter: filter.sessionOnly,
        sessions: {for (final memo in memos) memo.session}.toList(),
        memos: memos,
        hierarchy: hierarchy,
        today: DateTime(2026, 11, 24),
      ),
      chartTagId: chartTagId,
    );
  }

  List<int> sessionIds(SearchStats stats) {
    return stats.sessions.map((item) => item.session.id).toList();
  }

  Map<TagCategory, List<String>> names(
    Map<TagCategory, List<TagSummaryItem>> groups,
  ) {
    return groups.map((category, items) {
      return MapEntry(category, [for (final item in items) item.name]);
    });
  }

  group('데이터 범위', () {
    test('평가 필터는 적용하지 않는다', () {
      final result = filteredStats(const SearchFilter(evaluations: {good}), [
        memo([], evaluation: good, of: s1),
        memo([], evaluation: bad, of: s1),
        memo([], evaluation: bad, of: s2),
        memo([], evaluation: good, of: s3),
      ]);

      expect(sessionIds(result), [1, 2, 3]);
      expect(result.sessions.map((item) => item.evaluations), const [
        EvaluationCounts(good: 1, bad: 1),
        EvaluationCounts(bad: 1),
        EvaluationCounts(good: 1),
      ]);
    });

    test('태그 필터는 적용하지 않고 차트 태그만 본다', () {
      final result = filteredStats(const SearchFilter(tagIds: {serve}), [
        memo([serve]),
        memo([forehand]),
        memo([serve, forehand]),
      ], chartTagId: forehand);

      expect(result.chartMemos, hasLength(2));
      expect(result.sessions.single.evaluations.total, 2);
    });

    test('범위와 세션 단위 필터는 그대로 적용한다', () {
      final lesson = session(
        2,
        DateTime(2026, 10, 2),
        type: SessionType.lesson,
      );
      final older = session(4, DateTime(2026, 9, 1));
      final result = filteredStats(
        const SearchFilter(
          scope: SearchScope.recentSessions(2),
          sessionTypes: {SessionType.game},
        ),
        [
          memo([], of: older),
          memo([], of: s1),
          memo([], of: lesson),
          memo([], of: s3),
        ],
      );

      expect(sessionIds(result), [1, 3]);
    });

    test('차트 태그 메모가 없는 세션도 0건으로 남는다', () {
      final result = stats([
        memo([forehand], of: s1),
        memo([serve], of: s2),
      ], chartTagId: forehand);

      expect(sessionIds(result), [1, 2]);
      expect(result.sessions.last.evaluations, const EvaluationCounts());
    });

    test('차트 태그의 자손이 붙은 메모도 센다', () {
      final result = stats([
        memo([backVolley]),
      ], chartTagId: volley);

      expect(result.sessions.single.evaluations.total, 1);
    });

    test('자식을 고르면 부모만 붙은 메모는 세지 않는다', () {
      final result = stats([
        memo([volley]),
      ], chartTagId: backVolley);

      expect(result.sessions.single.evaluations.total, 0);
    });

    test('차트 태그가 없으면 모든 메모를 센다', () {
      final result = stats([
        memo([forehand]),
        memo([]),
      ]);

      expect(result.sessions.single.evaluations.total, 2);
      expect(result.totalMemoCount, 2);
    });
  });

  group('차트', () {
    test('세션은 날짜, 시작 시각, id 순이다', () {
      final date = DateTime(2026, 10, 12);
      final z = session(1, DateTime(2026, 10, 13));
      final y = session(2, date, startMinutes: 1200);
      final x = session(4, date, startMinutes: 1080);
      final sameTimeAsX = session(3, date, startMinutes: 1080);

      final result = stats([
        memo([], of: z),
        memo([], of: y),
        memo([], of: x),
        memo([], of: sameTimeAsX),
      ]);

      expect(sessionIds(result), [3, 4, 2, 1]);
    });

    test('평가별로 세고, 확정 평가가 없는 메모는 none으로 센다', () {
      final result = stats([
        ...memos(2, [], evaluation: good),
        memo([], evaluation: bad),
        memo([], evaluation: none),
        memo([], evaluation: question, of: s2),
        memo([], evaluation: null, of: s2),
      ]);

      expect(result.sessions.map((item) => item.evaluations), const [
        EvaluationCounts(good: 2, bad: 1, none: 1),
        EvaluationCounts(question: 1, none: 1),
      ]);
    });

    test('세로축 최대값은 가장 큰 합계를 짝수로 올린다', () {
      final result = stats([...memos(5, [], of: s1), ...memos(3, [], of: s2)]);

      expect(result.axisMax, 6);
    });

    test('가장 큰 합계가 짝수면 그대로 세로축 최대값이다', () {
      expect(stats(memos(4, [])).axisMax, 4);
    });

    test('세로축 최대값은 2보다 작지 않다', () {
      final single = [
        memo([forehand], of: s1),
        memo([], of: s2),
      ];

      expect(stats(single, chartTagId: forehand).axisMax, 2);
      expect(stats(single, chartTagId: serve).axisMax, 2);
    });

    test('첫 날짜와 마지막 날짜는 실제 세션의 날짜다', () {
      final result = stats([memo([], of: s3), memo([], of: s1)]);

      expect(result.firstDate, s1.date);
      expect(result.lastDate, s3.date);
    });

    test('메모가 없으면 세션도 날짜도 없다', () {
      final result = stats([]);

      expect(result.sessions, isEmpty);
      expect(result.firstDate, isNull);
      expect(result.lastDate, isNull);
      expect(result.axisMax, 2);
    });

    test('해가 바뀌면 첫 날짜와 바뀌는 날짜에 연도를 붙인다', () {
      expect(
        SearchStats.yearLabels([
          DateTime(2026, 12, 28),
          DateTime(2026, 12, 30),
          DateTime(2027, 1, 3),
          DateTime(2027, 1, 5),
        ]),
        [true, false, true, false],
      );
    });

    test('한 해 안이면 연도를 붙이지 않는다', () {
      expect(
        SearchStats.yearLabels([DateTime(2026, 11, 4), DateTime(2026, 11, 17)]),
        [false, false],
      );
      expect(SearchStats.yearLabels([]), isEmpty);
    });
  });

  group('같이 달린 태그', () {
    test('차트 태그를 빼고 카테고리별로 센다', () {
      final result = stats([
        memo([forehand, shortBall], evaluation: bad),
        memo([forehand, shortBall], evaluation: good),
        memo([forehand, topspin], evaluation: good),
        memo([serve, downTheLine]),
      ], chartTagId: forehand);

      expect(result.relatedTags(), const {
        TagCategory.technique: [
          TagSummaryItem(
            tagId: topspin,
            name: '탑스핀',
            count: 1,
            evaluations: EvaluationCounts(good: 1),
          ),
        ],
        TagCategory.situation: [
          TagSummaryItem(
            tagId: shortBall,
            name: '짧은공',
            count: 2,
            evaluations: EvaluationCounts(good: 1, bad: 1),
          ),
        ],
      });
    });

    test('카테고리 순서는 기술, 폼, 풋워크, 상황, 몸, 컨디션이다', () {
      final result = stats([
        memo([heat, shoulder, shortBall, split, unitTurn, topspin, forehand]),
      ], chartTagId: forehand);

      expect(result.relatedTags().keys, [
        TagCategory.technique,
        TagCategory.form,
        TagCategory.footwork,
        TagCategory.situation,
        TagCategory.body,
        TagCategory.conditionFactor,
      ]);
    });

    test('칩이 없는 카테고리는 뺀다', () {
      final result = stats([
        memo([forehand, heat]),
      ], chartTagId: forehand);

      expect(names(result.relatedTags()), {
        TagCategory.conditionFactor: ['더위'],
      });
    });

    test('카테고리 안은 건수 많은 순, 같으면 이름 순이다', () {
      final result = stats([
        ...memos(2, [forehand, shortBall]),
        ...memos(2, [forehand, downTheLine]),
        ...memos(3, [forehand, judgment]),
      ], chartTagId: forehand);

      expect(names(result.relatedTags()), {
        TagCategory.situation: ['판단', '다운더라인', '짧은공'],
      });
    });

    test('부모를 고르면 자식은 칩으로 나오고 부모로 합산하지 않는다', () {
      final result = stats([
        memo([backVolley, shortBall]),
      ], chartTagId: volley);

      expect(names(result.relatedTags()), {
        TagCategory.technique: ['백발리'],
        TagCategory.situation: ['짧은공'],
      });
    });

    test('같이 달린 태그가 없으면 비어 있다', () {
      final result = stats([
        memo([forehand]),
      ], chartTagId: forehand);

      expect(result.relatedTags(), isEmpty);
    });

    test('칩의 메모는 차트 메모 중 그 태그가 직접 붙은 것이고 최신순이다', () {
      final a = memo([
        forehand,
        shortBall,
      ], of: session(1, DateTime(2026, 10, 3)));
      final b = memo([
        forehand,
        shortBall,
      ], of: session(2, DateTime(2026, 11, 4)));
      final result = stats([
        a,
        b,
        memo([serve, shortBall]),
        memo([forehand]),
      ], chartTagId: forehand);

      expect(result.memosWithTag(shortBall), [b, a]);
    });

    test('칩의 메모에 자손 태그만 붙은 메모는 넣지 않는다', () {
      final direct = memo([forehand, volley]);
      final result = stats([
        direct,
        memo([forehand, backVolley]),
      ], chartTagId: forehand);

      expect(result.memosWithTag(volley), [direct]);
    });
  });

  group('전체 메모에 달린 태그', () {
    final rated = [
      memo([serve], evaluation: good),
      ...memos(3, [serve], evaluation: bad),
      ...memos(2, [forehand], evaluation: good),
      ...memos(2, [forehand], evaluation: bad),
      ...memos(2, [backhand], evaluation: good),
    ];

    List<String> sorted(TagUsageSort sort) {
      return names(stats(rated).usedTags(sort))[TagCategory.technique]!;
    }

    test('기술, 폼, 상황만 이 순서로 보여준다', () {
      final result = stats([
        memo([shortBall, forehand, unitTurn, split, shoulder, heat]),
      ]);
      final groups = result.usedTags(TagUsageSort.count);

      expect(groups.keys, [
        TagCategory.technique,
        TagCategory.form,
        TagCategory.situation,
      ]);
      expect(names(groups), {
        TagCategory.technique: ['포핸드'],
        TagCategory.form: ['유닛턴'],
        TagCategory.situation: ['짧은공'],
      });
    });

    test('기술, 폼, 상황 태그가 없으면 비어 있다', () {
      final result = stats([
        memo([split, heat]),
      ]);

      expect(result.usedTags(TagUsageSort.count), isEmpty);
    });

    test('부모로 합산하지 않는다', () {
      final result = stats([
        memo([backVolley]),
      ]);

      expect(names(result.usedTags(TagUsageSort.count)), {
        TagCategory.technique: ['백발리'],
      });
    });

    test('많이 쓴 순은 메모 수, 이름 순이다', () {
      expect(sorted(TagUsageSort.count), ['서브', '포핸드', '백핸드']);
    });

    test('잘함 순은 잘함 수, 메모 수 순이다', () {
      expect(sorted(TagUsageSort.good), ['포핸드', '백핸드', '서브']);
    });

    test('못함 순은 못함 수 순이고 0인 칩도 남는다', () {
      expect(sorted(TagUsageSort.bad), ['서브', '포핸드', '백핸드']);
    });

    test('기준 값과 메모 수가 같으면 이름 순이다', () {
      final result = stats([
        memo([serve], evaluation: good),
        memo([backhand], evaluation: good),
      ]);

      expect(names(result.usedTags(TagUsageSort.good)), {
        TagCategory.technique: ['백핸드', '서브'],
      });
    });

    test('차트 태그가 없으면 칩의 메모는 전체 메모에서 고른다', () {
      final older = memo([shortBall], of: s1);
      final newer = memo([serve, shortBall], of: s2);
      final result = stats([
        older,
        newer,
        memo([serve]),
      ]);

      expect(result.memosWithTag(shortBall), [newer, older]);
    });
  });
}
