// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionListItem {

 int get id; DateTime get date; SessionType get sessionType;/// 저장 시점 스냅샷을 먼저 쓰고, 없으면(아직 저장 안 함) 현재 장소 이름.
/// 장소를 아직 안 골랐으면 null.
 String? get placeName; int get memoCount; SessionStatus get status; bool get tagReviewed;
/// Create a copy of SessionListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionListItemCopyWith<SessionListItem> get copyWith => _$SessionListItemCopyWithImpl<SessionListItem>(this as SessionListItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionListItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.sessionType, _this.sessionType) || other.sessionType == _this.sessionType)&&(identical(other.placeName, _this.placeName) || other.placeName == _this.placeName)&&(identical(other.memoCount, _this.memoCount) || other.memoCount == _this.memoCount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.tagReviewed, _this.tagReviewed) || other.tagReviewed == _this.tagReviewed));
}


@override
int get hashCode {
  final _this = this as SessionListItem;
  return Object.hash(runtimeType,_this.id,_this.date,_this.sessionType,_this.placeName,_this.memoCount,_this.status,_this.tagReviewed);
}

@override
String toString() {
  final _this = this as SessionListItem;
  return 'SessionListItem(id: ${_this.id}, date: ${_this.date}, sessionType: ${_this.sessionType}, placeName: ${_this.placeName}, memoCount: ${_this.memoCount}, status: ${_this.status}, tagReviewed: ${_this.tagReviewed})';
}


}

/// @nodoc
abstract mixin class $SessionListItemCopyWith<$Res>  {
  factory $SessionListItemCopyWith(SessionListItem value, $Res Function(SessionListItem) _then) = _$SessionListItemCopyWithImpl;
@useResult
$Res call({
 int id, DateTime date, SessionType sessionType, String? placeName, int memoCount, SessionStatus status, bool tagReviewed
});




}
/// @nodoc
class _$SessionListItemCopyWithImpl<$Res>
    implements $SessionListItemCopyWith<$Res> {
  _$SessionListItemCopyWithImpl(this._self, this._then);

  final SessionListItem _self;
  final $Res Function(SessionListItem) _then;

/// Create a copy of SessionListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? sessionType = null,Object? placeName = freezed,Object? memoCount = null,Object? status = null,Object? tagReviewed = null,}) {
  return _then(SessionListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,memoCount: null == memoCount ? _self.memoCount : memoCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,tagReviewed: null == tagReviewed ? _self.tagReviewed : tagReviewed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionListItem].
extension SessionListItemPatterns on SessionListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionListItem value)  $default,){
final _that = this;
switch (_that) {
case _SessionListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionListItem value)?  $default,){
final _that = this;
switch (_that) {
case _SessionListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime date,  SessionType sessionType,  String? placeName,  int memoCount,  SessionStatus status,  bool tagReviewed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionListItem() when $default != null:
return $default(_that.id,_that.date,_that.sessionType,_that.placeName,_that.memoCount,_that.status,_that.tagReviewed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime date,  SessionType sessionType,  String? placeName,  int memoCount,  SessionStatus status,  bool tagReviewed)  $default,) {final _that = this;
switch (_that) {
case _SessionListItem():
return $default(_that.id,_that.date,_that.sessionType,_that.placeName,_that.memoCount,_that.status,_that.tagReviewed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime date,  SessionType sessionType,  String? placeName,  int memoCount,  SessionStatus status,  bool tagReviewed)?  $default,) {final _that = this;
switch (_that) {
case _SessionListItem() when $default != null:
return $default(_that.id,_that.date,_that.sessionType,_that.placeName,_that.memoCount,_that.status,_that.tagReviewed);case _:
  return null;

}
}

}

/// @nodoc


class _SessionListItem extends SessionListItem {
  const _SessionListItem({required this.id, required this.date, required this.sessionType, this.placeName, required this.memoCount, required this.status, required this.tagReviewed}): super._();
  

@override final  int id;
@override final  DateTime date;
@override final  SessionType sessionType;
/// 저장 시점 스냅샷을 먼저 쓰고, 없으면(아직 저장 안 함) 현재 장소 이름.
/// 장소를 아직 안 골랐으면 null.
@override final  String? placeName;
@override final  int memoCount;
@override final  SessionStatus status;
@override final  bool tagReviewed;

/// Create a copy of SessionListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionListItemCopyWith<_SessionListItem> get copyWith => __$SessionListItemCopyWithImpl<_SessionListItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.memoCount, memoCount) || other.memoCount == memoCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.tagReviewed, tagReviewed) || other.tagReviewed == tagReviewed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,date,sessionType,placeName,memoCount,status,tagReviewed);
}

@override
String toString() {
    return 'SessionListItem(id: $id, date: $date, sessionType: $sessionType, placeName: $placeName, memoCount: $memoCount, status: $status, tagReviewed: $tagReviewed)';
}


}

/// @nodoc
abstract mixin class _$SessionListItemCopyWith<$Res> implements $SessionListItemCopyWith<$Res> {
  factory _$SessionListItemCopyWith(_SessionListItem value, $Res Function(_SessionListItem) _then) = __$SessionListItemCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime date, SessionType sessionType, String? placeName, int memoCount, SessionStatus status, bool tagReviewed
});




}
/// @nodoc
class __$SessionListItemCopyWithImpl<$Res>
    implements _$SessionListItemCopyWith<$Res> {
  __$SessionListItemCopyWithImpl(this._self, this._then);

  final _SessionListItem _self;
  final $Res Function(_SessionListItem) _then;

/// Create a copy of SessionListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? sessionType = null,Object? placeName = freezed,Object? memoCount = null,Object? status = null,Object? tagReviewed = null,}) {
  return _then(_SessionListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,memoCount: null == memoCount ? _self.memoCount : memoCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,tagReviewed: null == tagReviewed ? _self.tagReviewed : tagReviewed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
