import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'database_provider.g.dart';

/// 앱 전체가 공유하는 DB 인스턴스.
///
/// `keepAlive: true`인 이유: DB 커넥션은 화면이 사라질 때마다 닫고 다시 열 게
/// 아니라 앱이 사는 동안 하나만 유지해야 한다. drift의 스트림 쿼리도 같은
/// 인스턴스를 공유해야 갱신이 전파된다.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.defaults();
  ref.onDispose(db.close);
  return db;
}
