/// DB 열거형의 화면 표기. UI 문구는 모두 한국어다(CLAUDE.md).
///
/// 열거형 자체는 DB 계층의 것이라 라벨을 거기 두지 않고 presentation에 모은다.
/// 1단계와 2단계 화면이 같은 표기를 쓰도록 한 곳에서만 정한다.
library;

import '../../../core/db/app_database.dart';
import '../../../core/db/enums.dart';

extension SessionTypeLabel on SessionType {
  String get label => switch (this) {
    SessionType.game => '게임',
    SessionType.lesson => '레슨',
    SessionType.practice => '랠리 / 연습',
  };
}

extension SurfaceTypeLabel on SurfaceType {
  String get label => switch (this) {
    SurfaceType.hard => '하드',
    SurfaceType.artificialGrass => '인조잔디',
    SurfaceType.clay => '클레이',
    SurfaceType.other => '기타',
  };
}

extension GameFormatLabel on GameFormat {
  String get label => switch (this) {
    GameFormat.womenDoubles => '여복',
    GameFormat.menDoubles => '남복',
    GameFormat.mixedDoubles => '혼복',
    GameFormat.openDoubles => '잡복',
    GameFormat.singles => '단식',
  };
}

extension LastMealBucketLabel on LastMealBucket {
  String get label => switch (this) {
    LastMealBucket.within1h => '1h 이내',
    LastMealBucket.h1to2 => '1–2h',
    LastMealBucket.h2to3 => '2–3h',
    LastMealBucket.over3 => '3h+',
  };
}

extension CueAppliedLabel on CueApplied {
  String get label => switch (this) {
    CueApplied.yes => '됨',
    CueApplied.partial => '일부',
    CueApplied.no => '안 됨',
  };
}

/// 컨디션은 1~3 정수라서 열거형이 없다(명세의 데이터 모델).
String conditionLabel(int score) => switch (score) {
  1 => '별로',
  2 => '쏘쏘',
  3 => '굿',
  _ => '$score',
};

/// 장소 칩 아래의 보조 줄. 예: `야외 · 하드`
String placeDetailLabel({
  required bool isIndoor,
  required SurfaceType surface,
}) {
  return '${isIndoor ? '실내' : '야외'} · ${surface.label}';
}

/// 스코어 값만. `6 : 4`, 스코어를 모르면 `스코어 모름`.
///
/// 작성 화면은 경기 유형별로 묶어서 보여주므로 유형 이름을 빼고 값만 쓴다.
String scoreValueLabel(Game game) {
  final my = game.myScore;
  final opponent = game.opponentScore;
  if (my == null || opponent == null) return '스코어 모름';
  return '$my : $opponent';
}

/// 내가 이긴 경기인가. 스코어를 모르면 false.
bool isWin(Game game) {
  final my = game.myScore;
  final opponent = game.opponentScore;
  if (my == null || opponent == null) return false;
  return my > opponent;
}

/// 스코어 칩 하나. `혼복 6 : 4`, 스코어를 모르면 `혼복 스코어 모름`.
String scoreLabel(Game game) {
  final my = game.myScore;
  final opponent = game.opponentScore;
  if (my == null || opponent == null) {
    return '${game.format.label} 스코어 모름';
  }
  return '${game.format.label} $my : $opponent';
}
