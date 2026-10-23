// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 전체가 공유하는 DB 인스턴스.
///
/// `keepAlive: true`인 이유: DB 커넥션은 화면이 사라질 때마다 닫고 다시 열 게
/// 아니라 앱이 사는 동안 하나만 유지해야 한다. drift의 스트림 쿼리도 같은
/// 인스턴스를 공유해야 갱신이 전파된다.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// 앱 전체가 공유하는 DB 인스턴스.
///
/// `keepAlive: true`인 이유: DB 커넥션은 화면이 사라질 때마다 닫고 다시 열 게
/// 아니라 앱이 사는 동안 하나만 유지해야 한다. drift의 스트림 쿼리도 같은
/// 인스턴스를 공유해야 갱신이 전파된다.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// 앱 전체가 공유하는 DB 인스턴스.
  ///
  /// `keepAlive: true`인 이유: DB 커넥션은 화면이 사라질 때마다 닫고 다시 열 게
  /// 아니라 앱이 사는 동안 하나만 유지해야 한다. drift의 스트림 쿼리도 같은
  /// 인스턴스를 공유해야 갱신이 전파된다.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'8a644d41ebab6efe60fe4fa590d83036f91a7132';
