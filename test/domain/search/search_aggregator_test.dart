import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/search/search_aggregator.dart';
import 'package:tennis_log/domain/search/search_models.dart';
import 'package:tennis_log/domain/search/tag_hierarchy.dart';

void main() {
  const serve = 1;
  const doubleFault = 2;
  const volley = 3;
  const backVolley = 4;
  const return_ = 5;
  const openBody = 6;

  final hierarchy = TagHierarchy(const [
    SearchTag(id: serve, name: '서브', category: TagCategory.technique),
    SearchTag(id: doubleFault, name: '더블폴트', category: TagCategory.technique),
    SearchTag(id: volley, name: '발리', category: TagCategory.technique),
    SearchTag(
      id: backVolley,
      name: '백발리',
      category: TagCategory.technique,
      parentTagId: volley,
    ),
    SearchTag(id: return_, name: '리턴', category: TagCategory.technique),
    SearchTag(id: openBody, name: '몸열림', category: TagCategory.form),
  ]);

  var nextId = 1;

  SearchMemo memo(
    List<int> tagIds, {
    MemoEvaluation evaluation = MemoEvaluation.none,
    SearchSession? session,
    int orderIndex = 0,
  }) {
    final id = nextId++;
    return SearchMemo(
      id: id,
      content: '메모 $id',
      orderIndex: orderIndex,
      evaluation: evaluation,
      session:
          session ??
          SearchSession(
            id: 1,
            date: DateTime(2026, 10, 1),
            sessionType: SessionType.game,
          ),
      tagIds: tagIds,
    );
  }

  List<SearchMemo> memos(
    int count,
    List<int> tagIds, {
    MemoEvaluation evaluation = MemoEvaluation.none,
  }) {
    return [
      for (var i = 0; i < count; i++) memo(tagIds, evaluation: evaluation),
    ];
  }

  group('요약줄', () {
    test('태그별 건수와 평가별 건수를 세고 건수 많은 순으로 놓는다', () {
      final items = SearchAggregator.summarize([
        memo([serve], evaluation: MemoEvaluation.bad),
        memo([serve, doubleFault], evaluation: MemoEvaluation.bad),
        memo([serve], evaluation: MemoEvaluation.good),
      ], hierarchy);

      expect(items.map((item) => item.name), ['서브', '더블폴트']);
      expect(items[0].count, 3);
      expect(items[0].evaluations, const EvaluationCounts(good: 1, bad: 2));
      expect(items[1].count, 1);
      expect(items[1].evaluations, const EvaluationCounts(bad: 1));
    });

    test('부모로 합산하지 않는다', () {
      final items = SearchAggregator.summarize([
        memo([backVolley]),
      ], hierarchy);

      expect(items.map((item) => item.name), ['백발리']);
      expect(items.single.count, 1);
    });

    test('건수가 같으면 이름 순이다', () {
      final items = SearchAggregator.summarize([
        memo([serve]),
        memo([doubleFault]),
      ], hierarchy);

      expect(items.map((item) => item.name), ['더블폴트', '서브']);
    });

    test('평가별 건수의 합은 태그의 건수와 같다', () {
      final items = SearchAggregator.summarize([
        memo([serve], evaluation: MemoEvaluation.good),
        memo([serve], evaluation: MemoEvaluation.question),
        memo([serve]),
      ], hierarchy);

      final counts = items.single.evaluations;
      expect(
        counts.good + counts.bad + counts.question + counts.none,
        items.single.count,
      );
    });

    test('좁혀 보기는 고른 태그 중 하나라도 직접 붙은 메모만 남긴다', () {
      final serveMemo = memo([serve]);
      final faultMemo = memo([doubleFault]);
      final volleyMemo = memo([backVolley]);
      final memos = [serveMemo, faultMemo, volleyMemo];

      expect(SearchAggregator.narrowByTags(memos, {serve, doubleFault}), [
        serveMemo,
        faultMemo,
      ]);
    });

    test('좁혀 보기가 비어 있으면 그대로다', () {
      final memos = [
        memo([serve]),
      ];

      expect(SearchAggregator.narrowByTags(memos, const {}), memos);
    });

    test('어떤 메모에도 없는 태그로는 목록을 비우지 않는다', () {
      final memos = [
        memo([serve]),
      ];

      expect(SearchAggregator.narrowByTags(memos, {doubleFault}), memos);
    });
  });

  group('태그 통계', () {
    test('부모 행은 같은 메모를 한 번만 세고 직접 건수를 따로 둔다', () {
      final rows = SearchAggregator.tagStats([
        memo([volley]),
        memo([backVolley]),
        memo([volley, backVolley]),
      ], hierarchy);

      final parent = rows.single;
      expect(parent.name, '발리');
      expect(parent.count, 3);
      expect(parent.directCount, 2);
      expect(parent.children.single.name, '백발리');
      expect(parent.children.single.count, 2);
    });

    test('부모의 평가별 건수도 같은 메모 집합으로 센다', () {
      final rows = SearchAggregator.tagStats([
        memo([volley, backVolley], evaluation: MemoEvaluation.bad),
        memo([backVolley], evaluation: MemoEvaluation.good),
      ], hierarchy);

      expect(rows.single.evaluations, const EvaluationCounts(good: 1, bad: 1));
    });

    test('자식만 등장해도 부모 행이 나온다', () {
      final rows = SearchAggregator.tagStats([
        memo([backVolley]),
      ], hierarchy);

      final parent = rows.single;
      expect(parent.name, '발리');
      expect(parent.count, 1);
      expect(parent.directCount, 0);
      expect(parent.children.single.name, '백발리');
      expect(parent.children.single.count, 1);
    });

    test('등장하지 않은 태그는 나오지 않고, 자식이 없으면 children이 비어 있다', () {
      final rows = SearchAggregator.tagStats([
        memo([volley]),
      ], hierarchy);

      expect(rows.map((row) => row.name), ['발리']);
      expect(rows.single.children, isEmpty);
    });

    test('카테고리는 최상위 태그로 거른다', () {
      final rows = SearchAggregator.tagStats(
        [
          memo([serve]),
          memo([openBody]),
        ],
        hierarchy,
        category: TagCategory.technique,
      );

      expect(rows.map((row) => row.name), ['서브']);
    });

    test('못함순은 못함 건수, 총 건수 순이다', () {
      final rows = SearchAggregator.tagStats(
        [
          ...memos(3, [serve], evaluation: MemoEvaluation.bad),
          ...memos(7, [serve]),
          ...memos(3, [return_], evaluation: MemoEvaluation.bad),
          ...memos(2, [return_]),
          ...memos(1, [volley], evaluation: MemoEvaluation.bad),
        ],
        hierarchy,
        sort: TagStatSort.bad,
      );

      expect(rows.map((row) => row.name), ['서브', '리턴', '발리']);
    });

    test('기준 값과 총 건수가 같으면 이름 순이다', () {
      final rows = SearchAggregator.tagStats([
        memo([serve]),
        memo([return_]),
      ], hierarchy);

      expect(rows.map((row) => row.name), ['리턴', '서브']);
    });

    test('자식 행도 같은 정렬을 따른다', () {
      final frontVolley = TagHierarchy([
        ...hierarchy.tags,
        const SearchTag(
          id: 7,
          name: '포발리',
          category: TagCategory.technique,
          parentTagId: volley,
        ),
      ]);

      final rows = SearchAggregator.tagStats(
        [
          ...memos(3, [backVolley]),
          ...memos(1, [7], evaluation: MemoEvaluation.good),
        ],
        frontVolley,
        sort: TagStatSort.good,
      );

      expect(rows.single.children.map((row) => row.name), ['포발리', '백발리']);
    });
  });

  group('메모 정렬', () {
    final x = SearchSession(
      id: 1,
      date: DateTime(2026, 10, 12),
      sessionType: SessionType.game,
    );
    final y = SearchSession(
      id: 2,
      date: DateTime(2026, 10, 13),
      sessionType: SessionType.game,
    );
    final x0 = memo([], session: x, orderIndex: 0);
    final x1 = memo([], session: x, orderIndex: 1);
    final y0 = memo([], session: y, orderIndex: 0);

    test('최신순: 세션은 최근부터, 세션 안은 쓴 순서', () {
      expect(SearchAggregator.sortMemos([x1, x0, y0], MemoSort.newest), [
        y0,
        x0,
        x1,
      ]);
    });

    test('오래된순: 세션은 오래된 것부터, 세션 안은 쓴 순서', () {
      expect(SearchAggregator.sortMemos([y0, x1, x0], MemoSort.oldest), [
        x0,
        x1,
        y0,
      ]);
    });

    test('같은 날이면 시작 시각, 그다음 세션 id로 정렬한다', () {
      final date = DateTime(2026, 10, 12);
      SearchMemo at(int sessionId, int? startMinutes) {
        return memo(
          [],
          session: SearchSession(
            id: sessionId,
            date: date,
            startMinutes: startMinutes,
            sessionType: SessionType.game,
          ),
        );
      }

      final morning = at(3, 600);
      final eveningFirst = at(1, 1200);
      final eveningSecond = at(2, 1200);

      expect(
        SearchAggregator.sortMemos([
          morning,
          eveningFirst,
          eveningSecond,
        ], MemoSort.newest),
        [eveningSecond, eveningFirst, morning],
      );
    });
  });
}
