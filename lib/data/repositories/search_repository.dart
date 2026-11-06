import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../db/enums.dart';
import '../../domain/search/search_filter.dart';
import '../../domain/search/search_matcher.dart';
import '../../domain/search/search_models.dart';
import '../../domain/search/search_period.dart';
import '../../domain/search/tag_hierarchy.dart';

part 'search_repository.g.dart';

/// 조회 화면의 읽기 전용 쿼리.
///
/// SQL은 조회 대상과 확정 태그까지만 거르고, 필터는 [SearchMatcher]가 Dart로
/// 적용한다. 개인 일지 규모라 한 번에 읽어도 충분하고, 최근 N세션과 자손 태그
/// 규칙을 순수 함수로 테스트할 수 있다.
class SearchRepository {
  SearchRepository(this._db);

  final AppDatabase _db;

  /// [filter]에 맞는 메모. 순서는 정해져 있지 않다(`SearchAggregator.sortMemos`).
  ///
  /// [today]를 주지 않으면 다시 읽을 때마다 현재 날짜를 쓴다.
  Stream<List<SearchMemo>> watchMemos(SearchFilter filter, {DateTime? today}) {
    return _watch({_db.sessions, _db.memos, _db.memoTags, _db.tags}, () async {
      final (:sessions, :memos) = await _loadTargets();
      return SearchMatcher.apply(
        filter: filter,
        sessions: sessions,
        memos: memos,
        hierarchy: TagHierarchy(await _loadTags()),
        today: today ?? DateTime.now(),
      );
    });
  }

  /// 메모가 1개 이상 있지만 조회 대상이 아닌 세션 수.
  ///
  /// 범위가 기간이면 그 기간 안에서, 그 밖이면 전체에서 센다.
  Stream<int> watchExcludedSessionCount(SearchScope scope, {DateTime? today}) {
    return _watch({_db.sessions, _db.memos}, () async {
      final query =
          _db.select(_db.sessions).join([
              innerJoin(
                _db.memos,
                _db.memos.sessionId.equalsExp(_db.sessions.id),
              ),
            ])
            ..where(_isTarget.not())
            // 메모 조인 때문에 세션이 메모 수만큼 늘어나므로 다시 묶는다.
            ..groupBy([_db.sessions.id]);

      final rows = await query.get();
      final range = SearchPeriod.rangeOf(scope, today ?? DateTime.now());
      if (range == null) return rows.length;
      return rows
          .where((row) => range.contains(row.readTable(_db.sessions).date))
          .length;
    });
  }

  /// 태그 사전 전체. 보관된 태그도 담는다.
  Stream<List<SearchTag>> watchTags() {
    return _watch({_db.tags}, _loadTags);
  }

  /// [tables]가 바뀔 때마다 [load]를 다시 돌린다.
  ///
  /// 쿼리 여러 개의 결과를 합쳐야 해서 쿼리 하나의 watch로는 부족하다.
  /// `SELECT 1`은 처음 한 번과 변경 때마다 신호를 받기 위한 것이다.
  Stream<T> _watch<T>(
    Set<ResultSetImplementation<dynamic, dynamic>> tables,
    Future<T> Function() load,
  ) {
    return _db
        .customSelect('SELECT 1', readsFrom: tables)
        .watch()
        .asyncMap((_) => load());
  }

  Expression<bool> get _isTarget {
    return _db.sessions.status.equalsValue(SessionStatus.complete) &
        _db.sessions.tagReviewed.equals(true);
  }

  /// 조회 대상 세션 전체와 그 메모.
  ///
  /// 메모가 없는 세션도 최근 N세션의 한 자리를 차지하므로 left join으로 읽는다.
  Future<({List<SearchSession> sessions, List<SearchMemo> memos})>
  _loadTargets() async {
    final query =
        _db.select(_db.sessions).join([
            leftOuterJoin(
              _db.memos,
              _db.memos.sessionId.equalsExp(_db.sessions.id),
            ),
            leftOuterJoin(
              _db.memoTags,
              _db.memoTags.memoId.equalsExp(_db.memos.id) &
                  _db.memoTags.status.equalsValue(MemoTagStatus.confirmed),
            ),
          ])
          ..where(_isTarget)
          ..orderBy([OrderingTerm.asc(_db.memoTags.tagId)]);

    final rows = await query.get();

    final sessions = <int, SearchSession>{};
    final memos = <int, Memo>{};
    final tagIds = <int, List<int>>{};
    for (final row in rows) {
      final session = row.readTable(_db.sessions);
      sessions[session.id] ??= _toSearchSession(session);

      final memo = row.readTableOrNull(_db.memos);
      if (memo == null) continue;
      memos[memo.id] = memo;

      final tagList = tagIds.putIfAbsent(memo.id, () => []);
      final memoTag = row.readTableOrNull(_db.memoTags);
      if (memoTag != null) tagList.add(memoTag.tagId);
    }

    return (
      sessions: sessions.values.toList(),
      memos: [
        for (final memo in memos.values)
          SearchMemo(
            id: memo.id,
            content: memo.content,
            orderIndex: memo.orderIndex,
            evaluation: memo.evaluationStatus == EvaluationStatus.confirmed
                ? memo.evaluation
                : null,
            session: sessions[memo.sessionId]!,
            tagIds: tagIds[memo.id]!,
          ),
      ],
    );
  }

  Future<List<SearchTag>> _loadTags() async {
    final tags = await _db.select(_db.tags).get();
    return [
      for (final tag in tags)
        SearchTag(
          id: tag.id,
          name: tag.name,
          category: tag.category,
          parentTagId: tag.parentTagId,
          isArchived: tag.isArchived,
        ),
    ];
  }

  SearchSession _toSearchSession(Session session) {
    return SearchSession(
      id: session.id,
      date: session.date,
      startMinutes: session.startMinutes,
      placeNameSnapshot: session.placeNameSnapshot,
      sessionType: session.sessionType,
      surfaceSnapshot: session.surfaceSnapshot,
      isIndoorSnapshot: session.isIndoorSnapshot,
      placeId: session.placeId,
      conditionScore: session.conditionScore,
      cueApplied: session.cueApplied,
    );
  }
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepository(ref.watch(appDatabaseProvider));
}
