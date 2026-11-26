// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StatsState {

/// null이면 태그 전체다.
 int? get chartTagId;/// null이면 최신 세션이다.
 int? get selectedSessionId;
/// Create a copy of StatsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsStateCopyWith<StatsState> get copyWith => _$StatsStateCopyWithImpl<StatsState>(this as StatsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsState&&(identical(other.chartTagId, _this.chartTagId) || other.chartTagId == _this.chartTagId)&&(identical(other.selectedSessionId, _this.selectedSessionId) || other.selectedSessionId == _this.selectedSessionId));
}


@override
int get hashCode {
  final _this = this as StatsState;
  return Object.hash(runtimeType,_this.chartTagId,_this.selectedSessionId);
}

@override
String toString() {
  final _this = this as StatsState;
  return 'StatsState(chartTagId: ${_this.chartTagId}, selectedSessionId: ${_this.selectedSessionId})';
}


}

/// @nodoc
abstract mixin class $StatsStateCopyWith<$Res>  {
  factory $StatsStateCopyWith(StatsState value, $Res Function(StatsState) _then) = _$StatsStateCopyWithImpl;
@useResult
$Res call({
 int? chartTagId, int? selectedSessionId
});




}
/// @nodoc
class _$StatsStateCopyWithImpl<$Res>
    implements $StatsStateCopyWith<$Res> {
  _$StatsStateCopyWithImpl(this._self, this._then);

  final StatsState _self;
  final $Res Function(StatsState) _then;

/// Create a copy of StatsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chartTagId = freezed,Object? selectedSessionId = freezed,}) {
  return _then(StatsState(
chartTagId: freezed == chartTagId ? _self.chartTagId : chartTagId // ignore: cast_nullable_to_non_nullable
as int?,selectedSessionId: freezed == selectedSessionId ? _self.selectedSessionId : selectedSessionId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsState].
extension StatsStatePatterns on StatsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsState value)  $default,){
final _that = this;
switch (_that) {
case _StatsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsState value)?  $default,){
final _that = this;
switch (_that) {
case _StatsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? chartTagId,  int? selectedSessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsState() when $default != null:
return $default(_that.chartTagId,_that.selectedSessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? chartTagId,  int? selectedSessionId)  $default,) {final _that = this;
switch (_that) {
case _StatsState():
return $default(_that.chartTagId,_that.selectedSessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? chartTagId,  int? selectedSessionId)?  $default,) {final _that = this;
switch (_that) {
case _StatsState() when $default != null:
return $default(_that.chartTagId,_that.selectedSessionId);case _:
  return null;

}
}

}

/// @nodoc


class _StatsState implements StatsState {
  const _StatsState({this.chartTagId, this.selectedSessionId});
  

/// null이면 태그 전체다.
@override final  int? chartTagId;
/// null이면 최신 세션이다.
@override final  int? selectedSessionId;

/// Create a copy of StatsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsStateCopyWith<_StatsState> get copyWith => __$StatsStateCopyWithImpl<_StatsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsState&&(identical(other.chartTagId, chartTagId) || other.chartTagId == chartTagId)&&(identical(other.selectedSessionId, selectedSessionId) || other.selectedSessionId == selectedSessionId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,chartTagId,selectedSessionId);
}

@override
String toString() {
    return 'StatsState(chartTagId: $chartTagId, selectedSessionId: $selectedSessionId)';
}


}

/// @nodoc
abstract mixin class _$StatsStateCopyWith<$Res> implements $StatsStateCopyWith<$Res> {
  factory _$StatsStateCopyWith(_StatsState value, $Res Function(_StatsState) _then) = __$StatsStateCopyWithImpl;
@override @useResult
$Res call({
 int? chartTagId, int? selectedSessionId
});




}
/// @nodoc
class __$StatsStateCopyWithImpl<$Res>
    implements _$StatsStateCopyWith<$Res> {
  __$StatsStateCopyWithImpl(this._self, this._then);

  final _StatsState _self;
  final $Res Function(_StatsState) _then;

/// Create a copy of StatsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chartTagId = freezed,Object? selectedSessionId = freezed,}) {
  return _then(_StatsState(
chartTagId: freezed == chartTagId ? _self.chartTagId : chartTagId // ignore: cast_nullable_to_non_nullable
as int?,selectedSessionId: freezed == selectedSessionId ? _self.selectedSessionId : selectedSessionId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
