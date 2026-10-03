// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cue_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CueSummary {

 int get id; String get text;/// 이 큐를 마지막으로 쓴 세션의 날짜. 쓴 세션이 없으면 null.
 DateTime? get lastUsedDate;/// 이 큐를 쓴 세션 수.
 int get useCount;/// 가장 최근 세션에서의 적용 결과. 기록이 없으면 null(배지를 안 보여준다).
 CueApplied? get latestApplied;
/// Create a copy of CueSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CueSummaryCopyWith<CueSummary> get copyWith => _$CueSummaryCopyWithImpl<CueSummary>(this as CueSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CueSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CueSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.lastUsedDate, _this.lastUsedDate) || other.lastUsedDate == _this.lastUsedDate)&&(identical(other.useCount, _this.useCount) || other.useCount == _this.useCount)&&(identical(other.latestApplied, _this.latestApplied) || other.latestApplied == _this.latestApplied));
}


@override
int get hashCode {
  final _this = this as CueSummary;
  return Object.hash(runtimeType,_this.id,_this.text,_this.lastUsedDate,_this.useCount,_this.latestApplied);
}

@override
String toString() {
  final _this = this as CueSummary;
  return 'CueSummary(id: ${_this.id}, text: ${_this.text}, lastUsedDate: ${_this.lastUsedDate}, useCount: ${_this.useCount}, latestApplied: ${_this.latestApplied})';
}


}

/// @nodoc
abstract mixin class $CueSummaryCopyWith<$Res>  {
  factory $CueSummaryCopyWith(CueSummary value, $Res Function(CueSummary) _then) = _$CueSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String text, DateTime? lastUsedDate, int useCount, CueApplied? latestApplied
});




}
/// @nodoc
class _$CueSummaryCopyWithImpl<$Res>
    implements $CueSummaryCopyWith<$Res> {
  _$CueSummaryCopyWithImpl(this._self, this._then);

  final CueSummary _self;
  final $Res Function(CueSummary) _then;

/// Create a copy of CueSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? lastUsedDate = freezed,Object? useCount = null,Object? latestApplied = freezed,}) {
  return _then(CueSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,lastUsedDate: freezed == lastUsedDate ? _self.lastUsedDate : lastUsedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,latestApplied: freezed == latestApplied ? _self.latestApplied : latestApplied // ignore: cast_nullable_to_non_nullable
as CueApplied?,
  ));
}

}


/// Adds pattern-matching-related methods to [CueSummary].
extension CueSummaryPatterns on CueSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CueSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CueSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CueSummary value)  $default,){
final _that = this;
switch (_that) {
case _CueSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CueSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CueSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String text,  DateTime? lastUsedDate,  int useCount,  CueApplied? latestApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CueSummary() when $default != null:
return $default(_that.id,_that.text,_that.lastUsedDate,_that.useCount,_that.latestApplied);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String text,  DateTime? lastUsedDate,  int useCount,  CueApplied? latestApplied)  $default,) {final _that = this;
switch (_that) {
case _CueSummary():
return $default(_that.id,_that.text,_that.lastUsedDate,_that.useCount,_that.latestApplied);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String text,  DateTime? lastUsedDate,  int useCount,  CueApplied? latestApplied)?  $default,) {final _that = this;
switch (_that) {
case _CueSummary() when $default != null:
return $default(_that.id,_that.text,_that.lastUsedDate,_that.useCount,_that.latestApplied);case _:
  return null;

}
}

}

/// @nodoc


class _CueSummary implements CueSummary {
  const _CueSummary({required this.id, required this.text, this.lastUsedDate, required this.useCount, this.latestApplied});
  

@override final  int id;
@override final  String text;
/// 이 큐를 마지막으로 쓴 세션의 날짜. 쓴 세션이 없으면 null.
@override final  DateTime? lastUsedDate;
/// 이 큐를 쓴 세션 수.
@override final  int useCount;
/// 가장 최근 세션에서의 적용 결과. 기록이 없으면 null(배지를 안 보여준다).
@override final  CueApplied? latestApplied;

/// Create a copy of CueSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CueSummaryCopyWith<_CueSummary> get copyWith => __$CueSummaryCopyWithImpl<_CueSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CueSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.lastUsedDate, lastUsedDate) || other.lastUsedDate == lastUsedDate)&&(identical(other.useCount, useCount) || other.useCount == useCount)&&(identical(other.latestApplied, latestApplied) || other.latestApplied == latestApplied));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,text,lastUsedDate,useCount,latestApplied);
}

@override
String toString() {
    return 'CueSummary(id: $id, text: $text, lastUsedDate: $lastUsedDate, useCount: $useCount, latestApplied: $latestApplied)';
}


}

/// @nodoc
abstract mixin class _$CueSummaryCopyWith<$Res> implements $CueSummaryCopyWith<$Res> {
  factory _$CueSummaryCopyWith(_CueSummary value, $Res Function(_CueSummary) _then) = __$CueSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String text, DateTime? lastUsedDate, int useCount, CueApplied? latestApplied
});




}
/// @nodoc
class __$CueSummaryCopyWithImpl<$Res>
    implements _$CueSummaryCopyWith<$Res> {
  __$CueSummaryCopyWithImpl(this._self, this._then);

  final _CueSummary _self;
  final $Res Function(_CueSummary) _then;

/// Create a copy of CueSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? lastUsedDate = freezed,Object? useCount = null,Object? latestApplied = freezed,}) {
  return _then(_CueSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,lastUsedDate: freezed == lastUsedDate ? _self.lastUsedDate : lastUsedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,latestApplied: freezed == latestApplied ? _self.latestApplied : latestApplied // ignore: cast_nullable_to_non_nullable
as CueApplied?,
  ));
}


}

// dart format on
