// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionDraft {

 SessionType get sessionType; DateTime get date; int? get startMinutes; int? get endMinutes; int? get placeId;/// 1=별로, 2=쏘쏘, 3=굿
 int? get conditionScore; LastMealBucket? get lastMealBucket;/// 이미 cues 테이블에 만들어진 큐의 id.
/// 입력칸의 **텍스트**는 여기 담지 않는다 — 텍스트를 큐 행으로 바꾸는 시점은
/// 화면이 정한다(`CueRepository.findOrCreate`).
 int? get cueId; CueApplied? get cueApplied;
/// Create a copy of SessionDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDraftCopyWith<SessionDraft> get copyWith => _$SessionDraftCopyWithImpl<SessionDraft>(this as SessionDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDraft&&(identical(other.sessionType, _this.sessionType) || other.sessionType == _this.sessionType)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.startMinutes, _this.startMinutes) || other.startMinutes == _this.startMinutes)&&(identical(other.endMinutes, _this.endMinutes) || other.endMinutes == _this.endMinutes)&&(identical(other.placeId, _this.placeId) || other.placeId == _this.placeId)&&(identical(other.conditionScore, _this.conditionScore) || other.conditionScore == _this.conditionScore)&&(identical(other.lastMealBucket, _this.lastMealBucket) || other.lastMealBucket == _this.lastMealBucket)&&(identical(other.cueId, _this.cueId) || other.cueId == _this.cueId)&&(identical(other.cueApplied, _this.cueApplied) || other.cueApplied == _this.cueApplied));
}


@override
int get hashCode {
  final _this = this as SessionDraft;
  return Object.hash(runtimeType,_this.sessionType,_this.date,_this.startMinutes,_this.endMinutes,_this.placeId,_this.conditionScore,_this.lastMealBucket,_this.cueId,_this.cueApplied);
}

@override
String toString() {
  final _this = this as SessionDraft;
  return 'SessionDraft(sessionType: ${_this.sessionType}, date: ${_this.date}, startMinutes: ${_this.startMinutes}, endMinutes: ${_this.endMinutes}, placeId: ${_this.placeId}, conditionScore: ${_this.conditionScore}, lastMealBucket: ${_this.lastMealBucket}, cueId: ${_this.cueId}, cueApplied: ${_this.cueApplied})';
}


}

/// @nodoc
abstract mixin class $SessionDraftCopyWith<$Res>  {
  factory $SessionDraftCopyWith(SessionDraft value, $Res Function(SessionDraft) _then) = _$SessionDraftCopyWithImpl;
@useResult
$Res call({
 SessionType sessionType, DateTime date, int? startMinutes, int? endMinutes, int? placeId, int? conditionScore, LastMealBucket? lastMealBucket, int? cueId, CueApplied? cueApplied
});




}
/// @nodoc
class _$SessionDraftCopyWithImpl<$Res>
    implements $SessionDraftCopyWith<$Res> {
  _$SessionDraftCopyWithImpl(this._self, this._then);

  final SessionDraft _self;
  final $Res Function(SessionDraft) _then;

/// Create a copy of SessionDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionType = null,Object? date = null,Object? startMinutes = freezed,Object? endMinutes = freezed,Object? placeId = freezed,Object? conditionScore = freezed,Object? lastMealBucket = freezed,Object? cueId = freezed,Object? cueApplied = freezed,}) {
  return _then(SessionDraft(
sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startMinutes: freezed == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int?,endMinutes: freezed == endMinutes ? _self.endMinutes : endMinutes // ignore: cast_nullable_to_non_nullable
as int?,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int?,conditionScore: freezed == conditionScore ? _self.conditionScore : conditionScore // ignore: cast_nullable_to_non_nullable
as int?,lastMealBucket: freezed == lastMealBucket ? _self.lastMealBucket : lastMealBucket // ignore: cast_nullable_to_non_nullable
as LastMealBucket?,cueId: freezed == cueId ? _self.cueId : cueId // ignore: cast_nullable_to_non_nullable
as int?,cueApplied: freezed == cueApplied ? _self.cueApplied : cueApplied // ignore: cast_nullable_to_non_nullable
as CueApplied?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionDraft].
extension SessionDraftPatterns on SessionDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionDraft value)  $default,){
final _that = this;
switch (_that) {
case _SessionDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionDraft value)?  $default,){
final _that = this;
switch (_that) {
case _SessionDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionType sessionType,  DateTime date,  int? startMinutes,  int? endMinutes,  int? placeId,  int? conditionScore,  LastMealBucket? lastMealBucket,  int? cueId,  CueApplied? cueApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionDraft() when $default != null:
return $default(_that.sessionType,_that.date,_that.startMinutes,_that.endMinutes,_that.placeId,_that.conditionScore,_that.lastMealBucket,_that.cueId,_that.cueApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionType sessionType,  DateTime date,  int? startMinutes,  int? endMinutes,  int? placeId,  int? conditionScore,  LastMealBucket? lastMealBucket,  int? cueId,  CueApplied? cueApplied)  $default,) {final _that = this;
switch (_that) {
case _SessionDraft():
return $default(_that.sessionType,_that.date,_that.startMinutes,_that.endMinutes,_that.placeId,_that.conditionScore,_that.lastMealBucket,_that.cueId,_that.cueApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionType sessionType,  DateTime date,  int? startMinutes,  int? endMinutes,  int? placeId,  int? conditionScore,  LastMealBucket? lastMealBucket,  int? cueId,  CueApplied? cueApplied)?  $default,) {final _that = this;
switch (_that) {
case _SessionDraft() when $default != null:
return $default(_that.sessionType,_that.date,_that.startMinutes,_that.endMinutes,_that.placeId,_that.conditionScore,_that.lastMealBucket,_that.cueId,_that.cueApplied);case _:
  return null;

}
}

}

/// @nodoc


class _SessionDraft implements SessionDraft {
  const _SessionDraft({this.sessionType = SessionType.game, required this.date, this.startMinutes, this.endMinutes, this.placeId, this.conditionScore, this.lastMealBucket, this.cueId, this.cueApplied});
  

@override@JsonKey() final  SessionType sessionType;
@override final  DateTime date;
@override final  int? startMinutes;
@override final  int? endMinutes;
@override final  int? placeId;
/// 1=별로, 2=쏘쏘, 3=굿
@override final  int? conditionScore;
@override final  LastMealBucket? lastMealBucket;
/// 이미 cues 테이블에 만들어진 큐의 id.
/// 입력칸의 **텍스트**는 여기 담지 않는다 — 텍스트를 큐 행으로 바꾸는 시점은
/// 화면이 정한다(`CueRepository.findOrCreate`).
@override final  int? cueId;
@override final  CueApplied? cueApplied;

/// Create a copy of SessionDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDraftCopyWith<_SessionDraft> get copyWith => __$SessionDraftCopyWithImpl<_SessionDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDraft&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.date, date) || other.date == date)&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.endMinutes, endMinutes) || other.endMinutes == endMinutes)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.conditionScore, conditionScore) || other.conditionScore == conditionScore)&&(identical(other.lastMealBucket, lastMealBucket) || other.lastMealBucket == lastMealBucket)&&(identical(other.cueId, cueId) || other.cueId == cueId)&&(identical(other.cueApplied, cueApplied) || other.cueApplied == cueApplied));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sessionType,date,startMinutes,endMinutes,placeId,conditionScore,lastMealBucket,cueId,cueApplied);
}

@override
String toString() {
    return 'SessionDraft(sessionType: $sessionType, date: $date, startMinutes: $startMinutes, endMinutes: $endMinutes, placeId: $placeId, conditionScore: $conditionScore, lastMealBucket: $lastMealBucket, cueId: $cueId, cueApplied: $cueApplied)';
}


}

/// @nodoc
abstract mixin class _$SessionDraftCopyWith<$Res> implements $SessionDraftCopyWith<$Res> {
  factory _$SessionDraftCopyWith(_SessionDraft value, $Res Function(_SessionDraft) _then) = __$SessionDraftCopyWithImpl;
@override @useResult
$Res call({
 SessionType sessionType, DateTime date, int? startMinutes, int? endMinutes, int? placeId, int? conditionScore, LastMealBucket? lastMealBucket, int? cueId, CueApplied? cueApplied
});




}
/// @nodoc
class __$SessionDraftCopyWithImpl<$Res>
    implements _$SessionDraftCopyWith<$Res> {
  __$SessionDraftCopyWithImpl(this._self, this._then);

  final _SessionDraft _self;
  final $Res Function(_SessionDraft) _then;

/// Create a copy of SessionDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionType = null,Object? date = null,Object? startMinutes = freezed,Object? endMinutes = freezed,Object? placeId = freezed,Object? conditionScore = freezed,Object? lastMealBucket = freezed,Object? cueId = freezed,Object? cueApplied = freezed,}) {
  return _then(_SessionDraft(
sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startMinutes: freezed == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int?,endMinutes: freezed == endMinutes ? _self.endMinutes : endMinutes // ignore: cast_nullable_to_non_nullable
as int?,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int?,conditionScore: freezed == conditionScore ? _self.conditionScore : conditionScore // ignore: cast_nullable_to_non_nullable
as int?,lastMealBucket: freezed == lastMealBucket ? _self.lastMealBucket : lastMealBucket // ignore: cast_nullable_to_non_nullable
as LastMealBucket?,cueId: freezed == cueId ? _self.cueId : cueId // ignore: cast_nullable_to_non_nullable
as int?,cueApplied: freezed == cueApplied ? _self.cueApplied : cueApplied // ignore: cast_nullable_to_non_nullable
as CueApplied?,
  ));
}


}

// dart format on
