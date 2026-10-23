/// 태그 확인 화면(2단계)이 그리는 조회 전용 프로바이더들.
///
/// **`entry_providers.dart`와 같은 이유로 `@riverpod` 코드 생성을 쓰지 않는다.**
/// riverpod_generator는 drift가 생성한 행 클래스(`Tag` 등)를 프로바이더 반환
/// 타입으로 쓰면 `InvalidTypeException`으로 실패한다.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/repositories/memo_repository.dart';
import '../../../data/repositories/tag_repository.dart';
import '../../../domain/models/memo_with_tags.dart';

/// 메모 + 붙은 태그. 카드 한 장이 한 원소다.
///
/// 조인 쿼리를 watch하므로 태그를 확인·삭제·추가하면 화면이 바로 따라온다
/// (명세 5번: 변경 사항은 즉시 DB에 반영한다).
final sessionMemosWithTagsProvider =
    StreamProvider.family<List<MemoWithTags>, int>((ref, sessionId) {
      return ref.watch(memoRepositoryProvider).watchWithTags(sessionId);
    });

/// 태그 추가 시트의 자동완성 목록. 부분 일치, 이름 순.
final tagSearchProvider = FutureProvider.family<List<Tag>, String>((
  ref,
  query,
) {
  return ref.watch(tagRepositoryProvider).search(query);
});
