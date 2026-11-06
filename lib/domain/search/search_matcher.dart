import 'search_filter.dart';
import 'search_models.dart';
import 'search_period.dart';
import 'tag_hierarchy.dart';

/// 조회 조건을 세션과 메모에 적용한다.
abstract final class SearchMatcher {
  /// [memos] 중 [filter]에 맞는 메모. [sessions]는 조회 대상 세션 전체다.
  ///
  /// 순서는 세션 단위 필터, 범위, 메모 단위 필터다. 최근 N세션은 세션 단위
  /// 필터를 거친 세션에서 고르고, 메모 단위 필터는 그 세션들의 메모 안에서만
  /// 적용한다. 메모가 걸러져도 세션을 더 찾아 내려가지 않는다.
  static List<SearchMemo> apply({
    required SearchFilter filter,
    required List<SearchSession> sessions,
    required List<SearchMemo> memos,
    required TagHierarchy hierarchy,
    required DateTime today,
  }) {
    final matched = sessions.where((s) => matchesSession(filter, s)).toList();
    final sessionIds = {
      for (final session in _inScope(filter.scope, matched, today)) session.id,
    };
    final tagGroups = expandTags(filter.tagIds, hierarchy);

    return memos.where((memo) {
      return sessionIds.contains(memo.session.id) &&
          matchesMemo(filter, memo, tagGroups);
    }).toList();
  }

  static List<SearchSession> _inScope(
    SearchScope scope,
    List<SearchSession> sessions,
    DateTime today,
  ) {
    if (scope case SearchScopeRecentSessions(:final count)) {
      return pickRecent(sessions, count);
    }

    final range = SearchPeriod.rangeOf(scope, today);
    if (range == null) return sessions;
    return sessions.where((s) => range.contains(s.date)).toList();
  }

  /// 세션 단위 필터(세션 유형, 장소, 컨디션, 큐 적용). 범위는 보지 않는다.
  static bool matchesSession(SearchFilter filter, SearchSession session) {
    return _allows(filter.sessionTypes, session.sessionType) &&
        _allows(filter.surfaces, session.surfaceSnapshot) &&
        _allows(filter.indoorOptions, session.isIndoorSnapshot) &&
        _allows(filter.placeIds, session.placeId) &&
        _allows(filter.conditionScores, session.conditionScore) &&
        _allows(filter.cueApplied, session.cueApplied);
  }

  /// 메모 단위 필터(평가, 태그). [tagGroups]는 [expandTags]의 결과다.
  static bool matchesMemo(
    SearchFilter filter,
    SearchMemo memo,
    List<Set<int>> tagGroups,
  ) {
    if (!_allows(filter.evaluations, memo.evaluation)) return false;
    if (tagGroups.isEmpty) return true;

    bool hasTagOf(Set<int> group) => memo.tagIds.any(group.contains);
    return switch (filter.tagMatch) {
      TagMatchMode.any => tagGroups.any(hasTagOf),
      TagMatchMode.all => tagGroups.every(hasTagOf),
    };
  }

  /// 고른 태그마다 그 태그와 자손의 id를 묶는다.
  static List<Set<int>> expandTags(Set<int> tagIds, TagHierarchy hierarchy) {
    return [for (final id in tagIds) hierarchy.withDescendants(id)];
  }

  /// 최신순으로 [count]개를 고른다.
  static List<SearchSession> pickRecent(
    List<SearchSession> sessions,
    int count,
  ) {
    final sorted = [...sessions]..sort(compareSessionsNewestFirst);
    return sorted.take(count).toList();
  }

  /// 빈 집합은 제한 없음이다.
  static bool _allows<T>(Set<T> allowed, T value) {
    return allowed.isEmpty || allowed.contains(value);
  }
}
