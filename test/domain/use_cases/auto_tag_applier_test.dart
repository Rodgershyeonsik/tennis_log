import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/use_cases/auto_tag_applier.dart';
import 'package:tennis_log/data/repositories/tag_repository.dart';

void main() {
  late AppDatabase db;
  late AutoTagApplier applier;
  late int sessionId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    applier = AutoTagApplier(db, TagRepository(db));
    sessionId = await db
        .into(db.sessions)
        .insert(SessionsCompanion.insert(date: DateTime(2026, 9, 29)));
  });

  tearDown(() async {
    await db.close();
  });

  var nextOrderIndex = 0;

  /// 메모를 특정 상태로 만들어 둔다. [lastTaggedContent]를 내용과 같게 주면
  /// "이미 추천을 돌린 메모"가 된다.
  Future<int> insertMemo(
    String content, {
    MemoEvaluation? evaluation,
    EvaluationStatus? evaluationStatus,
    String? lastTaggedContent,
  }) {
    return db
        .into(db.memos)
        .insert(
          MemosCompanion.insert(
            sessionId: sessionId,
            content: content,
            orderIndex: nextOrderIndex++,
            evaluation: Value(evaluation),
            evaluationStatus: Value(evaluationStatus),
            lastTaggedContent: Value(lastTaggedContent),
          ),
        );
  }

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
    String tagName, {
    required MemoTagSource source,
    required MemoTagStatus status,
  }) async {
    await db
        .into(db.memoTags)
        .insert(
          MemoTagsCompanion.insert(
            memoId: memoId,
            tagId: await tagId(tagName),
            source: source,
            status: status,
          ),
        );
  }

  Future<Memo> readMemo(int memoId) {
    return (db.select(db.memos)..where((t) => t.id.equals(memoId))).getSingle();
  }

  /// 메모에 남아 있는 태그 연결을 `이름 → (source, status)`로 읽는다.
  Future<Map<String, (MemoTagSource, MemoTagStatus)>> readLinks(
    int memoId,
  ) async {
    final rows = await (db.select(db.memoTags).join([
      innerJoin(db.tags, db.tags.id.equalsExp(db.memoTags.tagId)),
    ])..where(db.memoTags.memoId.equals(memoId))).get();

    return {
      for (final row in rows)
        row.readTable(db.tags).name: (
          row.readTable(db.memoTags).source,
          row.readTable(db.memoTags).status,
        ),
    };
  }

  group('태그 반영', () {
    test('sure 표현은 confirmed, ambiguous 표현은 suggested로 붙는다', () async {
      final sure = await insertMemo('오늘 서브 개굿');
      final ambiguous = await insertMemo('왼쪽 어깨 아픔');

      await applier.applyToSession(sessionId);

      expect(await readLinks(sure), {
        '서브': (MemoTagSource.auto, MemoTagStatus.confirmed),
      });
      expect(await readLinks(ambiguous), {
        '유닛턴': (MemoTagSource.auto, MemoTagStatus.suggested),
      });
    });

    test('manual 태그는 새 결과에 없어도 그대로 둔다', () async {
      final memoId = await insertMemo('오늘 서브 개굿');
      await link(
        memoId,
        '포칭',
        source: MemoTagSource.manual,
        status: MemoTagStatus.confirmed,
      );

      await applier.applyToSession(sessionId);

      expect(await readLinks(memoId), {
        '서브': (MemoTagSource.auto, MemoTagStatus.confirmed),
        '포칭': (MemoTagSource.manual, MemoTagStatus.confirmed),
      });
    });

    test('rejected 태그는 다시 매칭돼도 붙이지 않고 기억을 남긴다', () async {
      final memoId = await insertMemo('오늘 서브 개굿');
      await link(
        memoId,
        '서브',
        source: MemoTagSource.auto,
        status: MemoTagStatus.rejected,
      );

      await applier.applyToSession(sessionId);

      expect(await readLinks(memoId), {
        '서브': (MemoTagSource.auto, MemoTagStatus.rejected),
      });
    });

    test('새 결과에 없는 기존 auto 태그는 지운다', () async {
      final memoId = await insertMemo('오늘 서브 개굿');
      await link(
        memoId,
        '포칭',
        source: MemoTagSource.auto,
        status: MemoTagStatus.suggested,
      );
      await link(
        memoId,
        '전위',
        source: MemoTagSource.auto,
        status: MemoTagStatus.confirmed,
      );

      await applier.applyToSession(sessionId);

      // 사용자가 확인한(confirmed) auto 태그도 내용이 바뀌어 더 이상 매칭되지
      // 않으면 지운다(명세: "기존 auto 태그 중 새 결과에 없는 것은 제거").
      expect(await readLinks(memoId), {
        '서브': (MemoTagSource.auto, MemoTagStatus.confirmed),
      });
    });

    test('사용자가 confirmed로 올린 auto 태그는 suggested로 내리지 않는다', () async {
      final memoId = await insertMemo('왼쪽 어깨 아픔');
      await link(
        memoId,
        '유닛턴',
        source: MemoTagSource.auto,
        status: MemoTagStatus.confirmed,
      );

      await applier.applyToSession(sessionId);

      expect(await readLinks(memoId), {
        '유닛턴': (MemoTagSource.auto, MemoTagStatus.confirmed),
      });
    });

    test('suggested였던 auto 태그는 새 결과가 sure면 confirmed로 올라간다', () async {
      // '어깨'(ambiguous)로 붙어 있던 #어깨·광배가, 내용이 '어깨 통증'(sure)으로
      // 바뀌면서 confirmed가 된다.
      final memoId = await insertMemo(
        '어깨 통증 심함',
        lastTaggedContent: '어깨 좀 이상함',
      );
      await link(
        memoId,
        '어깨·광배',
        source: MemoTagSource.auto,
        status: MemoTagStatus.suggested,
      );

      await applier.applyToSession(sessionId);

      expect(await readLinks(memoId), {
        '어깨·광배': (MemoTagSource.auto, MemoTagStatus.confirmed),
      });
    });
  });

  group('평가 반영', () {
    test('비어 있던 평가는 추천 결과로 채우고 suggested로 둔다', () async {
      final memoId = await insertMemo('백발리 여전히 안 됨ㅠㅠ');

      await applier.applyToSession(sessionId);

      final memo = await readMemo(memoId);
      expect(memo.evaluation, MemoEvaluation.bad);
      expect(memo.evaluationStatus, EvaluationStatus.suggested);
    });

    test('confirmed 평가는 내용이 바뀌어도 덮어쓰지 않는다', () async {
      // 명세 6번의 마지막 테스트 케이스.
      final memoId = await insertMemo(
        '안 됨ㅠ',
        evaluation: MemoEvaluation.good,
        evaluationStatus: EvaluationStatus.confirmed,
        lastTaggedContent: '서브 개굿',
      );

      await applier.applyToSession(sessionId);

      final memo = await readMemo(memoId);
      expect(memo.evaluation, MemoEvaluation.good);
      expect(memo.evaluationStatus, EvaluationStatus.confirmed);
      // 태그는 그대로 다시 처리됐다.
      expect(memo.lastTaggedContent, '안 됨ㅠ');
    });

    test('suggested 평가는 새 추천으로 바뀐다', () async {
      final memoId = await insertMemo(
        '오늘 서브 개굿',
        evaluation: MemoEvaluation.bad,
        evaluationStatus: EvaluationStatus.suggested,
        lastTaggedContent: '서브 안 됨ㅠ',
      );

      await applier.applyToSession(sessionId);

      final memo = await readMemo(memoId);
      expect(memo.evaluation, MemoEvaluation.good);
      expect(memo.evaluationStatus, EvaluationStatus.suggested);
    });

    test('키워드가 없으면 suggested 평가를 none 추천으로 바꾼다', () async {
      final memoId = await insertMemo(
        '토스 높게',
        evaluation: MemoEvaluation.bad,
        evaluationStatus: EvaluationStatus.suggested,
        lastTaggedContent: '토스 안 됨ㅠ',
      );

      await applier.applyToSession(sessionId);

      final memo = await readMemo(memoId);
      expect(memo.evaluation, MemoEvaluation.none);
      expect(memo.evaluationStatus, EvaluationStatus.suggested);
    });

    test('판단 보류(null)면 suggested 평가를 비운다', () async {
      final memoId = await insertMemo(
        '서브는 잘됨 근데 리턴은 안됨',
        evaluation: MemoEvaluation.bad,
        evaluationStatus: EvaluationStatus.suggested,
        lastTaggedContent: '리턴은 안됨',
      );

      await applier.applyToSession(sessionId);

      final memo = await readMemo(memoId);
      expect(memo.evaluation, isNull);
      expect(memo.evaluationStatus, isNull);
    });
  });

  group('내용이 바뀐 메모만 처리', () {
    test('lastTaggedContent가 내용과 같으면 건너뛴다', () async {
      final memoId = await insertMemo(
        '오늘 서브 개굿',
        lastTaggedContent: '오늘 서브 개굿',
      );
      // 사용자가 2단계에서 손본 상태를 흉내 낸다.
      await link(
        memoId,
        '포칭',
        source: MemoTagSource.auto,
        status: MemoTagStatus.confirmed,
      );

      final result = await applier.applyToSession(sessionId);

      expect(result.processedMemoCount, 0);
      expect(await readLinks(memoId), {
        '포칭': (MemoTagSource.auto, MemoTagStatus.confirmed),
      });
    });

    test('처리한 메모에는 lastTaggedContent를 남긴다', () async {
      final memoId = await insertMemo('오늘 서브 개굿');

      final result = await applier.applyToSession(sessionId);

      expect(result.processedMemoCount, 1);
      expect((await readMemo(memoId)).lastTaggedContent, '오늘 서브 개굿');
    });

    test('두 번 연속 실행하면 두 번째는 아무것도 처리하지 않는다', () async {
      await insertMemo('오늘 서브 개굿');
      await insertMemo('왼쪽 어깨 아픔');

      await applier.applyToSession(sessionId);
      final second = await applier.applyToSession(sessionId);

      expect(second.processedMemoCount, 0);
    });
  });

  group('태그 확인 완료 되돌리기', () {
    Future<bool> tagReviewed() async => (await (db.select(
      db.sessions,
    )..where((t) => t.id.equals(sessionId))).getSingle()).tagReviewed;

    Future<void> markReviewed() =>
        (db.update(db.sessions)..where((t) => t.id.equals(sessionId))).write(
          const SessionsCompanion(tagReviewed: Value(true)),
        );

    test('새로 처리한 메모가 있으면 태그 확인 전으로 되돌린다', () async {
      await insertMemo('오늘 서브 개굿', lastTaggedContent: '오늘 서브 개굿');
      await markReviewed();
      await insertMemo('왼쪽 어깨 아픔');

      await applier.applyToSession(sessionId);

      expect(await tagReviewed(), isFalse);
    });

    test('고친 메모가 있어도 되돌린다', () async {
      await insertMemo('오늘 서브 개굿', lastTaggedContent: '오늘 서브');
      await markReviewed();

      await applier.applyToSession(sessionId);

      expect(await tagReviewed(), isFalse);
    });

    test('처리한 메모가 없으면 그대로 둔다', () async {
      await insertMemo('오늘 서브 개굿', lastTaggedContent: '오늘 서브 개굿');
      await markReviewed();

      await applier.applyToSession(sessionId);

      expect(await tagReviewed(), isTrue);
    });
  });

  group('추천 개수', () {
    test('세션 전체의 suggested 태그·평가 수를 돌려준다', () async {
      await insertMemo('왼쪽 어깨 아픔'); // #유닛턴 suggested, none 추천
      await insertMemo('백발리 여전히 안 됨ㅠㅠ'); // #백발리 confirmed, bad 추천
      await insertMemo('파트너 때문에 멘탈 흔들림'); // #파트너멘탈 suggested, none 추천

      final result = await applier.applyToSession(sessionId);

      expect(result.processedMemoCount, 3);
      expect(result.suggestedTagCount, 2);
      expect(result.suggestedEvaluationCount, 3);
    });

    test('메모가 없으면 아무 일도 하지 않는다', () async {
      final result = await applier.applyToSession(sessionId);

      expect(result.processedMemoCount, 0);
      expect(result.suggestedTagCount, 0);
      expect(result.suggestedEvaluationCount, 0);
    });
  });
}
