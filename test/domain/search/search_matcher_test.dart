import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/domain/search/search_matcher.dart';
import 'package:tennis_log/domain/search/search_models.dart';
import 'package:tennis_log/data/db/enums.dart';

void main() {
  SearchSession session(int id, DateTime date, {int? startMinutes}) {
    return SearchSession(
      id: id,
      date: date,
      startMinutes: startMinutes,
      sessionType: SessionType.game,
    );
  }

  List<int> pick(List<SearchSession> sessions, int count) {
    return SearchMatcher.pickRecent(sessions, count).map((s) => s.id).toList();
  }

  test('날짜가 최근인 세션부터 고른다', () {
    final sessions = [
      session(1, DateTime(2026, 10, 1)),
      session(2, DateTime(2026, 10, 3)),
      session(3, DateTime(2026, 10, 2)),
    ];

    expect(pick(sessions, 2), [2, 3]);
  });

  test('같은 날이면 시작 시각이 늦은 세션을 고른다', () {
    final date = DateTime(2026, 10, 1);
    final sessions = [
      session(1, date, startMinutes: 1200),
      session(2, date, startMinutes: 600),
    ];

    expect(pick(sessions, 1), [1]);
  });

  test('날짜와 시각이 같으면 id가 큰 세션을 고른다', () {
    final date = DateTime(2026, 10, 1);
    final sessions = [
      session(1, date, startMinutes: 600),
      session(2, date, startMinutes: 600),
    ];

    expect(pick(sessions, 1), [2]);
  });

  test('같은 날이면 시작 시각이 없는 세션이 뒤로 간다', () {
    final date = DateTime(2026, 10, 1);
    final sessions = [session(2, date), session(1, date, startMinutes: 600)];

    expect(pick(sessions, 1), [1]);
  });

  test('세션이 N개보다 적으면 있는 만큼 고른다', () {
    expect(pick([session(1, DateTime(2026, 10, 1))], 10), [1]);
  });
}
