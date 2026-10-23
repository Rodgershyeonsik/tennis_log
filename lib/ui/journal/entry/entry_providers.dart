/// 작성 화면이 그리는 조회 전용 프로바이더들.
///
/// 세션이 아직 없으면(= 첫 입력 전) sessionId가 null이고, 그때는 DB를 보지 않고
/// 빈 목록을 돌려준다. 명세 4번의 "열기만 하면 기록을 만들지 않는다"를 지키려면
/// 조회 쪽도 세션을 만들지 않아야 한다.
///
/// **이 파일만 `@riverpod` 코드 생성을 쓰지 않는다.** riverpod_generator가 drift의
/// 생성 클래스(`Memo`, `Game`, `Place`, `Cue`)를 프로바이더 반환 타입으로 쓰면
/// `InvalidTypeException`으로 실패한다 — 그 클래스들이 `app_database.g.dart`의
/// part 안에 선언돼 있어서 생성기가 타입을 코드로 적지 못한다(typedef로 감싸도
/// 같다). 리포지토리를 감싸는 얇은 프로바이더뿐이라, 손으로 선언하는 쪽이
/// 행 클래스를 그대로 쓰는 다른 코드와도 맞고 단순하다.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/repositories/cue_repository.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/repositories/memo_repository.dart';
import '../../../data/repositories/place_repository.dart';
import '../../../domain/models/cue_summary.dart';

/// 메모 목록. 조회·집계의 기본 단위라 순서(orderIndex)대로 온다.
final sessionMemosProvider = StreamProvider.family<List<Memo>, int?>((
  ref,
  sessionId,
) {
  if (sessionId == null) return Stream.value(const []);
  return ref.watch(memoRepositoryProvider).watchBySession(sessionId);
});

final sessionGamesProvider = StreamProvider.family<List<Game>, int?>((
  ref,
  sessionId,
) {
  if (sessionId == null) return Stream.value(const []);
  return ref.watch(gameRepositoryProvider).watchBySession(sessionId);
});

/// 장소 칩. 최근 사용 순 4개(명세 3번).
final recentPlacesProvider = StreamProvider<List<Place>>((ref) {
  return ref.watch(placeRepositoryProvider).watchRecent();
});

/// 장소 더보기 시트의 목록. 이름 오름차순 + 부분 일치 필터.
final placeSearchProvider = StreamProvider.family<List<Place>, String>((
  ref,
  query,
) {
  return ref.watch(placeRepositoryProvider).watchByName(query: query);
});

/// 선택된 장소. 칩 아래 "야외 · 하드" 줄에 쓴다.
final selectedPlaceProvider = FutureProvider.family<Place?, int?>((
  ref,
  placeId,
) {
  if (placeId == null) return Future.value();
  return ref.watch(placeRepositoryProvider).findById(placeId);
});

/// 큐 입력칸 아래의 "지난 큐". 없으면 null(화면에서 숨긴다).
final lastUsedCueProvider = FutureProvider<Cue?>((ref) {
  return ref.watch(cueRepositoryProvider).mostRecent();
});

/// "지난 큐 불러오기" 시트의 목록. query는 부분 일치 필터다.
final cueSummariesProvider = StreamProvider.family<List<CueSummary>, String>((
  ref,
  query,
) {
  return ref.watch(cueRepositoryProvider).watchSummaries(query: query);
});
