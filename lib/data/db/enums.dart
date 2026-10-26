/// DB에 저장되는 열거형들.
///
/// drift의 `textEnum<T>()`로 저장하므로 **DB에는 각 값의 `name` 문자열이 그대로
/// 들어간다.** 따라서 이미 저장된 값의 이름을 바꾸거나 값을 삭제하면 기존 데이터를
/// 읽을 수 없게 된다. 이름 변경·삭제가 필요하면 마이그레이션에서 UPDATE로
/// 기존 행을 함께 고쳐야 한다. (값을 새로 **추가**하는 건 안전하다.)
library;

/// 코트 표면
enum SurfaceType { hard, artificialGrass, clay, other }

/// 세션 종류
enum SessionType { game, lesson, practice }

/// 세션 시작 기준, 마지막 식사가 몇 시간 전이었는지
enum LastMealBucket { within1h, h1to2, h2to3, over3 }

/// 큐를 게임 중 의식적으로 적용했는지
enum CueApplied { yes, partial, no }

/// 일지 작성 상태. 메모가 1개 이상이면 complete.
enum SessionStatus { draft, complete }

/// 게임 형태
enum GameFormat { womenDoubles, menDoubles, mixedDoubles, openDoubles, singles }

/// 메모 평가.
///
/// none은 "평가 없음"으로 **확정할 수 있는 값**이다. evaluation이 null인
/// "고르지 않음"(아직 아무도 안 봄)과 다르다. (02에서 추가)
enum MemoEvaluation { good, bad, question, none }

/// 평가가 자동 추천값인지, 사용자가 확인한 값인지.
///
/// confirmed인 평가는 자동 추천이 덮어쓰지 않는다.
enum EvaluationStatus { suggested, confirmed }

/// 태그 분류
enum TagCategory { technique, form, footwork, situation, body, conditionFactor }

/// 태그 인식 표현의 확실성.
///
/// sure면 자동 태그가 confirmed로, ambiguous면 suggested로 붙는다.
enum AliasConfidence { sure, ambiguous }

/// 메모-태그 연결이 자동 태그 엔진이 붙인 것인지, 사용자가 직접 붙인 것인지
enum MemoTagSource { auto, manual }

/// 메모-태그 연결 상태.
///
/// rejected는 사용자가 지운 자동 태그를 기억하는 상태다. 다시 저장해도 같은
/// 태그를 붙이지 않으며 화면에도 표시하지 않는다.
enum MemoTagStatus { confirmed, suggested, rejected }
