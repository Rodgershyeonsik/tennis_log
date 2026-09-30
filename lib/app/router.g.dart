// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 라우터.
///
/// `@riverpod`을 붙이면 빌드러너가 `routerProvider`를 만들어 준다.
/// 라우터를 프로바이더로 두면 나중에 "로그인 여부에 따라 리다이렉트" 같은
/// 다른 프로바이더 의존이 생겼을 때 `ref.watch`로 바로 연결할 수 있다.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// 앱 라우터.
///
/// `@riverpod`을 붙이면 빌드러너가 `routerProvider`를 만들어 준다.
/// 라우터를 프로바이더로 두면 나중에 "로그인 여부에 따라 리다이렉트" 같은
/// 다른 프로바이더 의존이 생겼을 때 `ref.watch`로 바로 연결할 수 있다.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// 앱 라우터.
  ///
  /// `@riverpod`을 붙이면 빌드러너가 `routerProvider`를 만들어 준다.
  /// 라우터를 프로바이더로 두면 나중에 "로그인 여부에 따라 리다이렉트" 같은
  /// 다른 프로바이더 의존이 생겼을 때 `ref.watch`로 바로 연결할 수 있다.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'58b361ec921c8d984ffb82468828e9558c918c62';
