import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../db/enums.dart';

part 'place_repository.g.dart';

/// 장소 읽기·쓰기. 장소 하나 = 코트 하나다.
///
/// 수정과 삭제는 아직 만들지 않는다(명세 1번 "구현하지 않을 것").
class PlaceRepository {
  PlaceRepository(this._db);

  final AppDatabase _db;

  /// 작성 화면의 장소 칩. 최근 사용 순이다.
  Stream<List<Place>> watchRecent({int limit = 4}) {
    return (_db.select(_db.places)
          ..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)])
          ..limit(limit))
        .watch();
  }

  /// 장소 더보기 시트의 목록. **이름 오름차순**이고, [query]가 있으면 이름에
  /// 그 말이 들어간 장소만 남긴다.
  Stream<List<Place>> watchByName({String query = ''}) {
    final trimmed = query.trim();
    final select = _db.select(_db.places)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    if (trimmed.isNotEmpty) {
      select.where((t) => t.name.contains(trimmed));
    }
    return select.watch();
  }

  Future<Place?> findById(int id) {
    return (_db.select(_db.places)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 하단 시트에서 장소를 등록한다. 등록하면 바로 선택되므로 행을 돌려준다.
  Future<Place> create({
    required String name,
    required SurfaceType surface,
    required bool isIndoor,
  }) {
    return _db
        .into(_db.places)
        .insertReturning(
          PlacesCompanion.insert(
            name: name.trim(),
            surface: surface,
            isIndoor: isIndoor,
          ),
        );
  }

  /// 최근 사용 순 정렬을 갱신한다. 세션을 저장할 때 호출한다.
  Future<void> touch(int id, {DateTime? at}) async {
    await (_db.update(_db.places)..where((t) => t.id.equals(id))).write(
      PlacesCompanion(lastUsedAt: Value(at ?? DateTime.now())),
    );
  }
}

@riverpod
PlaceRepository placeRepository(Ref ref) {
  return PlaceRepository(ref.watch(appDatabaseProvider));
}
