import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/search/search_filter.dart';
import 'package:tennis_log/ui/search/search_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  SearchNotifier notifier() => container.read(searchProvider.notifier);

  test('요약 칩은 켜고 끄며 필터를 바꾸지 않는다', () {
    notifier().toggleSummaryTag(1);
    notifier().toggleSummaryTag(2);
    notifier().toggleSummaryTag(1);

    final state = container.read(searchProvider);
    expect(state.summaryTagIds, {2});
    expect(state.filter, const SearchFilter());
  });

  test('필터가 바뀌면 좁혀 보기가 풀린다', () {
    notifier().toggleSummaryTag(1);

    notifier().applyFilter(
      const SearchFilter(evaluations: {MemoEvaluation.bad}),
    );

    expect(container.read(searchProvider).summaryTagIds, isEmpty);
  });

  test('같은 필터를 다시 적용하면 좁혀 보기를 유지한다', () {
    notifier().toggleSummaryTag(1);

    notifier().applyFilter(const SearchFilter());

    expect(container.read(searchProvider).summaryTagIds, {1});
  });

  test('태그 버튼의 조건이 바뀌어도 좁혀 보기가 풀린다', () {
    notifier().toggleSummaryTag(1);

    notifier().toggleTag(5);

    expect(container.read(searchProvider).summaryTagIds, isEmpty);
  });
}
