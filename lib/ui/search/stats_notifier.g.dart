// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 태그 통계 탭의 차트 태그와 선택한 세션. 탭을 바꿔도 남아 있어야 해서 keepAlive다.

@ProviderFor(StatsNotifier)
final statsProvider = StatsNotifierProvider._();

/// 태그 통계 탭의 차트 태그와 선택한 세션. 탭을 바꿔도 남아 있어야 해서 keepAlive다.
final class StatsNotifierProvider
    extends $NotifierProvider<StatsNotifier, StatsState> {
  /// 태그 통계 탭의 차트 태그와 선택한 세션. 탭을 바꿔도 남아 있어야 해서 keepAlive다.
  StatsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsNotifierHash();

  @$internal
  @override
  StatsNotifier create() => StatsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsState>(value),
    );
  }
}

String _$statsNotifierHash() => r'4b1700f401fd120907b9e1dd334d049886df0a2a';

/// 태그 통계 탭의 차트 태그와 선택한 세션. 탭을 바꿔도 남아 있어야 해서 keepAlive다.

abstract class _$StatsNotifier extends $Notifier<StatsState> {
  StatsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StatsState, StatsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatsState, StatsState>,
              StatsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
