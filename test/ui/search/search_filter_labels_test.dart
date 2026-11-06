import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/search/search_filter.dart';
import 'package:tennis_log/ui/search/search_filter_labels.dart';

void main() {
  group('범위 칩', () {
    test('범위별 표기', () {
      expect(searchScopeLabel(const SearchScope.all()), '전체');
      expect(
        searchScopeLabel(const SearchScope.preset(PeriodPreset.threeMonths)),
        '최근 3개월',
      );
      expect(
        searchScopeLabel(const SearchScope.preset(PeriodPreset.thisYear)),
        '올해',
      );
      expect(searchScopeLabel(const SearchScope.recentSessions(10)), '최근 10세션');
      expect(
        searchScopeLabel(
          SearchScope.custom(
            start: DateTime(2026, 7, 1),
            end: DateTime(2026, 9, 30),
          ),
        ),
        '26/7/1 – 26/9/30',
      );
    });
  });

  group('필터 시트 맨 위 칩', () {
    List<ActiveFilter> activeOf(SearchFilter filter) {
      return activeFilters(filter, placeName: (id) => '장소 $id');
    }

    test('기본값이면 칩이 없다', () {
      expect(activeOf(const SearchFilter()), isEmpty);
    });

    test('필터 시트의 순서대로 나오고 태그는 빠진다', () {
      const filter = SearchFilter(
        cueApplied: {null},
        conditionScores: {3},
        placeIds: {7},
        indoorOptions: {true},
        surfaces: {SurfaceType.clay},
        sessionTypes: {SessionType.game},
        tagIds: {1},
        evaluations: {MemoEvaluation.none, MemoEvaluation.bad},
        scope: SearchScope.recentSessions(5),
      );

      expect(activeOf(filter).map((item) => item.label), [
        '최근 5세션',
        'bad',
        'none',
        '게임',
        '클레이',
        '실내',
        '장소 7',
        '컨디션 굿',
        '큐 기록 없음',
      ]);
    });

    test('칩을 빼면 그 값만 빠진다', () {
      const filter = SearchFilter(
        evaluations: {MemoEvaluation.good, MemoEvaluation.bad},
        surfaces: {SurfaceType.clay},
      );

      expect(
        activeOf(filter).first.removed,
        const SearchFilter(
          evaluations: {MemoEvaluation.bad},
          surfaces: {SurfaceType.clay},
        ),
      );
    });

    test('범위 칩을 빼면 전체로 돌아간다', () {
      const filter = SearchFilter(scope: SearchScope.recentSessions(5));

      expect(activeOf(filter).single.removed, const SearchFilter());
    });
  });

  group('태그 버튼', () {
    test('고른 태그 수에 따른 표기', () {
      expect(tagFilterLabel(const []), '태그');
      expect(tagFilterLabel(const ['서브']), '태그: 서브');
      expect(tagFilterLabel(const ['서브', '리턴']), '태그: 서브, 리턴');
      expect(tagFilterLabel(const ['서브', '리턴', '발리']), '태그: 서브, 리턴 외 1');
    });
  });

  group('걸린 필터 개수', () {
    test('기본값이면 0이다', () {
      expect(activeFilterCount(const SearchFilter()), 0);
    });

    test('범위는 세지 않는다', () {
      expect(
        activeFilterCount(
          const SearchFilter(scope: SearchScope.recentSessions(5)),
        ),
        0,
      );
    });

    test('모든 그룹의 고른 값을 더한다', () {
      const filter = SearchFilter(
        evaluations: {MemoEvaluation.good, MemoEvaluation.bad},
        sessionTypes: {SessionType.game},
        surfaces: {SurfaceType.clay},
        indoorOptions: {true},
        placeIds: {7},
        conditionScores: {null},
        cueApplied: {null},
      );

      expect(activeFilterCount(filter), 8);
    });

    test('태그는 세지 않는다', () {
      expect(activeFilterCount(const SearchFilter(tagIds: {1, 2})), 0);
    });
  });
}
