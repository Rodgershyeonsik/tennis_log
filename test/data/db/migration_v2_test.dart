import 'dart:io';

// drift도 isNull/isNotNull을 내보내서 matcher의 것과 겹친다.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/data/db/migrations/v2_evaluation_none.dart';

/// 스키마 1 → 2 마이그레이션(명세 02 3번).
///
/// 앞쪽 그룹은 마이그레이션 함수를 v2 DB 위에서 바로 불러 단계별 전후를 본다.
/// 테이블 구조가 v1과 같으므로 v2 DB에 v1 시점의 데이터를 넣어도 같은 상황이다.
/// 마지막 그룹은 실제로 `user_version = 1`인 파일을 다시 열어 `onUpgrade`가
/// 도는지 확인한다.
void main() {
  /// 세션 하나에 메모와 태그 연결을 넣는 헬퍼들. [db]를 받아서 두 그룹이 같이 쓴다.
  Future<int> insertSession(AppDatabase db, {required bool tagReviewed}) {
    return db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: DateTime(2026, 10, 1),
            tagReviewed: Value(tagReviewed),
          ),
        );
  }

  Future<int> insertMemo(
    AppDatabase db,
    int sessionId, {
    String content = '토스 높게',
    MemoEvaluation? evaluation,
    EvaluationStatus? status,
    String? lastTaggedContent = '토스 높게',
  }) {
    return db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: 0,
            evaluation: Value(evaluation),
            evaluationStatus: Value(status),
            lastTaggedContent: Value(lastTaggedContent),
          ),
        );
  }

  Future<void> insertMemoTag(
    AppDatabase db,
    int memoId,
    MemoTagStatus status,
  ) async {
    // 시드 태그 아무거나 하나. 연결 상태만 보면 된다.
    final tag = await (db.select(db.tags)..limit(1)).getSingle();
    await db
        .into(db.memoTags)
        .insert(
          MemoTagsCompanion.insert(
            memoId: memoId,
            tagId: tag.id,
            source: MemoTagSource.auto,
            status: status,
          ),
        );
  }

  Future<bool> reviewedOf(AppDatabase db, int sessionId) async {
    final session = await (db.select(
      db.sessions,
    )..where((t) => t.id.equals(sessionId))).getSingle();
    return session.tagReviewed;
  }

  Future<Memo> memoOf(AppDatabase db, int memoId) {
    return (db.select(db.memos)..where((t) => t.id.equals(memoId))).getSingle();
  }

  Future<void> migrate(AppDatabase db) =>
      db.transaction(() => migrateToV2EvaluationNone(db));

  group('마이그레이션 함수', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    group('1) 점선이 남은 확인 완료 일지 되돌리기', () {
      test('suggested 평가가 있으면 tagReviewed = false', () async {
        final session = await insertSession(db, tagReviewed: true);
        await insertMemo(
          db,
          session,
          evaluation: MemoEvaluation.good,
          status: EvaluationStatus.suggested,
        );

        expect(await reviewedOf(db, session), isTrue);
        await migrate(db);
        expect(await reviewedOf(db, session), isFalse);
      });

      test('suggested 태그가 있으면 tagReviewed = false', () async {
        final session = await insertSession(db, tagReviewed: true);
        final memo = await insertMemo(
          db,
          session,
          evaluation: MemoEvaluation.good,
          status: EvaluationStatus.confirmed,
        );
        await insertMemoTag(db, memo, MemoTagStatus.suggested);

        await migrate(db);
        expect(await reviewedOf(db, session), isFalse);
      });

      test('확정·rejected만 있으면 그대로 둔다', () async {
        final session = await insertSession(db, tagReviewed: true);
        final memo = await insertMemo(
          db,
          session,
          evaluation: MemoEvaluation.bad,
          status: EvaluationStatus.confirmed,
        );
        await insertMemoTag(db, memo, MemoTagStatus.rejected);

        await migrate(db);
        expect(await reviewedOf(db, session), isTrue);
      });

      test('확인 전 일지는 그대로 false다', () async {
        final session = await insertSession(db, tagReviewed: false);
        await insertMemo(
          db,
          session,
          evaluation: MemoEvaluation.good,
          status: EvaluationStatus.suggested,
        );

        await migrate(db);
        expect(await reviewedOf(db, session), isFalse);
      });
    });

    group('2) 확인 완료 일지의 빈 평가', () {
      test('null 평가는 none 확정이 되고, 확정 평가는 그대로다', () async {
        final session = await insertSession(db, tagReviewed: true);
        final empty = await insertMemo(db, session);
        final good = await insertMemo(
          db,
          session,
          content: '오늘 서브 개굿',
          evaluation: MemoEvaluation.good,
          status: EvaluationStatus.confirmed,
        );

        await migrate(db);

        final emptyAfter = await memoOf(db, empty);
        expect(emptyAfter.evaluation, MemoEvaluation.none);
        expect(emptyAfter.evaluationStatus, EvaluationStatus.confirmed);

        final goodAfter = await memoOf(db, good);
        expect(goodAfter.evaluation, MemoEvaluation.good);
        expect(goodAfter.evaluationStatus, EvaluationStatus.confirmed);

        expect(await reviewedOf(db, session), isTrue);
      });

      test('키워드가 있는 내용이어도 사용자가 비워 뒀으면 none 확정이다', () async {
        final session = await insertSession(db, tagReviewed: true);
        final memo = await insertMemo(
          db,
          session,
          content: '서브 잘됨',
          lastTaggedContent: '서브 잘됨',
        );

        await migrate(db);

        final after = await memoOf(db, memo);
        expect(after.evaluation, MemoEvaluation.none);
        expect(after.evaluationStatus, EvaluationStatus.confirmed);
      });

      test('1번에서 되돌린 일지의 빈 평가는 확정하지 않고 3번 규칙을 따른다', () async {
        final session = await insertSession(db, tagReviewed: true);
        await insertMemo(
          db,
          session,
          content: '서브 잘됨',
          lastTaggedContent: '서브 잘됨',
          evaluation: MemoEvaluation.good,
          status: EvaluationStatus.suggested,
        );
        final empty = await insertMemo(db, session);

        await migrate(db);

        expect(await reviewedOf(db, session), isFalse);
        final after = await memoOf(db, empty);
        expect(after.evaluation, MemoEvaluation.none);
        expect(after.evaluationStatus, EvaluationStatus.suggested);
      });
    });

    group('3) 확인 전 일지의 빈 평가', () {
      test('키워드가 없으면 none 추천', () async {
        final session = await insertSession(db, tagReviewed: false);
        final memo = await insertMemo(db, session);

        await migrate(db);

        final after = await memoOf(db, memo);
        expect(after.evaluation, MemoEvaluation.none);
        expect(after.evaluationStatus, EvaluationStatus.suggested);
      });

      test('판단 보류(good과 bad가 둘 다)는 그대로 null', () async {
        final session = await insertSession(db, tagReviewed: false);
        const content = '서브는 잘됨 근데 리턴은 안됨';
        final memo = await insertMemo(
          db,
          session,
          content: content,
          lastTaggedContent: content,
        );

        await migrate(db);

        final after = await memoOf(db, memo);
        expect(after.evaluation, isNull);
        expect(after.evaluationStatus, isNull);
      });

      test('추천 결과가 good·bad·question이면 채우지 않는다', () async {
        // 사용자가 2단계에서 추천을 해제해 비워 둔 경우. none만 채운다.
        final session = await insertSession(db, tagReviewed: false);
        final memo = await insertMemo(
          db,
          session,
          content: '서브 잘됨',
          lastTaggedContent: '서브 잘됨',
        );

        await migrate(db);

        expect((await memoOf(db, memo)).evaluation, isNull);
      });

      test('추천을 한 번도 안 돌린 메모(lastTaggedContent = null)는 건드리지 않는다', () async {
        final session = await insertSession(db, tagReviewed: false);
        final memo = await insertMemo(db, session, lastTaggedContent: null);

        await migrate(db);

        final after = await memoOf(db, memo);
        expect(after.evaluation, isNull);
        expect(after.evaluationStatus, isNull);
      });

      test('이미 평가가 있는 메모와 tagReviewed는 그대로다', () async {
        final session = await insertSession(db, tagReviewed: false);
        final memo = await insertMemo(
          db,
          session,
          evaluation: MemoEvaluation.bad,
          status: EvaluationStatus.suggested,
        );

        await migrate(db);

        final after = await memoOf(db, memo);
        expect(after.evaluation, MemoEvaluation.bad);
        expect(after.evaluationStatus, EvaluationStatus.suggested);
        expect(await reviewedOf(db, session), isFalse);
      });

      test('태그는 다시 추천하지 않는다', () async {
        final session = await insertSession(db, tagReviewed: false);
        // "토스"는 시드 사전에 있는 표현이지만 태그 연결이 새로 생기면 안 된다.
        final memo = await insertMemo(db, session);

        await migrate(db);

        final links = await (db.select(
          db.memoTags,
        )..where((t) => t.memoId.equals(memo))).get();
        expect(links, isEmpty);
      });
    });
  });

  group('실제 업그레이드 (user_version 1 → 2)', () {
    late Directory dir;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('tennis_log_migration_');
    });
    tearDown(() async => dir.delete(recursive: true));

    test('v1 DB를 열면 onUpgrade가 돌고 기존 행은 보존된다', () async {
      final file = File('${dir.path}/db.sqlite');

      // v1 DB를 흉내 낸다. 테이블 구조가 같으므로 v2로 만든 뒤 버전만 1로 되돌린다.
      final v1 = AppDatabase(NativeDatabase(file));
      final reviewed = await insertSession(v1, tagReviewed: true);
      final reviewedEmpty = await insertMemo(v1, reviewed);
      final draft = await insertSession(v1, tagReviewed: false);
      final draftEmpty = await insertMemo(v1, draft);
      await v1.customStatement('PRAGMA user_version = 1');
      await v1.close();

      final v2 = AppDatabase(NativeDatabase(file));
      addTearDown(v2.close);

      final version = await v2
          .customSelect('PRAGMA user_version')
          .map((row) => row.read<int>('user_version'))
          .getSingle();
      expect(version, 2);

      // 세션·메모 수는 그대로다.
      expect(await v2.select(v2.sessions).get(), hasLength(2));
      expect(await v2.select(v2.memos).get(), hasLength(2));

      final reviewedAfter = await memoOf(v2, reviewedEmpty);
      expect(reviewedAfter.content, '토스 높게');
      expect(reviewedAfter.evaluation, MemoEvaluation.none);
      expect(reviewedAfter.evaluationStatus, EvaluationStatus.confirmed);

      final draftAfter = await memoOf(v2, draftEmpty);
      expect(draftAfter.evaluation, MemoEvaluation.none);
      expect(draftAfter.evaluationStatus, EvaluationStatus.suggested);
    });
  });
}
