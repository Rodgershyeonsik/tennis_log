// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
///
/// 자동 저장 규칙(명세 4번):
/// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
/// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
/// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
/// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
///
/// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
/// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).

@ProviderFor(JournalEntryNotifier)
final journalEntryProvider = JournalEntryNotifierFamily._();

/// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
///
/// 자동 저장 규칙(명세 4번):
/// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
/// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
/// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
/// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
///
/// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
/// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).
final class JournalEntryNotifierProvider
    extends $AsyncNotifierProvider<JournalEntryNotifier, JournalEntryState> {
  /// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
  ///
  /// 자동 저장 규칙(명세 4번):
  /// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
  /// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
  /// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
  /// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
  ///
  /// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
  /// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).
  JournalEntryNotifierProvider._({
    required JournalEntryNotifierFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'journalEntryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$journalEntryNotifierHash();

  @override
  String toString() {
    return r'journalEntryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  JournalEntryNotifier create() => JournalEntryNotifier();

  @override
  bool operator ==(Object other) {
    return other is JournalEntryNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$journalEntryNotifierHash() =>
    r'6cef3c308348949bd087daf8094af889f753ab4b';

/// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
///
/// 자동 저장 규칙(명세 4번):
/// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
/// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
/// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
/// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
///
/// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
/// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).

final class JournalEntryNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          JournalEntryNotifier,
          AsyncValue<JournalEntryState>,
          JournalEntryState,
          FutureOr<JournalEntryState>,
          int?
        > {
  JournalEntryNotifierFamily._()
    : super(
        retry: null,
        name: r'journalEntryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
  ///
  /// 자동 저장 규칙(명세 4번):
  /// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
  /// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
  /// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
  /// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
  ///
  /// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
  /// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).

  JournalEntryNotifierProvider call(int? sessionId) =>
      JournalEntryNotifierProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'journalEntryProvider';
}

/// 일지 작성 1단계의 상태와 자동 저장을 담당한다.
///
/// 자동 저장 규칙(명세 4번):
/// - 열기만 하고 아무것도 안 바꾸면 DB에 기록을 만들지 않는다.
/// - 첫 변경에 draft 세션을 만들고, 이후 변경은 0.8초 디바운스로 저장한다.
/// - 페이지를 떠날 때 남은 변경이 있으면 즉시 저장한다.
/// - 필수값 검사는 저장 버튼에서만 한다(자동 저장은 검사 없이 쓴다).
///
/// 게임·메모는 각자 자기 테이블에 바로 쓴다. 쓰고 나서 세션도 한 번 저장해
/// `updatedAt`을 갱신한다(메인 화면의 "작성 중" 목록이 최근 순이라서).

abstract class _$JournalEntryNotifier
    extends $AsyncNotifier<JournalEntryState> {
  late final _$args = ref.$arg as int?;
  int? get sessionId => _$args;

  FutureOr<JournalEntryState> build(int? sessionId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<JournalEntryState>, JournalEntryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<JournalEntryState>, JournalEntryState>,
              AsyncValue<JournalEntryState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
