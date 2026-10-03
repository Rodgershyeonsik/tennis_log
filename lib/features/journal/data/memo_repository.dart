import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/enums.dart';
import '../domain/memo_with_tags.dart';

part 'memo_repository.g.dart';

/// 삭제한 메모를 되돌리기 위한 꾸러미.
///
/// 메모를 지우면 memo_tags가 cascade로 함께 지워지므로, 실행 취소 때
/// 태그 연결까지 복구하려면 같이 들고 있어야 한다.
class RemovedMemo {
  const RemovedMemo({required this.memo, required this.tagLinks});

  final Memo memo;
  final List<MemoTag> tagLinks;
}

/// 메모와 그에 붙은 태그·평가 읽기·쓰기.
///
/// 메모-태그 연결을 따로 떼지 않고 여기 둔 이유는, 태그 확인 화면(2단계)이
/// 메모와 태그를 늘 같이 읽고 쓰기 때문이다.
class MemoRepository {
  MemoRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------- 메모 CRUD

  Stream<List<Memo>> watchBySession(int sessionId) {
    return (_db.select(_db.memos)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.orderIndex),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  /// 입력칸의 내용을 메모로 추가한다.
  ///
  /// **여러 줄을 붙여 넣으면 줄바꿈 기준으로 나눠서** 각각 메모가 된다.
  /// 각 줄은 앞뒤 공백을 제거하고, 빈 줄은 무시한다.
  /// 추가된 메모가 없으면 빈 목록을 돌려준다.
  Future<List<Memo>> addLines(int sessionId, String rawInput) async {
    final lines = rawInput
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.isEmpty) return const [];

    return _db.transaction(() async {
      var orderIndex = await _nextOrderIndex(sessionId);
      final inserted = <Memo>[];
      for (final line in lines) {
        inserted.add(
          await _db
              .into(_db.memos)
              .insertReturning(
                MemosCompanion.insert(
                  sessionId: sessionId,
                  content: line,
                  orderIndex: orderIndex,
                ),
              ),
        );
        orderIndex++;
      }
      return inserted;
    });
  }

  /// 메모 내용을 수정한다.
  ///
  /// `lastTaggedContent`는 건드리지 않는다. 그래야 다음 저장 때 "내용이 바뀐
  /// 메모"로 인식돼 자동 태그·평가 추천이 다시 돌아간다.
  Future<void> updateContent(int memoId, String content) async {
    await (_db.update(_db.memos)..where((t) => t.id.equals(memoId))).write(
      MemosCompanion(
        content: Value(content.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 메모를 지우고, 실행 취소에 필요한 정보를 돌려준다.
  Future<RemovedMemo?> remove(int memoId) async {
    return _db.transaction(() async {
      final memo =
          await (_db.select(_db.memos)
                ..where((t) => t.id.equals(memoId))
                ..limit(1))
              .getSingleOrNull();
      if (memo == null) return null;

      final links = await (_db.select(
        _db.memoTags,
      )..where((t) => t.memoId.equals(memoId))).get();

      await (_db.delete(_db.memos)..where((t) => t.id.equals(memoId))).go();
      return RemovedMemo(memo: memo, tagLinks: links);
    });
  }

  /// 실행 취소. 원래 id와 순서, 태그 연결까지 그대로 되돌린다.
  Future<void> restore(RemovedMemo removed) async {
    await _db.transaction(() async {
      await _db.into(_db.memos).insert(removed.memo);
      if (removed.tagLinks.isEmpty) return;
      await _db.batch((batch) {
        batch.insertAll(_db.memoTags, removed.tagLinks);
      });
    });
  }

  // ------------------------------------------------------------- 태그 확인 화면

  /// 2단계 화면이 그릴 메모 + 태그 목록.
  ///
  /// rejected 태그는 담지 않는다(명세: 화면에 표시하지 않는다).
  /// 조인 쿼리를 watch하면 memos, memo_tags, tags 어느 쪽이 바뀌어도 갱신된다.
  Stream<List<MemoWithTags>> watchWithTags(int sessionId) {
    final query =
        _db.select(_db.memos).join([
            leftOuterJoin(
              _db.memoTags,
              _db.memoTags.memoId.equalsExp(_db.memos.id) &
                  _db.memoTags.status.equalsValue(MemoTagStatus.rejected).not(),
            ),
            leftOuterJoin(_db.tags, _db.tags.id.equalsExp(_db.memoTags.tagId)),
          ])
          ..where(_db.memos.sessionId.equals(sessionId))
          ..orderBy([
            OrderingTerm.asc(_db.memos.orderIndex),
            OrderingTerm.asc(_db.memos.id),
            OrderingTerm.asc(_db.tags.name),
          ]);

    return query.watch().map((rows) {
      // 조인 결과는 메모 하나가 태그 수만큼 여러 줄로 나오므로 다시 묶는다.
      final byMemoId = <int, Memo>{};
      final tagsByMemoId = <int, List<MemoTagView>>{};

      for (final row in rows) {
        final memo = row.readTable(_db.memos);
        byMemoId[memo.id] = memo;
        tagsByMemoId.putIfAbsent(memo.id, () => []);

        final link = row.readTableOrNull(_db.memoTags);
        final tag = row.readTableOrNull(_db.tags);
        if (link == null || tag == null) continue;

        tagsByMemoId[memo.id]!.add(
          MemoTagView(
            tagId: tag.id,
            name: tag.name,
            category: tag.category,
            source: link.source,
            status: link.status,
          ),
        );
      }

      // 조인 전 orderBy가 유지되므로 삽입 순서를 그대로 쓴다.
      return [
        for (final memo in byMemoId.values)
          MemoWithTags(memo: memo, tags: tagsByMemoId[memo.id] ?? const []),
      ];
    });
  }

  /// 평가 아이콘을 눌렀을 때. [evaluation]이 null이면 평가를 해제한다.
  ///
  /// 사용자가 직접 고른 값이므로 status는 confirmed다.
  /// evaluation이 null이면 evaluationStatus도 null이어야 한다(데이터 모델).
  Future<void> setEvaluation(int memoId, MemoEvaluation? evaluation) async {
    await (_db.update(_db.memos)..where((t) => t.id.equals(memoId))).write(
      MemosCompanion(
        evaluation: Value(evaluation),
        evaluationStatus: Value(
          evaluation == null ? null : EvaluationStatus.confirmed,
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// suggested 태그 칩을 탭했을 때. confirmed로 올린다.
  Future<void> confirmTag(int memoId, int tagId) async {
    await (_db.update(_db.memoTags)
          ..where((t) => t.memoId.equals(memoId) & t.tagId.equals(tagId)))
        .write(const MemoTagsCompanion(status: Value(MemoTagStatus.confirmed)));
  }

  /// 칩의 x를 눌렀을 때. 행을 지우지 않고 rejected로 남긴다.
  ///
  /// 지워 버리면 다음 저장 때 자동 태그가 같은 태그를 다시 붙인다. rejected로
  /// 남겨 두는 게 "사용자가 지웠다"는 기억이다.
  Future<void> rejectTag(int memoId, int tagId) async {
    await (_db.update(_db.memoTags)
          ..where((t) => t.memoId.equals(memoId) & t.tagId.equals(tagId)))
        .write(const MemoTagsCompanion(status: Value(MemoTagStatus.rejected)));
  }

  /// `+` 칩으로 태그를 직접 붙였을 때. manual/confirmed로 들어간다.
  ///
  /// 전에 rejected였던 태그를 다시 고른 경우도 여기로 들어오므로, 이미 행이
  /// 있으면 manual/confirmed로 덮어쓴다.
  Future<void> addManualTag(int memoId, int tagId) async {
    await _db
        .into(_db.memoTags)
        .insertOnConflictUpdate(
          MemoTagsCompanion.insert(
            memoId: memoId,
            tagId: tagId,
            source: MemoTagSource.manual,
            status: MemoTagStatus.confirmed,
          ),
        );
  }

  /// 상단 바의 "모두 확인". suggested 태그와 suggested 평가를 전부 confirmed로.
  Future<void> confirmAllSuggestions(int sessionId) async {
    await _db.transaction(() async {
      final memoIds = _db.selectOnly(_db.memos)
        ..addColumns([_db.memos.id])
        ..where(_db.memos.sessionId.equals(sessionId));

      await (_db.update(_db.memoTags)..where(
            (t) =>
                t.memoId.isInQuery(memoIds) &
                t.status.equalsValue(MemoTagStatus.suggested),
          ))
          .write(
            const MemoTagsCompanion(status: Value(MemoTagStatus.confirmed)),
          );

      await (_db.update(_db.memos)..where(
            (t) =>
                t.sessionId.equals(sessionId) &
                t.evaluationStatus.equalsValue(EvaluationStatus.suggested),
          ))
          .write(
            MemosCompanion(
              evaluationStatus: const Value(EvaluationStatus.confirmed),
              updatedAt: Value(DateTime.now()),
            ),
          );
    });
  }

  Future<int> _nextOrderIndex(int sessionId) async {
    final maxIndex = _db.memos.orderIndex.max();
    final current =
        await (_db.selectOnly(_db.memos)
              ..addColumns([maxIndex])
              ..where(_db.memos.sessionId.equals(sessionId)))
            .map((row) => row.read(maxIndex))
            .getSingle();
    return (current ?? -1) + 1;
  }
}

@riverpod
MemoRepository memoRepository(Ref ref) {
  return MemoRepository(ref.watch(appDatabaseProvider));
}
