import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/db/enums.dart';

part 'search_models.freezed.dart';

/// 조회 대상 세션. 카드에 보여줄 값과 세션 단위 필터에 쓸 값을 함께 담는다.
@freezed
abstract class SearchSession with _$SearchSession {
  const factory SearchSession({
    required int id,
    required DateTime date,
    int? startMinutes,
    String? placeNameSnapshot,
    required SessionType sessionType,
    SurfaceType? surfaceSnapshot,
    bool? isIndoorSnapshot,
    int? placeId,
    int? conditionScore,
    CueApplied? cueApplied,
  }) = _SearchSession;
}

/// 조회 결과의 메모 한 건.
@freezed
abstract class SearchMemo with _$SearchMemo {
  const factory SearchMemo({
    required int id,
    required String content,
    required int orderIndex,

    /// 확정된 평가만 담는다. 확정이 아니면 null이다.
    MemoEvaluation? evaluation,
    required SearchSession session,

    /// 확정된 태그만 담는다.
    required List<int> tagIds,
  }) = _SearchMemo;
}

/// 집계와 필터에 쓰는 태그 사전의 한 항목.
///
/// 보관된 태그도 담는다. 과거 메모에는 붙어 있을 수 있어서 이름과 부모가 필요하다.
@freezed
abstract class SearchTag with _$SearchTag {
  const factory SearchTag({
    required int id,
    required String name,
    required TagCategory category,
    int? parentTagId,
    @Default(false) bool isArchived,
  }) = _SearchTag;
}

/// 세션을 최신순으로 비교한다. 날짜, 시작 시각, id가 모두 큰 쪽이 앞이다.
///
/// 시작 시각이 없는 세션은 같은 날의 시각이 있는 세션보다 뒤로 간다.
int compareSessionsNewestFirst(SearchSession a, SearchSession b) {
  final byDate = b.date.compareTo(a.date);
  if (byDate != 0) return byDate;

  final byStart = (b.startMinutes ?? -1).compareTo(a.startMinutes ?? -1);
  if (byStart != 0) return byStart;

  return b.id.compareTo(a.id);
}
