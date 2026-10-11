// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 메인 화면의 일지 목록. 날짜가 최근인 것부터.
///
/// 반환 타입이 freezed 모델이라 `@riverpod`을 쓸 수 있다 — drift 행 클래스를
/// 돌려주는 프로바이더만 손으로 선언해야 한다(CLAUDE.md).

@ProviderFor(sessionList)
final sessionListProvider = SessionListProvider._();

/// 메인 화면의 일지 목록. 날짜가 최근인 것부터.
///
/// 반환 타입이 freezed 모델이라 `@riverpod`을 쓸 수 있다 — drift 행 클래스를
/// 돌려주는 프로바이더만 손으로 선언해야 한다(CLAUDE.md).

final class SessionListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SessionListItem>>,
          List<SessionListItem>,
          Stream<List<SessionListItem>>
        >
    with
        $FutureModifier<List<SessionListItem>>,
        $StreamProvider<List<SessionListItem>> {
  /// 메인 화면의 일지 목록. 날짜가 최근인 것부터.
  ///
  /// 반환 타입이 freezed 모델이라 `@riverpod`을 쓸 수 있다 — drift 행 클래스를
  /// 돌려주는 프로바이더만 손으로 선언해야 한다(CLAUDE.md).
  SessionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionListHash();

  @$internal
  @override
  $StreamProviderElement<List<SessionListItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SessionListItem>> create(Ref ref) {
    return sessionList(ref);
  }
}

String _$sessionListHash() => r'8118174ec219714a05b39476bdb18fd897502969';
