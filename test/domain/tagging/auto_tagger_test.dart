import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/tagging/auto_tagger.dart';
import 'package:tennis_log/domain/tagging/tag_dictionary.dart';

import '../../support/seed_dictionary.dart';

void main() {
  final seed = SeedDictionary.load();
  final tagger = AutoTagger(seed.dictionary);

  /// 붙은 태그 이름 집합. 기대값을 명세 표처럼 읽히게 하려고 이름으로 비교한다.
  Set<String> tagsOf(String memo) =>
      tagger.analyze(memo).tags.map((t) => seed.nameOf(t.tagId)).toSet();

  Map<String, MemoTagStatus> statusesOf(String memo) => {
    for (final tag in tagger.analyze(memo).tags)
      seed.nameOf(tag.tagId): tag.status,
  };

  MemoEvaluation? evaluationOf(String memo) => tagger.analyze(memo).evaluation;

  group('명세 6번 단위 테스트 표', () {
    // 기대 태그는 **정확히 일치**로 본다(명세가 "#포핸드 없음"처럼 빠져야 하는
    // 태그까지 적어 둔 표라서, 집합을 그대로 맞추는 게 명세에 가깝다).
    const cases = <String, Set<String>>{
      '포인트 몇 개 땀': {},
      '서브 더플폴트 3연속': {'서브', '더블폴트'},
      '포스트로크 짧은 게 많았음': {'포핸드', '짧은공'},
      '포 스트로크 짧은 게 많았음': {'포핸드', '짧은공'},
      '서브 리시브 때 몸이 열림': {'리턴', '몸열림'},
      '전위에서 또 다운더라인 맞음ㅠ': {'전위', '다운더라인'},
      '포칭으로 두 번 먹힘': {'포칭'},
      '다운더라인 맞을 때 대기 위치 센터가 맞는지?': {'다운더라인'},
      '세컨 토스 침착하게 올리니까 잘 들어감': {'서브', '토스'},
      '오늘 서브 개굿': {'서브'},
      '백발리 여전히 안 됨ㅠㅠ': {'백발리'},
      '서브는 잘됨 근데 리턴은 안됨': {'서브', '리턴'},
      '스플릿 안 됨ㅠ 왜지?': {'스플릿'},
      '플랫 서브 잘 들어감': {'서브', '플랫'},
      '스핀서브 리턴 어렵다': {'킥', '리턴'},
      '슬라이스 서브 리시브 때 꺾이면서 튐': {'슬라이스', '리턴'},
      '포핸드 탑스핀으로 길게': {'포핸드', '탑스핀'},
      '백핸드 슬라이스 연습': {'백핸드', '슬라이스'},
      '슬라이스 안 읽힘': {'슬라이스', '판단'},
      '백스핀 걸린 짧은 공': {'슬라이스', '짧은공'},
    };

    cases.forEach((memo, expected) {
      test('"$memo" → ${expected.isEmpty ? '태그 없음' : expected.join(', ')}', () {
        expect(tagsOf(memo), expected);
      });
    });

    test('평가 추천', () {
      expect(evaluationOf('전위에서 또 다운더라인 맞음ㅠ'), MemoEvaluation.bad);
      expect(
        evaluationOf('다운더라인 맞을 때 대기 위치 센터가 맞는지?'),
        MemoEvaluation.question,
      );
      expect(evaluationOf('세컨 토스 침착하게 올리니까 잘 들어감'), MemoEvaluation.none);
      expect(evaluationOf('포인트 몇 개 땀'), MemoEvaluation.none);
      expect(evaluationOf('오늘 서브 개굿'), MemoEvaluation.good);
      expect(evaluationOf('백발리 여전히 안 됨ㅠㅠ'), MemoEvaluation.bad);
      expect(evaluationOf('서브는 잘됨 근데 리턴은 안됨'), isNull);
      expect(evaluationOf('스플릿 안 됨ㅠ 왜지?'), MemoEvaluation.question);
    });
  });

  group('붙여 쓴 입력과 ambiguous 처리', () {
    const cases = <String, Set<String>>{
      '플랫서브 잘 들어감': {'서브', '플랫'},
      '슬라이스서브 잘 들어감': {'서브', '슬라이스'},
      '킥서브 더블폴트 2개': {'킥', '서브', '더블폴트'},
      '스핀서브 안 들어감': {'킥', '서브'},
      '왼쪽 어깨 아픔': {'유닛턴'},
    };

    cases.forEach((memo, expected) {
      test('"$memo" → ${expected.join(', ')}', () {
        expect(tagsOf(memo), expected);
      });
    });

    test('"왼쪽 어깨 아픔"의 #유닛턴은 suggested다', () {
      // '왼쪽 어깨'는 ambiguous 표현이다. 부상 메모일 수도 있어서 자동 확정하지
      // 않는다. body의 '어깨'는 긴 표현 우선 규칙으로 차단된다.
      expect(statusesOf('왼쪽 어깨 아픔'), {'유닛턴': MemoTagStatus.suggested});
    });
  });

  group('confidence → status', () {
    test('sure 표현은 confirmed로 붙는다', () {
      expect(statusesOf('오늘 서브 개굿'), {'서브': MemoTagStatus.confirmed});
    });

    test('ambiguous 표현은 suggested로 붙는다', () {
      expect(statusesOf('파트너 때문에 멘탈 흔들림'), {'파트너멘탈': MemoTagStatus.suggested});
    });

    test('한 태그가 sure와 ambiguous에 모두 걸리면 confirmed가 이긴다', () {
      // '어깨 통증'(sure)과 '어깨'(ambiguous)가 서로 다른 위치에서 매칭된다.
      final statuses = statusesOf('어깨 통증 있는데 오른쪽 어깨도 뻐근');
      expect(statuses['어깨·광배'], MemoTagStatus.confirmed);
    });
  });

  group('공백 제거 검색', () {
    test('내부 공백이 있는 표현은 붙여 쓴 입력도 찾는다', () {
      expect(tagsOf('포스트로크 연습'), contains('포핸드'));
      expect(tagsOf('포 스트로크 연습'), contains('포핸드'));
    });

    test('앞뒤 공백이 의도적인 표현은 공백 제거 버전에서 찾지 않는다', () {
      // #수면의 표현은 '잠 '(뒤 공백 포함)이다. 공백을 떼고 찾으면 "잠깐"에
      // 걸려 버린다.
      expect(tagsOf('잠깐 쉬었다'), isNot(contains('수면')));
      expect(tagsOf('잠 못 자서 피곤'), containsAll(<String>['수면', '피로누적']));
    });
  });

  group('제외 단어', () {
    test('매칭 구간이 제외 단어에 완전히 포함되면 태그를 붙이지 않는다', () {
      expect(tagsOf('서브 리턴 때 밀렸다'), {'리턴'});
      expect(tagsOf('서브리시브 연습'), {'리턴'});
    });

    test('일부만 겹쳐도 제외한다', () {
      // '스핀서브'(0–3)와 제외 단어 '서브 리턴'(2–6)은 일부만 겹치는데도
      // #서브를 빼야 한다. 리턴 메모라 내 서브 기술 얘기가 아니다.
      expect(tagsOf('스핀서브 리턴 어렵다'), isNot(contains('서브')));
    });

    test('제외는 태그별이라 같은 구간을 쓰는 다른 태그는 남는다', () {
      // '스핀서브'는 #서브와 #킥이 공유하는 구간인데, 제외 단어는 #서브에만
      // 있다. 상대 서브의 구질(#킥)은 리턴 약점을 집계할 때 쓰므로 남는다.
      expect(tagsOf('스핀서브 리턴 어렵다'), {'킥', '리턴'});
    });

    test('제외로 무시된 매칭은 구간을 점유하지 않는다', () {
      // #서브가 빠져도 그 구간의 '리시브'(#리턴)는 그대로 붙어야 한다.
      expect(tagsOf('슬라이스 서브 리시브 때 꺾이면서 튐'), {'슬라이스', '리턴'});
    });

    test('다른 태그의 제외 단어', () {
      expect(tagsOf('프레임에 맞았다'), isNot(contains('상체프레임')));
      expect(tagsOf('상체 프레임 유지'), contains('상체프레임'));
    });

    test('표현과 제외 단어가 걸쳐 있어도 제외한다', () {
      // '상체프레임'(0–4)과 제외 단어 '프레임에 맞'(2–6)이 일부만 겹친다.
      // 겹침 기준으로 바뀌면서 제외되는 경우다(라켓 프레임 샷 얘기로 본다).
      expect(tagsOf('상체프레임에 맞았다'), isNot(contains('상체프레임')));
    });
  });

  group('구간 차단', () {
    test('긴 표현이 매칭되면 그 안의 짧은 표현은 무시한다', () {
      // '백발리' 안의 '발리'(#발리), '백'으로 다른 태그가 붙지 않는다.
      expect(tagsOf('백발리 연습'), {'백발리'});
    });

    test('부분만 겹치면 둘 다 붙는다', () {
      // '손 힘'(#그립)과 '힘이 들어'(#힘조절)는 일부만 겹친다.
      expect(tagsOf('손 힘이 들어감'), {'그립', '힘조절'});
    });

    test('같은 문자열이 여러 태그에 등록돼 있으면 모두 붙는다', () {
      // '킥서브'는 #서브와 #킥 양쪽에 있다(명세 3-1).
      expect(tagsOf('킥서브 연습'), {'서브', '킥'});
    });
  });

  group('부모·자식 태그', () {
    // 현재 사전에서는 부모 표현이 자식 표현에 포함돼 있어 구간 차단으로 먼저
    // 걸러진다. 그래서 규칙이 발동하는 상황을 작은 사전으로 직접 만든다.
    const parentId = 1;
    const childId = 2;
    final dictionary = TagDictionary(
      entries: [
        TagDictionaryEntry(
          tagId: parentId,
          name: '구질',
          category: TagCategory.technique,
          aliases: const [
            TagAlias(alias: '구질', confidence: AliasConfidence.sure),
          ],
          exclusions: const [],
        ),
        TagDictionaryEntry(
          tagId: childId,
          name: '탑스핀',
          category: TagCategory.technique,
          parentTagId: parentId,
          aliases: const [
            TagAlias(alias: '탑스핀', confidence: AliasConfidence.sure),
          ],
          exclusions: const [],
        ),
      ],
    );
    final childTagger = AutoTagger(dictionary);

    test('자식이 매칭되면 부모는 붙이지 않는다', () {
      final result = childTagger.analyze('구질 중에 탑스핀이 좋았다');
      expect(result.tags.map((t) => t.tagId), [childId]);
    });

    test('자식이 없으면 부모가 그대로 붙는다', () {
      final result = childTagger.analyze('구질 바꿔 봤다');
      expect(result.tags.map((t) => t.tagId), [parentId]);
    });
  });

  group('평가 추천', () {
    test('good 키워드', () {
      for (final memo in ['짱이었음', '굿', '개굿', '잘 됨', '잘됨']) {
        expect(evaluationOf(memo), MemoEvaluation.good, reason: memo);
      }
    });

    test('bad 키워드', () {
      for (final memo in ['안됨', '안 됨', 'ㅠ', 'ㅠㅠ']) {
        expect(evaluationOf(memo), MemoEvaluation.bad, reason: memo);
      }
    });

    test('question이 있으면 다른 평가를 눌러 이긴다', () {
      expect(evaluationOf('잘됨? 안됨?'), MemoEvaluation.question);
      expect(evaluationOf('개굿인데 왜지?'), MemoEvaluation.question);
    });

    test('good과 bad가 동시에 매칭되면 판단 보류(null)', () {
      expect(evaluationOf('서브는 잘됨 근데 리턴은 안됨'), isNull);
    });

    test('키워드가 없으면 none', () {
      expect(evaluationOf('세컨 토스 침착하게 올림'), MemoEvaluation.none);
    });
  });

  group('정규화', () {
    test('연속 공백과 앞뒤 공백을 무시한다', () {
      expect(tagsOf('  서브    더블폴트  '), {'서브', '더블폴트'});
    });

    test('빈 메모는 아무것도 돌려주지 않는다', () {
      final result = tagger.analyze('   ');
      expect(result.tags, isEmpty);
      expect(result.evaluation, isNull);
    });
  });
}
