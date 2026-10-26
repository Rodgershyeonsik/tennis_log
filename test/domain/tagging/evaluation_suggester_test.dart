import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/tagging/evaluation_suggester.dart';

/// 평가 추천 결과표(명세 02 4번).
void main() {
  test('question 키워드가 있으면 question', () {
    expect(suggestEvaluation('스플릿 안 됨ㅠ 왜지?'), MemoEvaluation.question);
    expect(suggestEvaluation('잘됨? 안됨?'), MemoEvaluation.question);
  });

  test('good만 있으면 good', () {
    expect(suggestEvaluation('오늘 서브 개굿'), MemoEvaluation.good);
  });

  test('bad만 있으면 bad', () {
    expect(suggestEvaluation('백발리 여전히 안 됨ㅠㅠ'), MemoEvaluation.bad);
  });

  test('good과 bad가 둘 다 있으면 판단 보류(null)', () {
    expect(suggestEvaluation('서브는 잘됨 근데 리턴은 안됨'), isNull);
  });

  test('아무 키워드도 없으면 none', () {
    expect(suggestEvaluation('세컨 토스 침착하게 올리니까 잘 들어감'), MemoEvaluation.none);
    expect(suggestEvaluation('포인트 몇 개 땀'), MemoEvaluation.none);
  });

  test('연속 공백을 무시한다', () {
    expect(suggestEvaluation('서브   잘   됨'), MemoEvaluation.good);
  });

  test('빈 메모는 null', () {
    expect(suggestEvaluation(''), isNull);
    expect(suggestEvaluation('   '), isNull);
  });
}
