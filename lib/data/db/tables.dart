import 'package:drift/drift.dart';

import 'enums.dart';

/// 장소. **장소 하나 = 코트 하나**이고, 시설 단위 그룹은 두지 않는다.
/// 같은 시설의 실내/야외 코트는 "귀뚜라미 실내", "귀뚜라미 야외"처럼 별개로 등록한다.
@TableIndex(name: 'places_last_used_at', columns: {#lastUsedAt})
class Places extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 같은 이름의 장소를 두 번 등록하지 못하게 막는다.
  TextColumn get name => text().unique()();

  TextColumn get surface => textEnum<SurfaceType>()();
  BoolColumn get isIndoor => boolean()();

  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  /// 작성 화면의 "최근 사용 순" 장소 칩 정렬에 쓴다.
  DateTimeColumn get lastUsedAt => dateTime().clientDefault(DateTime.now)();
}

/// 큐. 텍스트는 정규화(앞뒤 공백 제거, 연속 공백 하나로)해서 저장하고,
/// 같은 텍스트의 큐가 이미 있으면 그 큐를 재사용한다. 그 재사용을 DB에서
/// 보장하기 위해 유니크를 걸었다.
///
/// 사용 횟수와 최근 적용 결과는 여기 저장하지 않고 sessions에서 계산한다.
@TableIndex(name: 'cues_last_used_at', columns: {#lastUsedAt})
class Cues extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Dart 쪽 이름이 `text`면 drift의 `text()` 빌더와 겹쳐서 쓸 수 없다.
  // 그래서 getter는 `cueText`로 두고 SQL 컬럼명만 `text`로 맞춘다.
  TextColumn get cueText => text().named('text').unique()();

  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastUsedAt => dateTime().clientDefault(DateTime.now)();
}

/// 일지 세션. 한 번의 게임/레슨/연습이 한 행이다.
@TableIndex(name: 'sessions_date', columns: {#date})
@TableIndex(name: 'sessions_status', columns: {#status})
@TableIndex(name: 'sessions_place_id', columns: {#placeId})
@TableIndex(name: 'sessions_cue_id', columns: {#cueId})
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get sessionType =>
      textEnum<SessionType>().withDefault(Constant(SessionType.game.name))();

  /// 날짜만 의미가 있는 값. 로컬 자정으로 정규화해서 넣는다.
  DateTimeColumn get date => dateTime()();

  /// 자정 기준 분. 예: 18:00 → 1080. 범위는 06:00(360)~24:00(1440).
  IntColumn get startMinutes =>
      // drift가 문서화한 check() 관용구. 게터를 스스로 참조하는 모양이지만
      // drift_dev가 lazy 콜백으로 생성하므로 실제 재귀 호출은 일어나지 않는다.
      // ignore: recursive_getters
      integer().nullable().check(startMinutes.isBetweenValues(360, 1440))();
  IntColumn get endMinutes =>
      // drift가 문서화한 check() 관용구. 게터를 스스로 참조하는 모양이지만
      // drift_dev가 lazy 콜백으로 생성하므로 실제 재귀 호출은 일어나지 않는다.
      // ignore: recursive_getters
      integer().nullable().check(endMinutes.isBetweenValues(360, 1440))();

  // 장소는 이 세션과 독립적으로 존재하므로 cascade를 걸지 않는다.
  // (참조 중인 장소를 지우려 하면 DB가 거부한다.)
  IntColumn get placeId => integer().nullable().references(Places, #id)();

  // 저장 시점의 장소 정보 복사본. 장소 정보가 나중에 수정돼도 과거 일지는
  // 그대로 유지돼야 하고, **집계는 이 스냅샷 값으로 한다.**
  TextColumn get surfaceSnapshot => textEnum<SurfaceType>().nullable()();
  BoolColumn get isIndoorSnapshot => boolean().nullable()();
  TextColumn get placeNameSnapshot => text().nullable()();

  /// 1=별로, 2=쏘쏘, 3=굿
  IntColumn get conditionScore =>
      // drift가 문서화한 check() 관용구. 게터를 스스로 참조하는 모양이지만
      // drift_dev가 lazy 콜백으로 생성하므로 실제 재귀 호출은 일어나지 않는다.
      // ignore: recursive_getters
      integer().nullable().check(conditionScore.isBetweenValues(1, 3))();

  TextColumn get lastMealBucket => textEnum<LastMealBucket>().nullable()();

  IntColumn get cueId => integer().nullable().references(Cues, #id)();

  /// 큐를 게임 중 의식적으로 적용했는지
  TextColumn get cueApplied => textEnum<CueApplied>().nullable()();

  TextColumn get status => textEnum<SessionStatus>().withDefault(
    Constant(SessionStatus.draft.name),
  )();

  /// 태그·평가 확인(2단계) 완료 여부
  BoolColumn get tagReviewed => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// 게임. 한 세션에 여러 개 들어간다.
@TableIndex(name: 'games_session_id', columns: {#sessionId})
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 세션에 속한 데이터라 세션이 지워지면 함께 지워진다.
  IntColumn get sessionId =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();

  TextColumn get format => textEnum<GameFormat>()();

  /// 둘 다 null 허용 ("스코어 모름")
  IntColumn get myScore => integer().nullable()();
  IntColumn get opponentScore => integer().nullable()();

  IntColumn get orderIndex => integer()();
}

/// 메모. **메모 한 줄 = 한 행**이고, 조회·집계의 기본 단위다.
@TableIndex(name: 'memos_session_id', columns: {#sessionId})
class Memos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();

  TextColumn get content => text()();
  IntColumn get orderIndex => integer()();

  TextColumn get evaluation => textEnum<MemoEvaluation>().nullable()();

  /// evaluation이 null이면 이 값도 null이다.
  TextColumn get evaluationStatus => textEnum<EvaluationStatus>().nullable()();

  /// 자동 태그·평가 추천을 마지막으로 돌린 시점의 content.
  /// 이 값과 content가 같으면 다시 추천을 돌리지 않는다.
  TextColumn get lastTaggedContent => text().nullable()();

  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// 태그. 메모와는 이름이 아니라 id로 연결한다.
@TableIndex(name: 'tags_category', columns: {#category})
@TableIndex(name: 'tags_parent_tag_id', columns: {#parentTagId})
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get category => textEnum<TagCategory>()();

  /// 예: 백발리의 부모는 발리. 부모 태그로 조회하면 자식도 포함한다.
  /// 자기참조이고, 자식이 가리키는 부모는 지울 수 없게 둔다(cascade 없음).
  IntColumn get parentTagId => integer().nullable().references(Tags, #id)();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
}

/// 태그 인식 표현. 태그 하나에 표현 여러 개가 붙는다.
/// 예: #서브 → "서브", "퍼스트", "세컨", "트로피", "플랫 서브"
///
/// 행 클래스 이름을 직접 지정한 이유: drift는 테이블 이름 끝의 `s`를 떼서 행
/// 클래스 이름을 만드는데, `TagAliases`는 `TagAliase`가 되어 오타처럼 보인다.
/// `TagAlias`로 하면 도메인 모델의 `TagAlias`(태그 엔진 입력)와 이름이 겹치므로
/// `Row` 접미사를 붙여 "DB 행"임을 드러낸다.
@DataClassName('TagAliasRow')
@TableIndex(name: 'tag_aliases_tag_id', columns: {#tagId})
class TagAliases extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  TextColumn get alias => text()();
  TextColumn get confidence => textEnum<AliasConfidence>()();

  // 시드를 여러 번 돌려도 같은 표현이 중복으로 쌓이지 않게 한다.
  // (alias 단독 유니크는 걸지 않는다. 한 표현이 여러 태그에 걸릴 수 있다.)
  @override
  List<Set<Column>> get uniqueKeys => [
    {tagId, alias},
  ];
}

/// 제외 단어. 해당 태그의 인식 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다.
/// 예: #서브의 제외 단어 "서브 리턴", "서브 리시브"
@TableIndex(name: 'tag_exclusions_tag_id', columns: {#tagId})
class TagExclusions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  TextColumn get word => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {tagId, word},
  ];
}

/// 메모-태그 연결. (memoId, tagId) 복합 기본키.
@TableIndex(name: 'memo_tags_tag_id', columns: {#tagId})
class MemoTags extends Table {
  IntColumn get memoId =>
      integer().references(Memos, #id, onDelete: KeyAction.cascade)();

  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  TextColumn get source => textEnum<MemoTagSource>()();
  TextColumn get status => textEnum<MemoTagStatus>()();

  @override
  Set<Column> get primaryKey => {memoId, tagId};
}
