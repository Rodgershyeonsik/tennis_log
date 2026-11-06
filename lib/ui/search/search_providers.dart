import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/place_repository.dart';
import '../../data/repositories/search_repository.dart';
import '../../domain/search/search_filter.dart';
import '../../domain/search/search_models.dart';
import '../../domain/search/tag_hierarchy.dart';
import 'search_notifier.dart';

part 'search_providers.g.dart';

/// 적용된 필터의 결과 메모.
///
/// 필터를 인자로 받지 않고 안에서 지켜본다. 필터가 바뀌어도 새 결과가 올 때까지
/// 이전 값이 남아서 화면이 깜빡이지 않는다.
@riverpod
Stream<List<SearchMemo>> searchResults(Ref ref) {
  final filter = ref.watch(searchProvider.select((state) => state.filter));
  return ref.watch(searchRepositoryProvider).watchMemos(filter);
}

/// 필터 시트의 "결과 보기 N". 아직 적용하지 않은 조건의 메모 수다.
@riverpod
Stream<int> searchMatchCount(Ref ref, SearchFilter filter) {
  return ref
      .watch(searchRepositoryProvider)
      .watchMemos(filter)
      .map((memos) => memos.length);
}

/// "확인 완료 전 일지 N개는 빠졌어요"의 N.
@riverpod
Stream<int> searchExcludedCount(Ref ref) {
  final scope = ref.watch(searchProvider.select((state) => state.filter.scope));
  return ref.watch(searchRepositoryProvider).watchExcludedSessionCount(scope);
}

@riverpod
Stream<TagHierarchy> searchTagHierarchy(Ref ref) {
  return ref.watch(searchRepositoryProvider).watchTags().map(TagHierarchy.new);
}

/// 장소 전체, 이름 순. drift 행 클래스라 손으로 선언한다(CLAUDE.md).
final searchPlacesProvider = StreamProvider<List<Place>>((ref) {
  return ref.watch(placeRepositoryProvider).watchByName();
});
