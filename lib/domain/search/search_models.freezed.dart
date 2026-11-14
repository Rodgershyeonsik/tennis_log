// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchSession {

 int get id; DateTime get date; int? get startMinutes; String? get placeNameSnapshot; SessionType get sessionType; SurfaceType? get surfaceSnapshot; bool? get isIndoorSnapshot; int? get placeId; int? get conditionScore; CueApplied? get cueApplied;
/// Create a copy of SearchSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSessionCopyWith<SearchSession> get copyWith => _$SearchSessionCopyWithImpl<SearchSession>(this as SearchSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.startMinutes, _this.startMinutes) || other.startMinutes == _this.startMinutes)&&(identical(other.placeNameSnapshot, _this.placeNameSnapshot) || other.placeNameSnapshot == _this.placeNameSnapshot)&&(identical(other.sessionType, _this.sessionType) || other.sessionType == _this.sessionType)&&(identical(other.surfaceSnapshot, _this.surfaceSnapshot) || other.surfaceSnapshot == _this.surfaceSnapshot)&&(identical(other.isIndoorSnapshot, _this.isIndoorSnapshot) || other.isIndoorSnapshot == _this.isIndoorSnapshot)&&(identical(other.placeId, _this.placeId) || other.placeId == _this.placeId)&&(identical(other.conditionScore, _this.conditionScore) || other.conditionScore == _this.conditionScore)&&(identical(other.cueApplied, _this.cueApplied) || other.cueApplied == _this.cueApplied));
}


@override
int get hashCode {
  final _this = this as SearchSession;
  return Object.hash(runtimeType,_this.id,_this.date,_this.startMinutes,_this.placeNameSnapshot,_this.sessionType,_this.surfaceSnapshot,_this.isIndoorSnapshot,_this.placeId,_this.conditionScore,_this.cueApplied);
}

@override
String toString() {
  final _this = this as SearchSession;
  return 'SearchSession(id: ${_this.id}, date: ${_this.date}, startMinutes: ${_this.startMinutes}, placeNameSnapshot: ${_this.placeNameSnapshot}, sessionType: ${_this.sessionType}, surfaceSnapshot: ${_this.surfaceSnapshot}, isIndoorSnapshot: ${_this.isIndoorSnapshot}, placeId: ${_this.placeId}, conditionScore: ${_this.conditionScore}, cueApplied: ${_this.cueApplied})';
}


}

/// @nodoc
abstract mixin class $SearchSessionCopyWith<$Res>  {
  factory $SearchSessionCopyWith(SearchSession value, $Res Function(SearchSession) _then) = _$SearchSessionCopyWithImpl;
@useResult
$Res call({
 int id, DateTime date, int? startMinutes, String? placeNameSnapshot, SessionType sessionType, SurfaceType? surfaceSnapshot, bool? isIndoorSnapshot, int? placeId, int? conditionScore, CueApplied? cueApplied
});




}
/// @nodoc
class _$SearchSessionCopyWithImpl<$Res>
    implements $SearchSessionCopyWith<$Res> {
  _$SearchSessionCopyWithImpl(this._self, this._then);

  final SearchSession _self;
  final $Res Function(SearchSession) _then;

/// Create a copy of SearchSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? startMinutes = freezed,Object? placeNameSnapshot = freezed,Object? sessionType = null,Object? surfaceSnapshot = freezed,Object? isIndoorSnapshot = freezed,Object? placeId = freezed,Object? conditionScore = freezed,Object? cueApplied = freezed,}) {
  return _then(SearchSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startMinutes: freezed == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int?,placeNameSnapshot: freezed == placeNameSnapshot ? _self.placeNameSnapshot : placeNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,surfaceSnapshot: freezed == surfaceSnapshot ? _self.surfaceSnapshot : surfaceSnapshot // ignore: cast_nullable_to_non_nullable
as SurfaceType?,isIndoorSnapshot: freezed == isIndoorSnapshot ? _self.isIndoorSnapshot : isIndoorSnapshot // ignore: cast_nullable_to_non_nullable
as bool?,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int?,conditionScore: freezed == conditionScore ? _self.conditionScore : conditionScore // ignore: cast_nullable_to_non_nullable
as int?,cueApplied: freezed == cueApplied ? _self.cueApplied : cueApplied // ignore: cast_nullable_to_non_nullable
as CueApplied?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchSession].
extension SearchSessionPatterns on SearchSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchSession value)  $default,){
final _that = this;
switch (_that) {
case _SearchSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchSession value)?  $default,){
final _that = this;
switch (_that) {
case _SearchSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime date,  int? startMinutes,  String? placeNameSnapshot,  SessionType sessionType,  SurfaceType? surfaceSnapshot,  bool? isIndoorSnapshot,  int? placeId,  int? conditionScore,  CueApplied? cueApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchSession() when $default != null:
return $default(_that.id,_that.date,_that.startMinutes,_that.placeNameSnapshot,_that.sessionType,_that.surfaceSnapshot,_that.isIndoorSnapshot,_that.placeId,_that.conditionScore,_that.cueApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime date,  int? startMinutes,  String? placeNameSnapshot,  SessionType sessionType,  SurfaceType? surfaceSnapshot,  bool? isIndoorSnapshot,  int? placeId,  int? conditionScore,  CueApplied? cueApplied)  $default,) {final _that = this;
switch (_that) {
case _SearchSession():
return $default(_that.id,_that.date,_that.startMinutes,_that.placeNameSnapshot,_that.sessionType,_that.surfaceSnapshot,_that.isIndoorSnapshot,_that.placeId,_that.conditionScore,_that.cueApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime date,  int? startMinutes,  String? placeNameSnapshot,  SessionType sessionType,  SurfaceType? surfaceSnapshot,  bool? isIndoorSnapshot,  int? placeId,  int? conditionScore,  CueApplied? cueApplied)?  $default,) {final _that = this;
switch (_that) {
case _SearchSession() when $default != null:
return $default(_that.id,_that.date,_that.startMinutes,_that.placeNameSnapshot,_that.sessionType,_that.surfaceSnapshot,_that.isIndoorSnapshot,_that.placeId,_that.conditionScore,_that.cueApplied);case _:
  return null;

}
}

}

/// @nodoc


class _SearchSession implements SearchSession {
  const _SearchSession({required this.id, required this.date, this.startMinutes, this.placeNameSnapshot, required this.sessionType, this.surfaceSnapshot, this.isIndoorSnapshot, this.placeId, this.conditionScore, this.cueApplied});
  

@override final  int id;
@override final  DateTime date;
@override final  int? startMinutes;
@override final  String? placeNameSnapshot;
@override final  SessionType sessionType;
@override final  SurfaceType? surfaceSnapshot;
@override final  bool? isIndoorSnapshot;
@override final  int? placeId;
@override final  int? conditionScore;
@override final  CueApplied? cueApplied;

/// Create a copy of SearchSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchSessionCopyWith<_SearchSession> get copyWith => __$SearchSessionCopyWithImpl<_SearchSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchSession&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.startMinutes, startMinutes) || other.startMinutes == startMinutes)&&(identical(other.placeNameSnapshot, placeNameSnapshot) || other.placeNameSnapshot == placeNameSnapshot)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.surfaceSnapshot, surfaceSnapshot) || other.surfaceSnapshot == surfaceSnapshot)&&(identical(other.isIndoorSnapshot, isIndoorSnapshot) || other.isIndoorSnapshot == isIndoorSnapshot)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.conditionScore, conditionScore) || other.conditionScore == conditionScore)&&(identical(other.cueApplied, cueApplied) || other.cueApplied == cueApplied));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,date,startMinutes,placeNameSnapshot,sessionType,surfaceSnapshot,isIndoorSnapshot,placeId,conditionScore,cueApplied);
}

@override
String toString() {
    return 'SearchSession(id: $id, date: $date, startMinutes: $startMinutes, placeNameSnapshot: $placeNameSnapshot, sessionType: $sessionType, surfaceSnapshot: $surfaceSnapshot, isIndoorSnapshot: $isIndoorSnapshot, placeId: $placeId, conditionScore: $conditionScore, cueApplied: $cueApplied)';
}


}

/// @nodoc
abstract mixin class _$SearchSessionCopyWith<$Res> implements $SearchSessionCopyWith<$Res> {
  factory _$SearchSessionCopyWith(_SearchSession value, $Res Function(_SearchSession) _then) = __$SearchSessionCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime date, int? startMinutes, String? placeNameSnapshot, SessionType sessionType, SurfaceType? surfaceSnapshot, bool? isIndoorSnapshot, int? placeId, int? conditionScore, CueApplied? cueApplied
});




}
/// @nodoc
class __$SearchSessionCopyWithImpl<$Res>
    implements _$SearchSessionCopyWith<$Res> {
  __$SearchSessionCopyWithImpl(this._self, this._then);

  final _SearchSession _self;
  final $Res Function(_SearchSession) _then;

/// Create a copy of SearchSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? startMinutes = freezed,Object? placeNameSnapshot = freezed,Object? sessionType = null,Object? surfaceSnapshot = freezed,Object? isIndoorSnapshot = freezed,Object? placeId = freezed,Object? conditionScore = freezed,Object? cueApplied = freezed,}) {
  return _then(_SearchSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startMinutes: freezed == startMinutes ? _self.startMinutes : startMinutes // ignore: cast_nullable_to_non_nullable
as int?,placeNameSnapshot: freezed == placeNameSnapshot ? _self.placeNameSnapshot : placeNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,surfaceSnapshot: freezed == surfaceSnapshot ? _self.surfaceSnapshot : surfaceSnapshot // ignore: cast_nullable_to_non_nullable
as SurfaceType?,isIndoorSnapshot: freezed == isIndoorSnapshot ? _self.isIndoorSnapshot : isIndoorSnapshot // ignore: cast_nullable_to_non_nullable
as bool?,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int?,conditionScore: freezed == conditionScore ? _self.conditionScore : conditionScore // ignore: cast_nullable_to_non_nullable
as int?,cueApplied: freezed == cueApplied ? _self.cueApplied : cueApplied // ignore: cast_nullable_to_non_nullable
as CueApplied?,
  ));
}


}

/// @nodoc
mixin _$SearchMemo {

 int get id; String get content; int get orderIndex;/// 확정된 평가만 담는다. 확정이 아니면 null이다.
 MemoEvaluation? get evaluation; SearchSession get session;/// 확정된 태그만 담는다.
 List<int> get tagIds;
/// Create a copy of SearchMemo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchMemoCopyWith<SearchMemo> get copyWith => _$SearchMemoCopyWithImpl<SearchMemo>(this as SearchMemo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchMemo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchMemo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.orderIndex, _this.orderIndex) || other.orderIndex == _this.orderIndex)&&(identical(other.evaluation, _this.evaluation) || other.evaluation == _this.evaluation)&&(identical(other.session, _this.session) || other.session == _this.session)&&const DeepCollectionEquality().equals(other.tagIds, _this.tagIds));
}


@override
int get hashCode {
  final _this = this as SearchMemo;
  return Object.hash(runtimeType,_this.id,_this.content,_this.orderIndex,_this.evaluation,_this.session,const DeepCollectionEquality().hash(_this.tagIds));
}

@override
String toString() {
  final _this = this as SearchMemo;
  return 'SearchMemo(id: ${_this.id}, content: ${_this.content}, orderIndex: ${_this.orderIndex}, evaluation: ${_this.evaluation}, session: ${_this.session}, tagIds: ${_this.tagIds})';
}


}

/// @nodoc
abstract mixin class $SearchMemoCopyWith<$Res>  {
  factory $SearchMemoCopyWith(SearchMemo value, $Res Function(SearchMemo) _then) = _$SearchMemoCopyWithImpl;
@useResult
$Res call({
 int id, String content, int orderIndex, MemoEvaluation? evaluation, SearchSession session, List<int> tagIds
});


$SearchSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$SearchMemoCopyWithImpl<$Res>
    implements $SearchMemoCopyWith<$Res> {
  _$SearchMemoCopyWithImpl(this._self, this._then);

  final SearchMemo _self;
  final $Res Function(SearchMemo) _then;

/// Create a copy of SearchMemo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? orderIndex = null,Object? evaluation = freezed,Object? session = null,Object? tagIds = null,}) {
  return _then(SearchMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,evaluation: freezed == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as MemoEvaluation?,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SearchSession,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of SearchMemo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchSessionCopyWith<$Res> get session {
  
  return $SearchSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchMemo].
extension SearchMemoPatterns on SearchMemo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchMemo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchMemo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchMemo value)  $default,){
final _that = this;
switch (_that) {
case _SearchMemo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchMemo value)?  $default,){
final _that = this;
switch (_that) {
case _SearchMemo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String content,  int orderIndex,  MemoEvaluation? evaluation,  SearchSession session,  List<int> tagIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchMemo() when $default != null:
return $default(_that.id,_that.content,_that.orderIndex,_that.evaluation,_that.session,_that.tagIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String content,  int orderIndex,  MemoEvaluation? evaluation,  SearchSession session,  List<int> tagIds)  $default,) {final _that = this;
switch (_that) {
case _SearchMemo():
return $default(_that.id,_that.content,_that.orderIndex,_that.evaluation,_that.session,_that.tagIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String content,  int orderIndex,  MemoEvaluation? evaluation,  SearchSession session,  List<int> tagIds)?  $default,) {final _that = this;
switch (_that) {
case _SearchMemo() when $default != null:
return $default(_that.id,_that.content,_that.orderIndex,_that.evaluation,_that.session,_that.tagIds);case _:
  return null;

}
}

}

/// @nodoc


class _SearchMemo implements SearchMemo {
  const _SearchMemo({required this.id, required this.content, required this.orderIndex, this.evaluation, required this.session, required  List<int> tagIds}): _tagIds = tagIds;
  

@override final  int id;
@override final  String content;
@override final  int orderIndex;
/// 확정된 평가만 담는다. 확정이 아니면 null이다.
@override final  MemoEvaluation? evaluation;
@override final  SearchSession session;
/// 확정된 태그만 담는다.
 final  List<int> _tagIds;
/// 확정된 태그만 담는다.
@override List<int> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}


/// Create a copy of SearchMemo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchMemoCopyWith<_SearchMemo> get copyWith => __$SearchMemoCopyWithImpl<_SearchMemo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.evaluation, evaluation) || other.evaluation == evaluation)&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.tagIds, _tagIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,content,orderIndex,evaluation,session,const DeepCollectionEquality().hash(_tagIds));
}

@override
String toString() {
    return 'SearchMemo(id: $id, content: $content, orderIndex: $orderIndex, evaluation: $evaluation, session: $session, tagIds: $tagIds)';
}


}

/// @nodoc
abstract mixin class _$SearchMemoCopyWith<$Res> implements $SearchMemoCopyWith<$Res> {
  factory _$SearchMemoCopyWith(_SearchMemo value, $Res Function(_SearchMemo) _then) = __$SearchMemoCopyWithImpl;
@override @useResult
$Res call({
 int id, String content, int orderIndex, MemoEvaluation? evaluation, SearchSession session, List<int> tagIds
});


@override $SearchSessionCopyWith<$Res> get session;

}
/// @nodoc
class __$SearchMemoCopyWithImpl<$Res>
    implements _$SearchMemoCopyWith<$Res> {
  __$SearchMemoCopyWithImpl(this._self, this._then);

  final _SearchMemo _self;
  final $Res Function(_SearchMemo) _then;

/// Create a copy of SearchMemo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? orderIndex = null,Object? evaluation = freezed,Object? session = null,Object? tagIds = null,}) {
  return _then(_SearchMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,evaluation: freezed == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as MemoEvaluation?,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SearchSession,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of SearchMemo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchSessionCopyWith<$Res> get session {
  
  return $SearchSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc
mixin _$SearchTag {

 int get id; String get name; TagCategory get category; int? get parentTagId; bool get isArchived;
/// Create a copy of SearchTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchTagCopyWith<SearchTag> get copyWith => _$SearchTagCopyWithImpl<SearchTag>(this as SearchTag, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchTag&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.parentTagId, _this.parentTagId) || other.parentTagId == _this.parentTagId)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived));
}


@override
int get hashCode {
  final _this = this as SearchTag;
  return Object.hash(runtimeType,_this.id,_this.name,_this.category,_this.parentTagId,_this.isArchived);
}

@override
String toString() {
  final _this = this as SearchTag;
  return 'SearchTag(id: ${_this.id}, name: ${_this.name}, category: ${_this.category}, parentTagId: ${_this.parentTagId}, isArchived: ${_this.isArchived})';
}


}

/// @nodoc
abstract mixin class $SearchTagCopyWith<$Res>  {
  factory $SearchTagCopyWith(SearchTag value, $Res Function(SearchTag) _then) = _$SearchTagCopyWithImpl;
@useResult
$Res call({
 int id, String name, TagCategory category, int? parentTagId, bool isArchived
});




}
/// @nodoc
class _$SearchTagCopyWithImpl<$Res>
    implements $SearchTagCopyWith<$Res> {
  _$SearchTagCopyWithImpl(this._self, this._then);

  final SearchTag _self;
  final $Res Function(SearchTag) _then;

/// Create a copy of SearchTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? parentTagId = freezed,Object? isArchived = null,}) {
  return _then(SearchTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,parentTagId: freezed == parentTagId ? _self.parentTagId : parentTagId // ignore: cast_nullable_to_non_nullable
as int?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchTag].
extension SearchTagPatterns on SearchTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchTag value)  $default,){
final _that = this;
switch (_that) {
case _SearchTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchTag value)?  $default,){
final _that = this;
switch (_that) {
case _SearchTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  TagCategory category,  int? parentTagId,  bool isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchTag() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.parentTagId,_that.isArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  TagCategory category,  int? parentTagId,  bool isArchived)  $default,) {final _that = this;
switch (_that) {
case _SearchTag():
return $default(_that.id,_that.name,_that.category,_that.parentTagId,_that.isArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  TagCategory category,  int? parentTagId,  bool isArchived)?  $default,) {final _that = this;
switch (_that) {
case _SearchTag() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.parentTagId,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc


class _SearchTag implements SearchTag {
  const _SearchTag({required this.id, required this.name, required this.category, this.parentTagId, this.isArchived = false});
  

@override final  int id;
@override final  String name;
@override final  TagCategory category;
@override final  int? parentTagId;
@override@JsonKey() final  bool isArchived;

/// Create a copy of SearchTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchTagCopyWith<_SearchTag> get copyWith => __$SearchTagCopyWithImpl<_SearchTag>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchTag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.parentTagId, parentTagId) || other.parentTagId == parentTagId)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,category,parentTagId,isArchived);
}

@override
String toString() {
    return 'SearchTag(id: $id, name: $name, category: $category, parentTagId: $parentTagId, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$SearchTagCopyWith<$Res> implements $SearchTagCopyWith<$Res> {
  factory _$SearchTagCopyWith(_SearchTag value, $Res Function(_SearchTag) _then) = __$SearchTagCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, TagCategory category, int? parentTagId, bool isArchived
});




}
/// @nodoc
class __$SearchTagCopyWithImpl<$Res>
    implements _$SearchTagCopyWith<$Res> {
  __$SearchTagCopyWithImpl(this._self, this._then);

  final _SearchTag _self;
  final $Res Function(_SearchTag) _then;

/// Create a copy of SearchTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? parentTagId = freezed,Object? isArchived = null,}) {
  return _then(_SearchTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,parentTagId: freezed == parentTagId ? _self.parentTagId : parentTagId // ignore: cast_nullable_to_non_nullable
as int?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SessionDetail {

 Session get session;/// 큐가 없으면 null이다.
 String? get cueText;/// 입력 순(orderIndex)이다.
 List<Game> get games;/// 쓴 순서(orderIndex)다.
 List<SessionDetailMemo> get memos;
/// Create a copy of SessionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDetailCopyWith<SessionDetail> get copyWith => _$SessionDetailCopyWithImpl<SessionDetail>(this as SessionDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDetail&&const DeepCollectionEquality().equals(other.session, _this.session)&&(identical(other.cueText, _this.cueText) || other.cueText == _this.cueText)&&const DeepCollectionEquality().equals(other.games, _this.games)&&const DeepCollectionEquality().equals(other.memos, _this.memos));
}


@override
int get hashCode {
  final _this = this as SessionDetail;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.session),_this.cueText,const DeepCollectionEquality().hash(_this.games),const DeepCollectionEquality().hash(_this.memos));
}

@override
String toString() {
  final _this = this as SessionDetail;
  return 'SessionDetail(session: ${_this.session}, cueText: ${_this.cueText}, games: ${_this.games}, memos: ${_this.memos})';
}


}

/// @nodoc
abstract mixin class $SessionDetailCopyWith<$Res>  {
  factory $SessionDetailCopyWith(SessionDetail value, $Res Function(SessionDetail) _then) = _$SessionDetailCopyWithImpl;
@useResult
$Res call({
 Session session, String? cueText, List<Game> games, List<SessionDetailMemo> memos
});




}
/// @nodoc
class _$SessionDetailCopyWithImpl<$Res>
    implements $SessionDetailCopyWith<$Res> {
  _$SessionDetailCopyWithImpl(this._self, this._then);

  final SessionDetail _self;
  final $Res Function(SessionDetail) _then;

/// Create a copy of SessionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = freezed,Object? cueText = freezed,Object? games = null,Object? memos = null,}) {
  return _then(SessionDetail(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,cueText: freezed == cueText ? _self.cueText : cueText // ignore: cast_nullable_to_non_nullable
as String?,games: null == games ? _self.games : games // ignore: cast_nullable_to_non_nullable
as List<Game>,memos: null == memos ? _self.memos : memos // ignore: cast_nullable_to_non_nullable
as List<SessionDetailMemo>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionDetail].
extension SessionDetailPatterns on SessionDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionDetail value)  $default,){
final _that = this;
switch (_that) {
case _SessionDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SessionDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Session session,  String? cueText,  List<Game> games,  List<SessionDetailMemo> memos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionDetail() when $default != null:
return $default(_that.session,_that.cueText,_that.games,_that.memos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Session session,  String? cueText,  List<Game> games,  List<SessionDetailMemo> memos)  $default,) {final _that = this;
switch (_that) {
case _SessionDetail():
return $default(_that.session,_that.cueText,_that.games,_that.memos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Session session,  String? cueText,  List<Game> games,  List<SessionDetailMemo> memos)?  $default,) {final _that = this;
switch (_that) {
case _SessionDetail() when $default != null:
return $default(_that.session,_that.cueText,_that.games,_that.memos);case _:
  return null;

}
}

}

/// @nodoc


class _SessionDetail implements SessionDetail {
  const _SessionDetail({required this.session, this.cueText, required  List<Game> games, required  List<SessionDetailMemo> memos}): _games = games,_memos = memos;
  

@override final  Session session;
/// 큐가 없으면 null이다.
@override final  String? cueText;
/// 입력 순(orderIndex)이다.
 final  List<Game> _games;
/// 입력 순(orderIndex)이다.
@override List<Game> get games {
  if (_games is EqualUnmodifiableListView) return _games;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_games);
}

/// 쓴 순서(orderIndex)다.
 final  List<SessionDetailMemo> _memos;
/// 쓴 순서(orderIndex)다.
@override List<SessionDetailMemo> get memos {
  if (_memos is EqualUnmodifiableListView) return _memos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memos);
}


/// Create a copy of SessionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDetailCopyWith<_SessionDetail> get copyWith => __$SessionDetailCopyWithImpl<_SessionDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDetail&&const DeepCollectionEquality().equals(other.session, session)&&(identical(other.cueText, cueText) || other.cueText == cueText)&&const DeepCollectionEquality().equals(other.games, _games)&&const DeepCollectionEquality().equals(other.memos, _memos));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(session),cueText,const DeepCollectionEquality().hash(_games),const DeepCollectionEquality().hash(_memos));
}

@override
String toString() {
    return 'SessionDetail(session: $session, cueText: $cueText, games: $games, memos: $memos)';
}


}

/// @nodoc
abstract mixin class _$SessionDetailCopyWith<$Res> implements $SessionDetailCopyWith<$Res> {
  factory _$SessionDetailCopyWith(_SessionDetail value, $Res Function(_SessionDetail) _then) = __$SessionDetailCopyWithImpl;
@override @useResult
$Res call({
 Session session, String? cueText, List<Game> games, List<SessionDetailMemo> memos
});




}
/// @nodoc
class __$SessionDetailCopyWithImpl<$Res>
    implements _$SessionDetailCopyWith<$Res> {
  __$SessionDetailCopyWithImpl(this._self, this._then);

  final _SessionDetail _self;
  final $Res Function(_SessionDetail) _then;

/// Create a copy of SessionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = freezed,Object? cueText = freezed,Object? games = null,Object? memos = null,}) {
  return _then(_SessionDetail(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,cueText: freezed == cueText ? _self.cueText : cueText // ignore: cast_nullable_to_non_nullable
as String?,games: null == games ? _self._games : games // ignore: cast_nullable_to_non_nullable
as List<Game>,memos: null == memos ? _self._memos : memos // ignore: cast_nullable_to_non_nullable
as List<SessionDetailMemo>,
  ));
}


}

/// @nodoc
mixin _$SessionDetailMemo {

 int get id; String get content;/// 확정된 평가만 담는다. 확정이 아니면 null이다.
 MemoEvaluation? get evaluation;/// 확정된 태그의 이름, 이름 순.
 List<String> get tagNames;
/// Create a copy of SessionDetailMemo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDetailMemoCopyWith<SessionDetailMemo> get copyWith => _$SessionDetailMemoCopyWithImpl<SessionDetailMemo>(this as SessionDetailMemo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionDetailMemo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDetailMemo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.evaluation, _this.evaluation) || other.evaluation == _this.evaluation)&&const DeepCollectionEquality().equals(other.tagNames, _this.tagNames));
}


@override
int get hashCode {
  final _this = this as SessionDetailMemo;
  return Object.hash(runtimeType,_this.id,_this.content,_this.evaluation,const DeepCollectionEquality().hash(_this.tagNames));
}

@override
String toString() {
  final _this = this as SessionDetailMemo;
  return 'SessionDetailMemo(id: ${_this.id}, content: ${_this.content}, evaluation: ${_this.evaluation}, tagNames: ${_this.tagNames})';
}


}

/// @nodoc
abstract mixin class $SessionDetailMemoCopyWith<$Res>  {
  factory $SessionDetailMemoCopyWith(SessionDetailMemo value, $Res Function(SessionDetailMemo) _then) = _$SessionDetailMemoCopyWithImpl;
@useResult
$Res call({
 int id, String content, MemoEvaluation? evaluation, List<String> tagNames
});




}
/// @nodoc
class _$SessionDetailMemoCopyWithImpl<$Res>
    implements $SessionDetailMemoCopyWith<$Res> {
  _$SessionDetailMemoCopyWithImpl(this._self, this._then);

  final SessionDetailMemo _self;
  final $Res Function(SessionDetailMemo) _then;

/// Create a copy of SessionDetailMemo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? evaluation = freezed,Object? tagNames = null,}) {
  return _then(SessionDetailMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,evaluation: freezed == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as MemoEvaluation?,tagNames: null == tagNames ? _self.tagNames : tagNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionDetailMemo].
extension SessionDetailMemoPatterns on SessionDetailMemo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionDetailMemo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionDetailMemo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionDetailMemo value)  $default,){
final _that = this;
switch (_that) {
case _SessionDetailMemo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionDetailMemo value)?  $default,){
final _that = this;
switch (_that) {
case _SessionDetailMemo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String content,  MemoEvaluation? evaluation,  List<String> tagNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionDetailMemo() when $default != null:
return $default(_that.id,_that.content,_that.evaluation,_that.tagNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String content,  MemoEvaluation? evaluation,  List<String> tagNames)  $default,) {final _that = this;
switch (_that) {
case _SessionDetailMemo():
return $default(_that.id,_that.content,_that.evaluation,_that.tagNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String content,  MemoEvaluation? evaluation,  List<String> tagNames)?  $default,) {final _that = this;
switch (_that) {
case _SessionDetailMemo() when $default != null:
return $default(_that.id,_that.content,_that.evaluation,_that.tagNames);case _:
  return null;

}
}

}

/// @nodoc


class _SessionDetailMemo implements SessionDetailMemo {
  const _SessionDetailMemo({required this.id, required this.content, this.evaluation, required  List<String> tagNames}): _tagNames = tagNames;
  

@override final  int id;
@override final  String content;
/// 확정된 평가만 담는다. 확정이 아니면 null이다.
@override final  MemoEvaluation? evaluation;
/// 확정된 태그의 이름, 이름 순.
 final  List<String> _tagNames;
/// 확정된 태그의 이름, 이름 순.
@override List<String> get tagNames {
  if (_tagNames is EqualUnmodifiableListView) return _tagNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagNames);
}


/// Create a copy of SessionDetailMemo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDetailMemoCopyWith<_SessionDetailMemo> get copyWith => __$SessionDetailMemoCopyWithImpl<_SessionDetailMemo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDetailMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.evaluation, evaluation) || other.evaluation == evaluation)&&const DeepCollectionEquality().equals(other.tagNames, _tagNames));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,content,evaluation,const DeepCollectionEquality().hash(_tagNames));
}

@override
String toString() {
    return 'SessionDetailMemo(id: $id, content: $content, evaluation: $evaluation, tagNames: $tagNames)';
}


}

/// @nodoc
abstract mixin class _$SessionDetailMemoCopyWith<$Res> implements $SessionDetailMemoCopyWith<$Res> {
  factory _$SessionDetailMemoCopyWith(_SessionDetailMemo value, $Res Function(_SessionDetailMemo) _then) = __$SessionDetailMemoCopyWithImpl;
@override @useResult
$Res call({
 int id, String content, MemoEvaluation? evaluation, List<String> tagNames
});




}
/// @nodoc
class __$SessionDetailMemoCopyWithImpl<$Res>
    implements _$SessionDetailMemoCopyWith<$Res> {
  __$SessionDetailMemoCopyWithImpl(this._self, this._then);

  final _SessionDetailMemo _self;
  final $Res Function(_SessionDetailMemo) _then;

/// Create a copy of SessionDetailMemo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? evaluation = freezed,Object? tagNames = null,}) {
  return _then(_SessionDetailMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,evaluation: freezed == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as MemoEvaluation?,tagNames: null == tagNames ? _self._tagNames : tagNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
