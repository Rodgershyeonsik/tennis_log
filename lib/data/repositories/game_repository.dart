import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../db/enums.dart';

part 'game_repository.g.dart';

/// 세션에 속한 게임 읽기·쓰기.
class GameRepository {
  GameRepository(this._db);

  final AppDatabase _db;

  Stream<List<Game>> watchBySession(int sessionId) {
    return (_db.select(_db.games)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.orderIndex),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  /// 게임을 목록 맨 끝에 추가한다.
  ///
  /// [myScore], [opponentScore]가 null이면 "스코어 모름"이다.
  Future<Game> add({
    required int sessionId,
    required GameFormat format,
    int? myScore,
    int? opponentScore,
  }) async {
    final orderIndex = await _nextOrderIndex(sessionId);
    return _db
        .into(_db.games)
        .insertReturning(
          GamesCompanion.insert(
            sessionId: sessionId,
            format: format,
            myScore: Value(myScore),
            opponentScore: Value(opponentScore),
            orderIndex: orderIndex,
          ),
        );
  }

  /// 줄을 탭해서 수정한 결과를 저장한다. 순서는 건드리지 않는다.
  Future<void> update({
    required int gameId,
    required GameFormat format,
    int? myScore,
    int? opponentScore,
  }) async {
    await (_db.update(_db.games)..where((t) => t.id.equals(gameId))).write(
      GamesCompanion(
        format: Value(format),
        myScore: Value(myScore),
        opponentScore: Value(opponentScore),
      ),
    );
  }

  Future<void> delete(int gameId) async {
    await (_db.delete(_db.games)..where((t) => t.id.equals(gameId))).go();
  }

  /// 기존 최대 orderIndex + 1. 삭제로 중간이 비어도 순서는 유지된다.
  Future<int> _nextOrderIndex(int sessionId) async {
    final maxIndex = _db.games.orderIndex.max();
    final current =
        await (_db.selectOnly(_db.games)
              ..addColumns([maxIndex])
              ..where(_db.games.sessionId.equals(sessionId)))
            .map((row) => row.read(maxIndex))
            .getSingle();
    return (current ?? -1) + 1;
  }
}

@riverpod
GameRepository gameRepository(Ref ref) {
  return GameRepository(ref.watch(appDatabaseProvider));
}
