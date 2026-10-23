// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_tag_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoAnalysis {

/// tagId 오름차순. 같은 태그가 두 번 들어오지는 않는다.
 List<SuggestedTag> get tags;/// 추천 평가. 키워드가 없거나 good·bad가 동시에 매칭되면 null이다.
 MemoEvaluation? get evaluation;
/// Create a copy of MemoAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoAnalysisCopyWith<MemoAnalysis> get copyWith => _$MemoAnalysisCopyWithImpl<MemoAnalysis>(this as MemoAnalysis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemoAnalysis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoAnalysis&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.evaluation, _this.evaluation) || other.evaluation == _this.evaluation));
}


@override
int get hashCode {
  final _this = this as MemoAnalysis;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.tags),_this.evaluation);
}

@override
String toString() {
  final _this = this as MemoAnalysis;
  return 'MemoAnalysis(tags: ${_this.tags}, evaluation: ${_this.evaluation})';
}


}

/// @nodoc
abstract mixin class $MemoAnalysisCopyWith<$Res>  {
  factory $MemoAnalysisCopyWith(MemoAnalysis value, $Res Function(MemoAnalysis) _then) = _$MemoAnalysisCopyWithImpl;
@useResult
$Res call({
 List<SuggestedTag> tags, MemoEvaluation? evaluation
});




}
/// @nodoc
class _$MemoAnalysisCopyWithImpl<$Res>
    implements $MemoAnalysisCopyWith<$Res> {
  _$MemoAnalysisCopyWithImpl(this._self, this._then);

  final MemoAnalysis _self;
  final $Res Function(MemoAnalysis) _then;

/// Create a copy of MemoAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tags = null,Object? evaluation = freezed,}) {
  return _then(MemoAnalysis(
tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<SuggestedTag>,evaluation: freezed == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as MemoEvaluation?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoAnalysis].
extension MemoAnalysisPatterns on MemoAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _MemoAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _MemoAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SuggestedTag> tags,  MemoEvaluation? evaluation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoAnalysis() when $default != null:
return $default(_that.tags,_that.evaluation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SuggestedTag> tags,  MemoEvaluation? evaluation)  $default,) {final _that = this;
switch (_that) {
case _MemoAnalysis():
return $default(_that.tags,_that.evaluation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SuggestedTag> tags,  MemoEvaluation? evaluation)?  $default,) {final _that = this;
switch (_that) {
case _MemoAnalysis() when $default != null:
return $default(_that.tags,_that.evaluation);case _:
  return null;

}
}

}

/// @nodoc


class _MemoAnalysis implements MemoAnalysis {
  const _MemoAnalysis({required  List<SuggestedTag> tags, this.evaluation}): _tags = tags;
  

/// tagId 오름차순. 같은 태그가 두 번 들어오지는 않는다.
 final  List<SuggestedTag> _tags;
/// tagId 오름차순. 같은 태그가 두 번 들어오지는 않는다.
@override List<SuggestedTag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// 추천 평가. 키워드가 없거나 good·bad가 동시에 매칭되면 null이다.
@override final  MemoEvaluation? evaluation;

/// Create a copy of MemoAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoAnalysisCopyWith<_MemoAnalysis> get copyWith => __$MemoAnalysisCopyWithImpl<_MemoAnalysis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoAnalysis&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.evaluation, evaluation) || other.evaluation == evaluation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_tags),evaluation);
}

@override
String toString() {
    return 'MemoAnalysis(tags: $tags, evaluation: $evaluation)';
}


}

/// @nodoc
abstract mixin class _$MemoAnalysisCopyWith<$Res> implements $MemoAnalysisCopyWith<$Res> {
  factory _$MemoAnalysisCopyWith(_MemoAnalysis value, $Res Function(_MemoAnalysis) _then) = __$MemoAnalysisCopyWithImpl;
@override @useResult
$Res call({
 List<SuggestedTag> tags, MemoEvaluation? evaluation
});




}
/// @nodoc
class __$MemoAnalysisCopyWithImpl<$Res>
    implements _$MemoAnalysisCopyWith<$Res> {
  __$MemoAnalysisCopyWithImpl(this._self, this._then);

  final _MemoAnalysis _self;
  final $Res Function(_MemoAnalysis) _then;

/// Create a copy of MemoAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tags = null,Object? evaluation = freezed,}) {
  return _then(_MemoAnalysis(
tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<SuggestedTag>,evaluation: freezed == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as MemoEvaluation?,
  ));
}


}

/// @nodoc
mixin _$SuggestedTag {

 int get tagId;/// 인식 표현의 confidence에서 나온다. sure면 confirmed, ambiguous면 suggested.
/// **엔진은 rejected를 내지 않는다**(사용자가 지운 기억은 DB에만 있다).
 MemoTagStatus get status;
/// Create a copy of SuggestedTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestedTagCopyWith<SuggestedTag> get copyWith => _$SuggestedTagCopyWithImpl<SuggestedTag>(this as SuggestedTag, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SuggestedTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuggestedTag&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as SuggestedTag;
  return Object.hash(runtimeType,_this.tagId,_this.status);
}

@override
String toString() {
  final _this = this as SuggestedTag;
  return 'SuggestedTag(tagId: ${_this.tagId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $SuggestedTagCopyWith<$Res>  {
  factory $SuggestedTagCopyWith(SuggestedTag value, $Res Function(SuggestedTag) _then) = _$SuggestedTagCopyWithImpl;
@useResult
$Res call({
 int tagId, MemoTagStatus status
});




}
/// @nodoc
class _$SuggestedTagCopyWithImpl<$Res>
    implements $SuggestedTagCopyWith<$Res> {
  _$SuggestedTagCopyWithImpl(this._self, this._then);

  final SuggestedTag _self;
  final $Res Function(SuggestedTag) _then;

/// Create a copy of SuggestedTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagId = null,Object? status = null,}) {
  return _then(SuggestedTag(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoTagStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [SuggestedTag].
extension SuggestedTagPatterns on SuggestedTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuggestedTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuggestedTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuggestedTag value)  $default,){
final _that = this;
switch (_that) {
case _SuggestedTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuggestedTag value)?  $default,){
final _that = this;
switch (_that) {
case _SuggestedTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tagId,  MemoTagStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuggestedTag() when $default != null:
return $default(_that.tagId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tagId,  MemoTagStatus status)  $default,) {final _that = this;
switch (_that) {
case _SuggestedTag():
return $default(_that.tagId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tagId,  MemoTagStatus status)?  $default,) {final _that = this;
switch (_that) {
case _SuggestedTag() when $default != null:
return $default(_that.tagId,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _SuggestedTag implements SuggestedTag {
  const _SuggestedTag({required this.tagId, required this.status});
  

@override final  int tagId;
/// 인식 표현의 confidence에서 나온다. sure면 confirmed, ambiguous면 suggested.
/// **엔진은 rejected를 내지 않는다**(사용자가 지운 기억은 DB에만 있다).
@override final  MemoTagStatus status;

/// Create a copy of SuggestedTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuggestedTagCopyWith<_SuggestedTag> get copyWith => __$SuggestedTagCopyWithImpl<_SuggestedTag>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuggestedTag&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagId,status);
}

@override
String toString() {
    return 'SuggestedTag(tagId: $tagId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SuggestedTagCopyWith<$Res> implements $SuggestedTagCopyWith<$Res> {
  factory _$SuggestedTagCopyWith(_SuggestedTag value, $Res Function(_SuggestedTag) _then) = __$SuggestedTagCopyWithImpl;
@override @useResult
$Res call({
 int tagId, MemoTagStatus status
});




}
/// @nodoc
class __$SuggestedTagCopyWithImpl<$Res>
    implements _$SuggestedTagCopyWith<$Res> {
  __$SuggestedTagCopyWithImpl(this._self, this._then);

  final _SuggestedTag _self;
  final $Res Function(_SuggestedTag) _then;

/// Create a copy of SuggestedTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagId = null,Object? status = null,}) {
  return _then(_SuggestedTag(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoTagStatus,
  ));
}


}

// dart format on
