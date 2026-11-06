// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 조회 화면의 필터와 정렬. 탭을 바꿔도 남아 있어야 해서 keepAlive다.

@ProviderFor(SearchNotifier)
final searchProvider = SearchNotifierProvider._();

/// 조회 화면의 필터와 정렬. 탭을 바꿔도 남아 있어야 해서 keepAlive다.
final class SearchNotifierProvider
    extends $NotifierProvider<SearchNotifier, SearchState> {
  /// 조회 화면의 필터와 정렬. 탭을 바꿔도 남아 있어야 해서 keepAlive다.
  SearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchNotifierHash();

  @$internal
  @override
  SearchNotifier create() => SearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchNotifierHash() => r'cdd30bd942acc2190b60d218835ff3eee3be41a9';

/// 조회 화면의 필터와 정렬. 탭을 바꿔도 남아 있어야 해서 keepAlive다.

abstract class _$SearchNotifier extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchState, SearchState>,
              SearchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
