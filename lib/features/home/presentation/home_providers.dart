import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../journal/data/session_repository.dart';
import '../../journal/domain/session_list_item.dart';

part 'home_providers.g.dart';

/// 메인 화면의 일지 목록. 날짜가 최근인 것부터.
///
/// 반환 타입이 freezed 모델이라 `@riverpod`을 쓸 수 있다 — drift 행 클래스를
/// 돌려주는 프로바이더만 손으로 선언해야 한다(CLAUDE.md).
@riverpod
Stream<List<SessionListItem>> sessionList(Ref ref) {
  return ref.watch(sessionRepositoryProvider).watchAll();
}
