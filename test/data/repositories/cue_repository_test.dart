import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/app_database.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/data/repositories/cue_repository.dart';

void main() {
  late AppDatabase db;
  late CueRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CueRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  /// 특정 큐를 쓴 세션을 하나 만든다.
  Future<void> addSessionUsing(
    int cueId, {
    required DateTime date,
    CueApplied? applied,
  }) async {
    await db
        .into(db.sessions)
        .insert(
          SessionsCompanion.insert(
            date: date,
            cueId: Value(cueId),
            cueApplied: Value(applied),
          ),
        );
  }

  group('normalize', () {
    test('앞뒤 공백을 제거하고 연속 공백을 하나로 줄인다', () {
      expect(CueRepository.normalize('  왼팔   늦게  내리기 '), '왼팔 늦게 내리기');
    });

    test('줄바꿈과 탭도 공백으로 본다', () {
      expect(CueRepository.normalize('왼팔\n늦게\t내리기'), '왼팔 늦게 내리기');
    });

    test('공백만 있으면 빈 문자열이 된다', () {
      expect(CueRepository.normalize('   \n '), '');
    });
  });

  group('findOrCreate', () {
    test('정규화 후 같은 텍스트면 같은 큐를 재사용한다', () async {
      final first = await repo.findOrCreate('왼팔 늦게 내리기');
      final second = await repo.findOrCreate('  왼팔   늦게 내리기  ');

      expect(second!.id, first!.id);
      expect(await db.select(db.cues).get(), hasLength(1));
    });

    test('다른 텍스트면 새로 만든다', () async {
      await repo.findOrCreate('왼팔 늦게 내리기');
      await repo.findOrCreate('유닛턴 먼저');

      expect(await db.select(db.cues).get(), hasLength(2));
    });

    test('빈 입력이면 큐를 만들지 않고 null을 돌려준다', () async {
      expect(await repo.findOrCreate('   '), isNull);
      expect(await db.select(db.cues).get(), isEmpty);
    });

    test('저장되는 텍스트는 정규화된 값이다', () async {
      final cue = await repo.findOrCreate(' 힘  빼기 ');
      expect(cue!.cueText, '힘 빼기');
    });
  });

  group('mostRecent', () {
    test('과거 큐가 없으면 null이다', () async {
      expect(await repo.mostRecent(), isNull);
    });

    test('lastUsedAt이 가장 늦은 큐를 돌려준다', () async {
      final old = await repo.findOrCreate('예전 큐');
      final recent = await repo.findOrCreate('최근 큐');

      await repo.touch(old!.id, at: DateTime(2026, 1, 1));
      await repo.touch(recent!.id, at: DateTime(2026, 9, 29));

      expect((await repo.mostRecent())!.id, recent.id);
    });
  });

  group('watchSummaries', () {
    test('사용 횟수와 최근 사용 날짜를 세션에서 집계한다', () async {
      final cue = await repo.findOrCreate('왼팔 늦게 내리기');
      await addSessionUsing(cue!.id, date: DateTime(2026, 9, 1));
      await addSessionUsing(cue.id, date: DateTime(2026, 9, 20));

      final summaries = await repo.watchSummaries().first;
      expect(summaries, hasLength(1));
      expect(summaries.single.useCount, 2);
      expect(summaries.single.lastUsedDate, DateTime(2026, 9, 20));
    });

    test('쓴 세션이 없으면 횟수 0, 날짜 null이다', () async {
      await repo.findOrCreate('아직 안 쓴 큐');

      final summary = (await repo.watchSummaries().first).single;
      expect(summary.useCount, 0);
      expect(summary.lastUsedDate, isNull);
    });

    test('최근 적용 결과는 가장 늦은 날짜의 세션 값이다', () async {
      final cue = await repo.findOrCreate('왼팔 늦게 내리기');
      await addSessionUsing(
        cue!.id,
        date: DateTime(2026, 9, 1),
        applied: CueApplied.no,
      );
      await addSessionUsing(
        cue.id,
        date: DateTime(2026, 9, 20),
        applied: CueApplied.partial,
      );

      final summary = (await repo.watchSummaries().first).single;
      expect(summary.latestApplied, CueApplied.partial);
    });

    test('적용 결과를 기록한 세션이 없으면 null이다 (배지를 안 보여준다)', () async {
      final cue = await repo.findOrCreate('왼팔 늦게 내리기');
      await addSessionUsing(cue!.id, date: DateTime(2026, 9, 1));

      final summary = (await repo.watchSummaries().first).single;
      expect(summary.latestApplied, isNull);
    });

    test('적용 결과가 비어 있는 세션은 건너뛰고 기록된 것 중 최근 값을 쓴다', () async {
      final cue = await repo.findOrCreate('왼팔 늦게 내리기');
      await addSessionUsing(
        cue!.id,
        date: DateTime(2026, 9, 1),
        applied: CueApplied.yes,
      );
      // 가장 최근 세션이지만 적용 결과를 안 남겼다.
      await addSessionUsing(cue.id, date: DateTime(2026, 9, 20));

      final summary = (await repo.watchSummaries().first).single;
      expect(summary.latestApplied, CueApplied.yes);
    });

    test('검색어로 부분 일치 필터링한다', () async {
      await repo.findOrCreate('왼팔 늦게 내리기');
      await repo.findOrCreate('유닛턴 먼저');

      final filtered = await repo.watchSummaries(query: '왼팔').first;
      expect(filtered.map((s) => s.text), ['왼팔 늦게 내리기']);
    });

    test('검색어가 비어 있으면 전체를 돌려준다', () async {
      await repo.findOrCreate('왼팔 늦게 내리기');
      await repo.findOrCreate('유닛턴 먼저');

      expect(await repo.watchSummaries(query: '  ').first, hasLength(2));
    });

    test('목록은 최근 사용 순이다', () async {
      final first = await repo.findOrCreate('먼저 쓴 큐');
      final second = await repo.findOrCreate('나중에 쓴 큐');
      await repo.touch(first!.id, at: DateTime(2026, 1, 1));
      await repo.touch(second!.id, at: DateTime(2026, 9, 29));

      final summaries = await repo.watchSummaries().first;
      expect(summaries.map((s) => s.text), ['나중에 쓴 큐', '먼저 쓴 큐']);
    });
  });
}
