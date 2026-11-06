// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 적용된 필터의 결과 메모.
///
/// 필터를 인자로 받지 않고 안에서 지켜본다. 필터가 바뀌어도 새 결과가 올 때까지
/// 이전 값이 남아서 화면이 깜빡이지 않는다.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// 적용된 필터의 결과 메모.
///
/// 필터를 인자로 받지 않고 안에서 지켜본다. 필터가 바뀌어도 새 결과가 올 때까지
/// 이전 값이 남아서 화면이 깜빡이지 않는다.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SearchMemo>>,
          List<SearchMemo>,
          Stream<List<SearchMemo>>
        >
    with $FutureModifier<List<SearchMemo>>, $StreamProvider<List<SearchMemo>> {
  /// 적용된 필터의 결과 메모.
  ///
  /// 필터를 인자로 받지 않고 안에서 지켜본다. 필터가 바뀌어도 새 결과가 올 때까지
  /// 이전 값이 남아서 화면이 깜빡이지 않는다.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $StreamProviderElement<List<SearchMemo>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SearchMemo>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'035e836e6ba10db8db177ec5f2aebf00d31042af';

/// 필터 시트의 "결과 보기 N". 아직 적용하지 않은 조건의 메모 수다.

@ProviderFor(searchMatchCount)
final searchMatchCountProvider = SearchMatchCountFamily._();

/// 필터 시트의 "결과 보기 N". 아직 적용하지 않은 조건의 메모 수다.

final class SearchMatchCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// 필터 시트의 "결과 보기 N". 아직 적용하지 않은 조건의 메모 수다.
  SearchMatchCountProvider._({
    required SearchMatchCountFamily super.from,
    required SearchFilter super.argument,
  }) : super(
         retry: null,
         name: r'searchMatchCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchMatchCountHash();

  @override
  String toString() {
    return r'searchMatchCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as SearchFilter;
    return searchMatchCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMatchCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchMatchCountHash() => r'6c1050ee1b8a3692b6f49e47a493114ee8708a23';

/// 필터 시트의 "결과 보기 N". 아직 적용하지 않은 조건의 메모 수다.

final class SearchMatchCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, SearchFilter> {
  SearchMatchCountFamily._()
    : super(
        retry: null,
        name: r'searchMatchCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 필터 시트의 "결과 보기 N". 아직 적용하지 않은 조건의 메모 수다.

  SearchMatchCountProvider call(SearchFilter filter) =>
      SearchMatchCountProvider._(argument: filter, from: this);

  @override
  String toString() => r'searchMatchCountProvider';
}

/// "확인 완료 전 일지 N개는 빠졌어요"의 N.

@ProviderFor(searchExcludedCount)
final searchExcludedCountProvider = SearchExcludedCountProvider._();

/// "확인 완료 전 일지 N개는 빠졌어요"의 N.

final class SearchExcludedCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// "확인 완료 전 일지 N개는 빠졌어요"의 N.
  SearchExcludedCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchExcludedCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchExcludedCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return searchExcludedCount(ref);
  }
}

String _$searchExcludedCountHash() =>
    r'c23b20174252b4b5bd08195f62520388d3586d75';

@ProviderFor(searchTagHierarchy)
final searchTagHierarchyProvider = SearchTagHierarchyProvider._();

final class SearchTagHierarchyProvider
    extends
        $FunctionalProvider<
          AsyncValue<TagHierarchy>,
          TagHierarchy,
          Stream<TagHierarchy>
        >
    with $FutureModifier<TagHierarchy>, $StreamProvider<TagHierarchy> {
  SearchTagHierarchyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchTagHierarchyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchTagHierarchyHash();

  @$internal
  @override
  $StreamProviderElement<TagHierarchy> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TagHierarchy> create(Ref ref) {
    return searchTagHierarchy(ref);
  }
}

String _$searchTagHierarchyHash() =>
    r'bdea38911ea965f3eb93ec356ea501db652f273b';
