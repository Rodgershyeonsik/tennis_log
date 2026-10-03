import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/core/db/app_database.dart';
import 'package:tennis_log/core/db/enums.dart';
import 'package:tennis_log/features/journal/data/memo_repository.dart';

void main() {
  late AppDatabase db;
  late MemoRepository repo;
  late int sessionId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = MemoRepository(db);
    sessionId = await db
        .into(db.sessions)
        .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 29)));
  });

  tearDown(() async {
    await db.close();
  });

  /// 시드로 들어간 태그를 이름으로 찾는다.
  Future<int> tagId(String name) async {
    final tag =
        await (db.select(db.tags)
              ..where((t) => t.name.equals(name))
              ..limit(1))
            .getSingle();
    return tag.id;
  }

  Future<void> link(
    int memoId,
    int tag, {
    MemoTagSource source = MemoTagSource.auto,
    MemoTagStatus status = MemoTagStatus.suggested,
  }) async {
    await db
        .into(db.memoTags)
        .insert(
          MemoTagsCompanion.insert(
            memoId: memoId,
            tagId: tag,
            source: source,
            status: status,
          ),
        );
  }

  group('addLines', () {
    test('한 줄을 메모 하나로 추가한다', () async {
      final added = await repo.addLines(sessionId, '백발리 안 됨');

      expect(added, hasLength(1));
      expect(added.single.content, '백발리 안 됨');
      expect(added.single.orderIndex, 0);
    });

    test('여러 줄을 붙여 넣으면 줄바꿈 기준으로 나눠 각각 메모가 된다', () async {
      final added = await repo.addLines(sessionId, '백발리 안 됨\n서브는 잘됨\n스플릿 까먹음');

      expect(added.map((m) => m.content), ['백발리 안 됨', '서브는 잘됨', '스플릿 까먹음']);
      expect(added.map((m) => m.orderIndex), [0, 1, 2]);
    });

    test('각 줄의 앞뒤 공백을 제거하고 빈 줄은 무시한다', () async {
      final added = await repo.addLines(
        sessionId,
        '  백발리 안 됨  \n\n   \n 서브는 잘됨\n',
      );

      expect(added.map((m) => m.content), ['백발리 안 됨', '서브는 잘됨']);
    });

    test('내용이 전부 공백이면 아무것도 추가하지 않는다', () async {
      expect(await repo.addLines(sessionId, '  \n\n '), isEmpty);
      expect(await repo.watchBySession(sessionId).first, isEmpty);
    });

    test('기존 메모 뒤에 이어서 순서가 붙는다', () async {
      await repo.addLines(sessionId, '첫째');
      final second = await repo.addLines(sessionId, '둘째\n셋째');

      expect(second.map((m) => m.orderIndex), [1, 2]);
    });

    test('중간 메모를 지워도 순서 번호는 뒤로 이어진다', () async {
      // 순서 번호는 max + 1이라, 가운데가 비어도 번호를 재사용하지 않는다.
      final added = await repo.addLines(sessionId, '첫째\n둘째\n셋째');
      await repo.remove(added[1].id);

      final next = await repo.addLines(sessionId, '넷째');
      expect(next.single.orderIndex, 3);
    });

    test('마지막 메모를 지우면 그 번호를 다시 쓴다', () async {
      final added = await repo.addLines(sessionId, '첫째\n둘째');
      await repo.remove(added[1].id);

      final next = await repo.addLines(sessionId, '다시 둘째');
      expect(next.single.orderIndex, 1);
    });
  });

  group('updateContent', () {
    test('내용을 바꾼다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await repo.updateContent(memo.id, '백발리 여전히 안 됨');

      final updated = (await repo.watchBySession(sessionId).first).single;
      expect(updated.content, '백발리 여전히 안 됨');
    });

    test('lastTaggedContent는 건드리지 않는다', () async {
      // 이 값이 남아 있어야 저장 때 "내용이 바뀐 메모"로 인식돼 추천이 다시 돈다.
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await (db.update(db.memos)..where((t) => t.id.equals(memo.id))).write(
        const MemosCompanion(lastTaggedContent: Value('백발리 안 됨')),
      );

      await repo.updateContent(memo.id, '백발리 여전히 안 됨');

      final updated = (await repo.watchBySession(sessionId).first).single;
      expect(updated.lastTaggedContent, '백발리 안 됨');
      expect(updated.content, '백발리 여전히 안 됨');
    });
  });

  group('remove / restore (실행 취소)', () {
    test('메모를 지우고 되돌리면 id와 순서가 그대로다', () async {
      final added = await repo.addLines(sessionId, '첫째\n둘째');
      final target = added[1];

      final removed = await repo.remove(target.id);
      expect(await repo.watchBySession(sessionId).first, hasLength(1));

      await repo.restore(removed!);

      final memos = await repo.watchBySession(sessionId).first;
      expect(memos.map((m) => m.id), [added[0].id, target.id]);
      expect(memos[1].orderIndex, target.orderIndex);
    });

    test('되돌리면 태그 연결까지 복구된다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await link(memo.id, await tagId('백발리'), status: MemoTagStatus.confirmed);
      await link(memo.id, await tagId('그립'), status: MemoTagStatus.rejected);

      final removed = await repo.remove(memo.id);
      // 메모를 지우면 memo_tags도 cascade로 지워진다.
      expect(await db.select(db.memoTags).get(), isEmpty);

      await repo.restore(removed!);

      final links = await db.select(db.memoTags).get();
      expect(links, hasLength(2));
      // rejected 기억도 함께 살아나야 한다.
      expect(
        links.map((l) => l.status),
        containsAll([MemoTagStatus.confirmed, MemoTagStatus.rejected]),
      );
    });

    test('없는 메모를 지우면 null이다', () async {
      expect(await repo.remove(999), isNull);
    });
  });

  group('setEvaluation', () {
    test('사용자가 고른 평가는 confirmed로 들어간다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await repo.setEvaluation(memo.id, MemoEvaluation.bad);

      final updated = (await repo.watchBySession(sessionId).first).single;
      expect(updated.evaluation, MemoEvaluation.bad);
      expect(updated.evaluationStatus, EvaluationStatus.confirmed);
    });

    test('해제하면 평가와 상태가 둘 다 null이 된다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await repo.setEvaluation(memo.id, MemoEvaluation.bad);

      await repo.setEvaluation(memo.id, null);

      final updated = (await repo.watchBySession(sessionId).first).single;
      expect(updated.evaluation, isNull);
      expect(updated.evaluationStatus, isNull);
    });
  });

  group('watchWithTags', () {
    test('메모에 붙은 태그를 함께 돌려준다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await link(memo.id, await tagId('백발리'), status: MemoTagStatus.confirmed);

      final cards = await repo.watchWithTags(sessionId).first;
      expect(cards, hasLength(1));
      expect(cards.single.tags.map((t) => t.name), ['백발리']);
      expect(cards.single.tags.single.status, MemoTagStatus.confirmed);
    });

    test('rejected 태그는 화면에 보여주지 않는다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await link(memo.id, await tagId('백발리'), status: MemoTagStatus.confirmed);
      await link(memo.id, await tagId('그립'), status: MemoTagStatus.rejected);

      final card = (await repo.watchWithTags(sessionId).first).single;
      expect(card.tags.map((t) => t.name), ['백발리']);
    });

    test('태그가 없는 메모도 빈 목록으로 포함된다', () async {
      await repo.addLines(sessionId, '태그 없는 메모');

      final card = (await repo.watchWithTags(sessionId).first).single;
      expect(card.tags, isEmpty);
    });

    test('메모 순서를 유지한다', () async {
      final added = await repo.addLines(sessionId, '첫째\n둘째\n셋째');
      // 가운데 메모에만 태그를 붙여도 순서가 흐트러지지 않아야 한다.
      await link(added[1].id, await tagId('서브'));

      final cards = await repo.watchWithTags(sessionId).first;
      expect(cards.map((c) => c.memo.content), ['첫째', '둘째', '셋째']);
    });

    test('다른 세션의 메모는 섞이지 않는다', () async {
      await repo.addLines(sessionId, '이 세션 메모');
      final other = await db
          .into(db.sessions)
          .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 28)));
      await repo.addLines(other, '다른 세션 메모');

      final cards = await repo.watchWithTags(sessionId).first;
      expect(cards.map((c) => c.memo.content), ['이 세션 메모']);
    });
  });

  group('태그 칩 조작', () {
    test('confirmTag는 suggested를 confirmed로 올린다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      final tag = await tagId('백발리');
      await link(memo.id, tag);

      await repo.confirmTag(memo.id, tag);

      final card = (await repo.watchWithTags(sessionId).first).single;
      expect(card.tags.single.status, MemoTagStatus.confirmed);
    });

    test('rejectTag는 행을 지우지 않고 rejected로 남긴다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      final tag = await tagId('백발리');
      await link(memo.id, tag);

      await repo.rejectTag(memo.id, tag);

      // 화면에서는 사라지지만
      final card = (await repo.watchWithTags(sessionId).first).single;
      expect(card.tags, isEmpty);
      // DB에는 기억으로 남는다.
      final row = await db.select(db.memoTags).getSingle();
      expect(row.status, MemoTagStatus.rejected);
    });

    test('addManualTag는 manual/confirmed로 붙인다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      await repo.addManualTag(memo.id, await tagId('포칭'));

      final view =
          (await repo.watchWithTags(sessionId).first).single.tags.single;
      expect(view.source, MemoTagSource.manual);
      expect(view.status, MemoTagStatus.confirmed);
    });

    test('rejected였던 태그를 직접 다시 붙이면 되살아난다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      final tag = await tagId('백발리');
      await link(memo.id, tag);
      await repo.rejectTag(memo.id, tag);

      await repo.addManualTag(memo.id, tag);

      final view =
          (await repo.watchWithTags(sessionId).first).single.tags.single;
      expect(view.status, MemoTagStatus.confirmed);
      expect(view.source, MemoTagSource.manual);
      expect(await db.select(db.memoTags).get(), hasLength(1));
    });
  });

  group('confirmAllSuggestions (모두 확인)', () {
    test('suggested 태그를 모두 confirmed로 바꾼다', () async {
      final added = await repo.addLines(sessionId, '첫째\n둘째');
      await link(added[0].id, await tagId('서브'));
      await link(added[1].id, await tagId('리턴'));

      await repo.confirmAllSuggestions(sessionId);

      final rows = await db.select(db.memoTags).get();
      expect(rows.map((r) => r.status), everyElement(MemoTagStatus.confirmed));
    });

    test('rejected 태그는 건드리지 않는다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨')).single;
      final tag = await tagId('백발리');
      await link(memo.id, tag, status: MemoTagStatus.rejected);

      await repo.confirmAllSuggestions(sessionId);

      final row = await db.select(db.memoTags).getSingle();
      expect(row.status, MemoTagStatus.rejected);
    });

    test('suggested 평가를 confirmed로 바꾸고 평가 값은 그대로 둔다', () async {
      final memo = (await repo.addLines(sessionId, '백발리 안 됨ㅠㅠ')).single;
      await (db.update(db.memos)..where((t) => t.id.equals(memo.id))).write(
        const MemosCompanion(
          evaluation: Value(MemoEvaluation.bad),
          evaluationStatus: Value(EvaluationStatus.suggested),
        ),
      );

      await repo.confirmAllSuggestions(sessionId);

      final updated = (await repo.watchBySession(sessionId).first).single;
      expect(updated.evaluation, MemoEvaluation.bad);
      expect(updated.evaluationStatus, EvaluationStatus.confirmed);
    });

    test('평가가 없는 메모는 그대로 비어 있다', () async {
      await repo.addLines(sessionId, '평가 없는 메모');

      await repo.confirmAllSuggestions(sessionId);

      final updated = (await repo.watchBySession(sessionId).first).single;
      expect(updated.evaluation, isNull);
      expect(updated.evaluationStatus, isNull);
    });

    test('다른 세션의 메모는 건드리지 않는다', () async {
      final other = await db
          .into(db.sessions)
          .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 28)));
      final otherMemo = (await repo.addLines(other, '다른 세션')).single;
      await link(otherMemo.id, await tagId('서브'));

      await repo.confirmAllSuggestions(sessionId);

      final row = await db.select(db.memoTags).getSingle();
      expect(row.status, MemoTagStatus.suggested);
    });
  });
}
