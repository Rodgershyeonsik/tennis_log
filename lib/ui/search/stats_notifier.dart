import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/search/search_stats.dart';
import 'search_providers.dart';
import 'stats_state.dart';

part 'stats_notifier.g.dart';

/// 태그 통계 탭의 차트 태그와 선택한 세션. 탭을 바꿔도 남아 있어야 해서 keepAlive다.
@Riverpod(keepAlive: true)
class StatsNotifier extends _$StatsNotifier {
  List<int>? _sessionIds;

  @override
  StatsState build() {
    ref.listen(statsMemosProvider, (_, next) {
      final memos = next.value;
      if (memos == null) return;

      final ids = [
        for (final session in SearchStats.sessionsOf(memos)) session.id,
      ];
      // 세션 목록이 바뀌면 최신 세션으로 돌아간다.
      if (_sessionIds != null && !listEquals(_sessionIds, ids)) {
        state = state.copyWith(selectedSessionId: null);
      }
      _sessionIds = ids;
    });
    return const StatsState();
  }

  void setChartTag(int? tagId) {
    state = state.copyWith(chartTagId: tagId);
  }

  void selectSession(int sessionId) {
    state = state.copyWith(selectedSessionId: sessionId);
  }
}
