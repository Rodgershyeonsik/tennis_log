// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo_with_tags.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoWithTags {

 Memo get memo;/// 화면에 보여줄 태그들. **rejected는 담지 않는다** (명세: 화면에 표시하지 않음).
 List<MemoTagView> get tags;
/// Create a copy of MemoWithTags
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoWithTagsCopyWith<MemoWithTags> get copyWith => _$MemoWithTagsCopyWithImpl<MemoWithTags>(this as MemoWithTags, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemoWithTags;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoWithTags&&const DeepCollectionEquality().equals(other.memo, _this.memo)&&const DeepCollectionEquality().equals(other.tags, _this.tags));
}


@override
int get hashCode {
  final _this = this as MemoWithTags;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.memo),const DeepCollectionEquality().hash(_this.tags));
}

@override
String toString() {
  final _this = this as MemoWithTags;
  return 'MemoWithTags(memo: ${_this.memo}, tags: ${_this.tags})';
}


}

/// @nodoc
abstract mixin class $MemoWithTagsCopyWith<$Res>  {
  factory $MemoWithTagsCopyWith(MemoWithTags value, $Res Function(MemoWithTags) _then) = _$MemoWithTagsCopyWithImpl;
@useResult
$Res call({
 Memo memo, List<MemoTagView> tags
});




}
/// @nodoc
class _$MemoWithTagsCopyWithImpl<$Res>
    implements $MemoWithTagsCopyWith<$Res> {
  _$MemoWithTagsCopyWithImpl(this._self, this._then);

  final MemoWithTags _self;
  final $Res Function(MemoWithTags) _then;

/// Create a copy of MemoWithTags
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memo = freezed,Object? tags = null,}) {
  return _then(MemoWithTags(
memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as Memo,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<MemoTagView>,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoWithTags].
extension MemoWithTagsPatterns on MemoWithTags {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoWithTags value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoWithTags() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoWithTags value)  $default,){
final _that = this;
switch (_that) {
case _MemoWithTags():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoWithTags value)?  $default,){
final _that = this;
switch (_that) {
case _MemoWithTags() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Memo memo,  List<MemoTagView> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoWithTags() when $default != null:
return $default(_that.memo,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Memo memo,  List<MemoTagView> tags)  $default,) {final _that = this;
switch (_that) {
case _MemoWithTags():
return $default(_that.memo,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Memo memo,  List<MemoTagView> tags)?  $default,) {final _that = this;
switch (_that) {
case _MemoWithTags() when $default != null:
return $default(_that.memo,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _MemoWithTags implements MemoWithTags {
  const _MemoWithTags({required this.memo, required  List<MemoTagView> tags}): _tags = tags;
  

@override final  Memo memo;
/// 화면에 보여줄 태그들. **rejected는 담지 않는다** (명세: 화면에 표시하지 않음).
 final  List<MemoTagView> _tags;
/// 화면에 보여줄 태그들. **rejected는 담지 않는다** (명세: 화면에 표시하지 않음).
@override List<MemoTagView> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of MemoWithTags
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoWithTagsCopyWith<_MemoWithTags> get copyWith => __$MemoWithTagsCopyWithImpl<_MemoWithTags>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoWithTags&&const DeepCollectionEquality().equals(other.memo, memo)&&const DeepCollectionEquality().equals(other.tags, _tags));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(memo),const DeepCollectionEquality().hash(_tags));
}

@override
String toString() {
    return 'MemoWithTags(memo: $memo, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$MemoWithTagsCopyWith<$Res> implements $MemoWithTagsCopyWith<$Res> {
  factory _$MemoWithTagsCopyWith(_MemoWithTags value, $Res Function(_MemoWithTags) _then) = __$MemoWithTagsCopyWithImpl;
@override @useResult
$Res call({
 Memo memo, List<MemoTagView> tags
});




}
/// @nodoc
class __$MemoWithTagsCopyWithImpl<$Res>
    implements _$MemoWithTagsCopyWith<$Res> {
  __$MemoWithTagsCopyWithImpl(this._self, this._then);

  final _MemoWithTags _self;
  final $Res Function(_MemoWithTags) _then;

/// Create a copy of MemoWithTags
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memo = freezed,Object? tags = null,}) {
  return _then(_MemoWithTags(
memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as Memo,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<MemoTagView>,
  ));
}


}

/// @nodoc
mixin _$MemoTagView {

 int get tagId; String get name; TagCategory get category; MemoTagSource get source;/// confirmed는 실선 채움, suggested는 점선 테두리로 그린다.
 MemoTagStatus get status;
/// Create a copy of MemoTagView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoTagViewCopyWith<MemoTagView> get copyWith => _$MemoTagViewCopyWithImpl<MemoTagView>(this as MemoTagView, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MemoTagView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoTagView&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as MemoTagView;
  return Object.hash(runtimeType,_this.tagId,_this.name,_this.category,_this.source,_this.status);
}

@override
String toString() {
  final _this = this as MemoTagView;
  return 'MemoTagView(tagId: ${_this.tagId}, name: ${_this.name}, category: ${_this.category}, source: ${_this.source}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MemoTagViewCopyWith<$Res>  {
  factory $MemoTagViewCopyWith(MemoTagView value, $Res Function(MemoTagView) _then) = _$MemoTagViewCopyWithImpl;
@useResult
$Res call({
 int tagId, String name, TagCategory category, MemoTagSource source, MemoTagStatus status
});




}
/// @nodoc
class _$MemoTagViewCopyWithImpl<$Res>
    implements $MemoTagViewCopyWith<$Res> {
  _$MemoTagViewCopyWithImpl(this._self, this._then);

  final MemoTagView _self;
  final $Res Function(MemoTagView) _then;

/// Create a copy of MemoTagView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagId = null,Object? name = null,Object? category = null,Object? source = null,Object? status = null,}) {
  return _then(MemoTagView(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MemoTagSource,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoTagStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoTagView].
extension MemoTagViewPatterns on MemoTagView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoTagView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoTagView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoTagView value)  $default,){
final _that = this;
switch (_that) {
case _MemoTagView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoTagView value)?  $default,){
final _that = this;
switch (_that) {
case _MemoTagView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tagId,  String name,  TagCategory category,  MemoTagSource source,  MemoTagStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoTagView() when $default != null:
return $default(_that.tagId,_that.name,_that.category,_that.source,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tagId,  String name,  TagCategory category,  MemoTagSource source,  MemoTagStatus status)  $default,) {final _that = this;
switch (_that) {
case _MemoTagView():
return $default(_that.tagId,_that.name,_that.category,_that.source,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tagId,  String name,  TagCategory category,  MemoTagSource source,  MemoTagStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MemoTagView() when $default != null:
return $default(_that.tagId,_that.name,_that.category,_that.source,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _MemoTagView implements MemoTagView {
  const _MemoTagView({required this.tagId, required this.name, required this.category, required this.source, required this.status});
  

@override final  int tagId;
@override final  String name;
@override final  TagCategory category;
@override final  MemoTagSource source;
/// confirmed는 실선 채움, suggested는 점선 테두리로 그린다.
@override final  MemoTagStatus status;

/// Create a copy of MemoTagView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoTagViewCopyWith<_MemoTagView> get copyWith => __$MemoTagViewCopyWithImpl<_MemoTagView>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoTagView&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagId,name,category,source,status);
}

@override
String toString() {
    return 'MemoTagView(tagId: $tagId, name: $name, category: $category, source: $source, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MemoTagViewCopyWith<$Res> implements $MemoTagViewCopyWith<$Res> {
  factory _$MemoTagViewCopyWith(_MemoTagView value, $Res Function(_MemoTagView) _then) = __$MemoTagViewCopyWithImpl;
@override @useResult
$Res call({
 int tagId, String name, TagCategory category, MemoTagSource source, MemoTagStatus status
});




}
/// @nodoc
class __$MemoTagViewCopyWithImpl<$Res>
    implements _$MemoTagViewCopyWith<$Res> {
  __$MemoTagViewCopyWithImpl(this._self, this._then);

  final _MemoTagView _self;
  final $Res Function(_MemoTagView) _then;

/// Create a copy of MemoTagView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagId = null,Object? name = null,Object? category = null,Object? source = null,Object? status = null,}) {
  return _then(_MemoTagView(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MemoTagSource,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoTagStatus,
  ));
}


}

// dart format on
