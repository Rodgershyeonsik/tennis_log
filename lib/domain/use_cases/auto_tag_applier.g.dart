// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_tag_applier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(autoTagApplier)
final autoTagApplierProvider = AutoTagApplierProvider._();

final class AutoTagApplierProvider
    extends $FunctionalProvider<AutoTagApplier, AutoTagApplier, AutoTagApplier>
    with $Provider<AutoTagApplier> {
  AutoTagApplierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoTagApplierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoTagApplierHash();

  @$internal
  @override
  $ProviderElement<AutoTagApplier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AutoTagApplier create(Ref ref) {
    return autoTagApplier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoTagApplier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoTagApplier>(value),
    );
  }
}

String _$autoTagApplierHash() => r'aa3d17010140d6c6b3d3c3d655c330bf6efaa1e0';
