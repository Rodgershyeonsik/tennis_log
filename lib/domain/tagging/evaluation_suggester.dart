import '../../data/db/enums.dart';

/// 메모 내용으로 평가를 추천한다(명세 `02_tag_review_completion.md` 4번).
///
/// 태그 사전 없이 아래 키워드 상수만 쓰는 순수 함수라 DB 마이그레이션 안에서도
/// 부를 수 있다.
///
/// | 매칭 결과                     | 추천            |
/// | ----------------------------- | --------------- |
/// | question 키워드가 있음        | question        |
/// | good만 있음                   | good            |
/// | bad만 있음                    | bad             |
/// | good과 bad가 둘 다 있음       | null (판단 보류) |
/// | 아무 키워드도 없음            | none            |
///
/// 빈 메모는 판단할 내용이 없으므로 null이다.
MemoEvaluation? suggestEvaluation(String content) {
  final normalized = content
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (normalized.isEmpty) return null;

  bool hasAny(List<String> keywords) => keywords.any(normalized.contains);

  // question이 섞여 있으면 질문으로 본다.
  if (hasAny(_questionKeywords)) return MemoEvaluation.question;

  final good = hasAny(_goodKeywords);
  final bad = hasAny(_badKeywords);

  // 좋고 나쁨이 한 줄에 같이 있으면 판단을 보류한다. none으로 밀어 넣으면
  // "평가할 게 없다"가 되어 버리므로 사용자가 직접 고르게 둔다.
  // 예: "서브는 잘됨 근데 리턴은 안됨"
  if (good && bad) return null;
  if (good) return MemoEvaluation.good;
  if (bad) return MemoEvaluation.bad;
  return MemoEvaluation.none;
}

/// 평가 추천 키워드. 태그 사전과 달리 DB에 두지 않고 상수로 박아 둔다(명세 01 6번).
const _goodKeywords = ['짱', '굿', '개굿', '잘 됨', '잘됨'];
const _badKeywords = ['안됨', '안 됨', 'ㅠ', 'ㅠㅠ'];
const _questionKeywords = ['?'];
