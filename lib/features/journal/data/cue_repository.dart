import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/enums.dart';
import '../domain/cue_summary.dart';

part 'cue_repository.g.dart';

/// 큐 읽기·쓰기.
///
/// 사용 횟수와 최근 적용 결과는 cues에 저장하지 않고 sessions에서 계산한다.
class CueRepository {
  CueRepository(this._db);

  final AppDatabase _db;

  /// 큐 텍스트 정규화: 앞뒤 공백 제거, 연속 공백(줄바꿈·탭 포함)을 하나로.
  ///
  /// 같은 큐를 재사용할 수 있게 하는 핵심이라 저장 전에 **항상** 거쳐야 한다.
  static String normalize(String raw) {
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// 입력칸 아래에 보여줄 "지난 큐". 가장 최근에 쓴 큐 하나.
  /// 과거 큐가 없으면 null(화면에서 숨긴다).
  Future<Cue?> mostRecent() {
    return (_db.select(_db.cues)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastUsedAt),
            (t) => OrderingTerm.desc(t.id),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Cue?> findById(int id) {
    return (_db.select(_db.cues)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 정규화한 텍스트로 큐를 찾는다. **없으면 만들지 않는다.**
  ///
  /// 자동 저장에서 쓴다. 타이핑 중간값("백", "백스")으로 큐 행이 쌓이면 안 되므로
  /// 자동 저장은 이미 있는 큐와 일치할 때만 cueId를 연결하고, 새 큐를 만드는 건
  /// 저장 버튼(= [findOrCreate])에서만 한다.
  Future<Cue?> findByText(String rawText) async {
    final text = normalize(rawText);
    if (text.isEmpty) return null;

    return (_db.select(_db.cues)
          ..where((t) => t.cueText.equals(text))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 정규화한 텍스트로 큐를 찾고, 없으면 만든다.
  ///
  /// 빈 문자열이면 null을 돌려준다(큐 없이 저장하는 경우).
  Future<Cue?> findOrCreate(String rawText) async {
    final text = normalize(rawText);
    if (text.isEmpty) return null;

    final existing =
        await (_db.select(_db.cues)
              ..where((t) => t.cueText.equals(text))
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing;

    return _db
        .into(_db.cues)
        .insertReturning(CuesCompanion.insert(cueText: text));
  }

  /// 최근 사용 순 정렬을 갱신한다. 세션을 저장할 때 호출한다.
  Future<void> touch(int id, {DateTime? at}) async {
    await (_db.update(_db.cues)..where((t) => t.id.equals(id))).write(
      CuesCompanion(lastUsedAt: Value(at ?? DateTime.now())),
    );
  }

  /// "지난 큐 불러오기" 시트의 목록.
  ///
  /// [query]가 비어 있으면 전체를, 아니면 부분 일치하는 것만 돌려준다.
  /// 사용 횟수·최근 사용 날짜·최근 적용 결과를 sessions에서 집계한다.
  Stream<List<CueSummary>> watchSummaries({String query = ''}) {
    final trimmed = query.trim();

    // 집계와 "가장 최근 세션의 적용 결과"를 한 번에 가져와야 해서 직접 SQL을 쓴다.
    // (drift의 쿼리 빌더로는 상관 서브쿼리를 쓰기 번거롭다.)
    //
    // date는 ISO-8601 텍스트로 저장되므로 MAX와 ORDER BY가 문자열 비교가 된다.
    // 한국은 DST가 없어 UTC 오프셋이 항상 +09:00으로 같아서 시간 순서와 일치한다.
    return _db
        .customSelect(
          '''
SELECT
  c.id             AS id,
  c.text           AS text,
  MAX(s.date)      AS last_used_date,
  COUNT(s.id)      AS use_count,
  (SELECT s2.cue_applied
     FROM sessions s2
    WHERE s2.cue_id = c.id AND s2.cue_applied IS NOT NULL
    ORDER BY s2.date DESC, s2.id DESC
    LIMIT 1)       AS latest_applied
FROM cues c
LEFT JOIN sessions s ON s.cue_id = c.id
WHERE ? = '' OR c.text LIKE '%' || ? || '%'
GROUP BY c.id, c.text
ORDER BY c.last_used_at DESC, c.id DESC
''',
          variables: [Variable<String>(trimmed), Variable<String>(trimmed)],
          readsFrom: {_db.cues, _db.sessions},
        )
        .map((row) {
          final applied = row.readNullable<String>('latest_applied');
          return CueSummary(
            id: row.read<int>('id'),
            text: row.read<String>('text'),
            lastUsedDate: row.readNullable<DateTime>('last_used_date'),
            useCount: row.read<int>('use_count'),
            latestApplied: applied == null
                ? null
                : CueApplied.values.byName(applied),
          );
        })
        .watch();
  }
}

@riverpod
CueRepository cueRepository(Ref ref) {
  return CueRepository(ref.watch(appDatabaseProvider));
}
