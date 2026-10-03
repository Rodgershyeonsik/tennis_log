import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'enums.dart';
import 'seed/tag_seeder.dart';
import 'tables.dart';

// 짝이 되는 생성 코드. `dart run build_runner build`로 만들어진다.
part 'app_database.g.dart';

/// 앱 로컬 DB. 서버/동기화 없이 이 파일 하나가 전부다.
///
/// 웹과 Android 양쪽에서 동작한다. 열기 방식은 [_openConnection] 참고.
@DriftDatabase(
  tables: [
    Places,
    Cues,
    Sessions,
    Games,
    Memos,
    Tags,
    TagAliases,
    TagExclusions,
    MemoTags,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// 테스트에서 인메모리 DB를 넣을 수 있게 executor를 받는 생성자를 남겨둔다.
  AppDatabase(super.e);

  /// 실제 앱에서 쓰는 생성자.
  AppDatabase.defaults() : super(_openConnection());

  /// 스키마를 바꿀 때마다 올리고, [migration]에 마이그레이션을 추가한다.
  @override
  int get schemaVersion => 1;

  /// DateTime을 유닉스 초(기본값)가 아니라 ISO-8601 텍스트로 저장한다.
  ///
  /// `sessions.date`가 날짜 전용 값인데, 정수 타임스탬프로 저장하면 타임존에
  /// 따라 날짜가 하루 밀려 읽힐 수 있다. 텍스트로 저장하면 그 위험이 없다.
  ///
  /// **주의**: 이건 기존 데이터와 호환되지 않는 설정이므로 나중에 바꾸면 안 된다.
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      // SQLite는 외래키 제약이 기본으로 꺼져 있고 **커넥션마다** 켜야 한다.
      // 이걸 안 켜면 테이블에 선언한 ON DELETE CASCADE가 전부 동작하지 않는다.
      // (PRAGMA는 트랜잭션 안에서 바꿀 수 없어서 beforeOpen에서 실행한다.)
      await customStatement('PRAGMA foreign_keys = ON');

      // 기본 태그 사전을 넣는다. onCreate가 아니라 여기인 이유:
      // Android와 웹이 각각 별개 DB라 양쪽 첫 실행을 모두 덮어야 하고,
      // 이미 테이블이 만들어진 개발 환경에도 시드가 들어가야 한다.
      // tags가 비어 있을 때만 실제로 동작한다.
      await seedTagDictionary(this);
    },
  );
}

/// 플랫폼에 맞는 DB 커넥션을 연다.
///
/// - Android 등 네이티브: 앱 문서 디렉터리의 `tennis_log.sqlite` 파일
/// - 웹: `web/` 폴더의 `sqlite3.wasm` + `drift_worker.js`를 써서 OPFS나
///   IndexedDB에 저장한다. 두 파일은 저장소에 커밋해 두었다.
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'tennis_log',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      onResult: _logWebStorage,
    ),
  );
}

/// 웹에서 drift가 **어떤 저장 방식을 골랐는지** 콘솔에 남긴다.
///
/// drift는 브라우저가 지원하는 기능에 따라 OPFS → IndexedDB 순으로 내려가고,
/// 아무것도 못 쓰면 `inMemory`로 떨어진다. **inMemory는 새로고침하면 데이터가
/// 전부 사라지는데 에러 없이 조용히 동작하므로** 로그 없이는 알아차리기 어렵다.
void _logWebStorage(WasmDatabaseResult result) {
  if (!kDebugMode) return;

  debugPrint('[drift] 웹 저장 방식: ${result.chosenImplementation.name}');
  if (result.missingFeatures.isNotEmpty) {
    debugPrint(
      '[drift] 이 브라우저에 없는 기능: '
      '${result.missingFeatures.map((f) => f.name).join(', ')}',
    );
  }
  if (result.chosenImplementation == WasmStorageImplementation.inMemory) {
    debugPrint('[drift] 경고: 저장되지 않는 모드다. 새로고침하면 데이터가 사라진다.');
  }
}
