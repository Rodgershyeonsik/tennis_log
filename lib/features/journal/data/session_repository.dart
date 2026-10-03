import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/enums.dart';
import '../domain/draft_summary.dart';
import '../domain/session_draft.dart';
import '../domain/session_time_range.dart';

part 'session_repository.g.dart';

/// 세션(일지) 읽기·쓰기.
class SessionRepository {
  SessionRepository(this._db);

  final AppDatabase _db;

  /// 날짜만 의미가 있는 값이라 로컬 자정으로 자른다.
  /// 이 정규화를 빠뜨리면 같은 날짜가 시각 차이로 다르게 저장된다.
  static DateTime dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  // ------------------------------------------------------------ 메인 화면

  /// 작성 중(draft)인 일지 목록. 최근 것부터.
  Stream<List<DraftSummary>> watchDrafts() {
    final query =
        _db.select(_db.sessions).join([
            leftOuterJoin(
              _db.places,
              _db.places.id.equalsExp(_db.sessions.placeId),
            ),
          ])
          ..where(_db.sessions.status.equalsValue(SessionStatus.draft))
          ..orderBy([
            OrderingTerm.desc(_db.sessions.updatedAt),
            OrderingTerm.desc(_db.sessions.id),
          ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final session = row.readTable(_db.sessions);
        final place = row.readTableOrNull(_db.places);
        return DraftSummary(
          id: session.id,
          date: session.date,
          // draft는 아직 저장 버튼을 안 눌렀을 수 있어 스냅샷이 비어 있다.
          // 그럴 때는 현재 장소 이름을 쓴다.
          placeName: session.placeNameSnapshot ?? place?.name,
          updatedAt: session.updatedAt,
        );
      }).toList();
    });
  }

  // -------------------------------------------------------------- 작성 화면

  /// 첫 값이 바뀌는 순간 호출한다. draft 세션을 만들고 id를 돌려준다.
  Future<int> createDraft(SessionDraft draft) {
    return _db.into(_db.sessions).insert(_toCompanion(draft));
  }

  /// 자동 저장. 필수값 검사 없이 덮어쓴다.
  Future<void> saveDraft(int sessionId, SessionDraft draft) async {
    await (_db.update(
      _db.sessions,
    )..where((t) => t.id.equals(sessionId))).write(_toCompanion(draft));
  }

  /// 이어쓰기로 들어왔을 때 편집 상태를 복원한다.
  Future<SessionDraft?> loadDraft(int sessionId) async {
    final session = await findById(sessionId);
    if (session == null) return null;

    return SessionDraft(
      sessionType: session.sessionType,
      date: session.date,
      startMinutes: session.startMinutes,
      endMinutes: session.endMinutes,
      placeId: session.placeId,
      conditionScore: session.conditionScore,
      lastMealBucket: session.lastMealBucket,
      cueId: session.cueId,
      cueApplied: session.cueApplied,
    );
  }

  Future<Session?> findById(int sessionId) {
    return (_db.select(_db.sessions)
          ..where((t) => t.id.equals(sessionId))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<Session?> watchById(int sessionId) {
    return (_db.select(_db.sessions)
          ..where((t) => t.id.equals(sessionId))
          ..limit(1))
        .watchSingleOrNull();
  }

  // ------------------------------------------------------------ 시간 기본값

  /// 시간 입력의 기본값으로 쓸 "가장 최근 세션의 시작~종료".
  /// 과거 세션이 없으면 null (화면이 18:00~20:00을 쓴다).
  Future<SessionTimeRange?> latestTimeRange() async {
    final session =
        await (_db.select(_db.sessions)
              ..where(
                (t) => t.startMinutes.isNotNull() & t.endMinutes.isNotNull(),
              )
              ..orderBy([
                (t) => OrderingTerm.desc(t.date),
                (t) => OrderingTerm.desc(t.id),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (session == null) return null;
    return SessionTimeRange(
      startMinutes: session.startMinutes!,
      endMinutes: session.endMinutes!,
    );
  }

  /// 시간 시트 위쪽의 "자주 쓴 시간" 칩. 가장 많이 쓴 시작~종료 조합 순이다.
  /// 횟수가 같으면 최근에 쓴 조합을 먼저 보여준다.
  Future<List<SessionTimeRange>> frequentTimeRanges({int limit = 3}) {
    return _db
        .customSelect(
          '''
SELECT start_minutes, end_minutes
FROM sessions
WHERE start_minutes IS NOT NULL AND end_minutes IS NOT NULL
GROUP BY start_minutes, end_minutes
ORDER BY COUNT(*) DESC, MAX(date) DESC
LIMIT ?
''',
          variables: [Variable<int>(limit)],
          readsFrom: {_db.sessions},
        )
        .map(
          (row) => SessionTimeRange(
            startMinutes: row.read<int>('start_minutes'),
            endMinutes: row.read<int>('end_minutes'),
          ),
        )
        .get();
  }

  // ------------------------------------------------------------- 저장 버튼

  /// 저장 버튼을 눌렀을 때의 마무리 작업.
  ///
  /// 1. 장소 스냅샷(이름, 표면, 실내외)을 세션에 복사한다.
  /// 2. 메모가 1개 이상이면 status = complete, 없으면 draft 유지.
  /// 3. 장소와 큐의 lastUsedAt을 갱신해서 "최근 사용 순"에 반영한다.
  ///
  /// 필수값 검사(날짜, 장소)는 하지 않는다 — 명세상 화면에서 인라인 오류로
  /// 처리하는 일이다. 장소가 없으면 스냅샷은 비워 둔다.
  Future<Session> finalizeSession(int sessionId) async {
    return _db.transaction(() async {
      final session = await findById(sessionId);
      if (session == null) {
        throw StateError('세션 $sessionId 이 없다.');
      }

      final now = DateTime.now();
      var patch = SessionsCompanion(updatedAt: Value(now));

      final placeId = session.placeId;
      if (placeId != null) {
        final place =
            await (_db.select(_db.places)
                  ..where((t) => t.id.equals(placeId))
                  ..limit(1))
                .getSingleOrNull();
        if (place != null) {
          patch = patch.copyWith(
            placeNameSnapshot: Value(place.name),
            surfaceSnapshot: Value(place.surface),
            isIndoorSnapshot: Value(place.isIndoor),
          );
          await (_db.update(_db.places)..where((t) => t.id.equals(placeId)))
              .write(PlacesCompanion(lastUsedAt: Value(now)));
        }
      }

      final memoCount = _db.memos.id.count();
      final memos =
          await (_db.selectOnly(_db.memos)
                ..addColumns([memoCount])
                ..where(_db.memos.sessionId.equals(sessionId)))
              .map((row) => row.read(memoCount)!)
              .getSingle();
      if (memos > 0) {
        patch = patch.copyWith(status: const Value(SessionStatus.complete));
      }

      final cueId = session.cueId;
      if (cueId != null) {
        await (_db.update(_db.cues)..where((t) => t.id.equals(cueId))).write(
          CuesCompanion(lastUsedAt: Value(now)),
        );
      }

      await (_db.update(
        _db.sessions,
      )..where((t) => t.id.equals(sessionId))).write(patch);

      return (await findById(sessionId))!;
    });
  }

  /// 태그 확인(2단계)의 완료 버튼.
  Future<void> markTagReviewed(int sessionId) async {
    await (_db.update(
      _db.sessions,
    )..where((t) => t.id.equals(sessionId))).write(
      SessionsCompanion(
        tagReviewed: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  SessionsCompanion _toCompanion(SessionDraft draft) {
    return SessionsCompanion(
      sessionType: Value(draft.sessionType),
      date: Value(dateOnly(draft.date)),
      startMinutes: Value(draft.startMinutes),
      endMinutes: Value(draft.endMinutes),
      placeId: Value(draft.placeId),
      conditionScore: Value(draft.conditionScore),
      lastMealBucket: Value(draft.lastMealBucket),
      cueId: Value(draft.cueId),
      cueApplied: Value(draft.cueApplied),
      updatedAt: Value(DateTime.now()),
    );
  }
}

@riverpod
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(ref.watch(appDatabaseProvider));
}
