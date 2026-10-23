// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftSummary {

 int get id; DateTime get date;/// 장소를 아직 안 골랐으면 null.
 String? get placeName; DateTime get updatedAt;
/// Create a copy of DraftSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftSummaryCopyWith<DraftSummary> get copyWith => _$DraftSummaryCopyWithImpl<DraftSummary>(this as DraftSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DraftSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.placeName, _this.placeName) || other.placeName == _this.placeName)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as DraftSummary;
  return Object.hash(runtimeType,_this.id,_this.date,_this.placeName,_this.updatedAt);
}

@override
String toString() {
  final _this = this as DraftSummary;
  return 'DraftSummary(id: ${_this.id}, date: ${_this.date}, placeName: ${_this.placeName}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $DraftSummaryCopyWith<$Res>  {
  factory $DraftSummaryCopyWith(DraftSummary value, $Res Function(DraftSummary) _then) = _$DraftSummaryCopyWithImpl;
@useResult
$Res call({
 int id, DateTime date, String? placeName, DateTime updatedAt
});




}
/// @nodoc
class _$DraftSummaryCopyWithImpl<$Res>
    implements $DraftSummaryCopyWith<$Res> {
  _$DraftSummaryCopyWithImpl(this._self, this._then);

  final DraftSummary _self;
  final $Res Function(DraftSummary) _then;

/// Create a copy of DraftSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? placeName = freezed,Object? updatedAt = null,}) {
  return _then(DraftSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftSummary].
extension DraftSummaryPatterns on DraftSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftSummary value)  $default,){
final _that = this;
switch (_that) {
case _DraftSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DraftSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime date,  String? placeName,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftSummary() when $default != null:
return $default(_that.id,_that.date,_that.placeName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime date,  String? placeName,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DraftSummary():
return $default(_that.id,_that.date,_that.placeName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime date,  String? placeName,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DraftSummary() when $default != null:
return $default(_that.id,_that.date,_that.placeName,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DraftSummary implements DraftSummary {
  const _DraftSummary({required this.id, required this.date, this.placeName, required this.updatedAt});
  

@override final  int id;
@override final  DateTime date;
/// 장소를 아직 안 골랐으면 null.
@override final  String? placeName;
@override final  DateTime updatedAt;

/// Create a copy of DraftSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftSummaryCopyWith<_DraftSummary> get copyWith => __$DraftSummaryCopyWithImpl<_DraftSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,date,placeName,updatedAt);
}

@override
String toString() {
    return 'DraftSummary(id: $id, date: $date, placeName: $placeName, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DraftSummaryCopyWith<$Res> implements $DraftSummaryCopyWith<$Res> {
  factory _$DraftSummaryCopyWith(_DraftSummary value, $Res Function(_DraftSummary) _then) = __$DraftSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime date, String? placeName, DateTime updatedAt
});




}
/// @nodoc
class __$DraftSummaryCopyWithImpl<$Res>
    implements _$DraftSummaryCopyWith<$Res> {
  __$DraftSummaryCopyWithImpl(this._self, this._then);

  final _DraftSummary _self;
  final $Res Function(_DraftSummary) _then;

/// Create a copy of DraftSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? placeName = freezed,Object? updatedAt = null,}) {
  return _then(_DraftSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
