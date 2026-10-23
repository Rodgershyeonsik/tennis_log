// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_dictionary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TagDictionary {

 List<TagDictionaryEntry> get entries;
/// Create a copy of TagDictionary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagDictionaryCopyWith<TagDictionary> get copyWith => _$TagDictionaryCopyWithImpl<TagDictionary>(this as TagDictionary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagDictionary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagDictionary&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}


@override
int get hashCode {
  final _this = this as TagDictionary;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as TagDictionary;
  return 'TagDictionary(entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $TagDictionaryCopyWith<$Res>  {
  factory $TagDictionaryCopyWith(TagDictionary value, $Res Function(TagDictionary) _then) = _$TagDictionaryCopyWithImpl;
@useResult
$Res call({
 List<TagDictionaryEntry> entries
});




}
/// @nodoc
class _$TagDictionaryCopyWithImpl<$Res>
    implements $TagDictionaryCopyWith<$Res> {
  _$TagDictionaryCopyWithImpl(this._self, this._then);

  final TagDictionary _self;
  final $Res Function(TagDictionary) _then;

/// Create a copy of TagDictionary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,}) {
  return _then(TagDictionary(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<TagDictionaryEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [TagDictionary].
extension TagDictionaryPatterns on TagDictionary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagDictionary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagDictionary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagDictionary value)  $default,){
final _that = this;
switch (_that) {
case _TagDictionary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagDictionary value)?  $default,){
final _that = this;
switch (_that) {
case _TagDictionary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TagDictionaryEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagDictionary() when $default != null:
return $default(_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TagDictionaryEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _TagDictionary():
return $default(_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TagDictionaryEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _TagDictionary() when $default != null:
return $default(_that.entries);case _:
  return null;

}
}

}

/// @nodoc


class _TagDictionary implements TagDictionary {
  const _TagDictionary({required  List<TagDictionaryEntry> entries}): _entries = entries;
  

 final  List<TagDictionaryEntry> _entries;
@override List<TagDictionaryEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of TagDictionary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagDictionaryCopyWith<_TagDictionary> get copyWith => __$TagDictionaryCopyWithImpl<_TagDictionary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagDictionary&&const DeepCollectionEquality().equals(other.entries, _entries));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'TagDictionary(entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$TagDictionaryCopyWith<$Res> implements $TagDictionaryCopyWith<$Res> {
  factory _$TagDictionaryCopyWith(_TagDictionary value, $Res Function(_TagDictionary) _then) = __$TagDictionaryCopyWithImpl;
@override @useResult
$Res call({
 List<TagDictionaryEntry> entries
});




}
/// @nodoc
class __$TagDictionaryCopyWithImpl<$Res>
    implements _$TagDictionaryCopyWith<$Res> {
  __$TagDictionaryCopyWithImpl(this._self, this._then);

  final _TagDictionary _self;
  final $Res Function(_TagDictionary) _then;

/// Create a copy of TagDictionary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,}) {
  return _then(_TagDictionary(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<TagDictionaryEntry>,
  ));
}


}

/// @nodoc
mixin _$TagDictionaryEntry {

 int get tagId; String get name; TagCategory get category;/// 부모 태그 id. 자식이 매칭되면 부모는 붙이지 않는다(조회 시 포함).
 int? get parentTagId;/// 이 태그를 알아보는 표현들.
 List<TagAlias> get aliases;/// 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다.
 List<String> get exclusions;
/// Create a copy of TagDictionaryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagDictionaryEntryCopyWith<TagDictionaryEntry> get copyWith => _$TagDictionaryEntryCopyWithImpl<TagDictionaryEntry>(this as TagDictionaryEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagDictionaryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagDictionaryEntry&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.parentTagId, _this.parentTagId) || other.parentTagId == _this.parentTagId)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&const DeepCollectionEquality().equals(other.exclusions, _this.exclusions));
}


@override
int get hashCode {
  final _this = this as TagDictionaryEntry;
  return Object.hash(runtimeType,_this.tagId,_this.name,_this.category,_this.parentTagId,const DeepCollectionEquality().hash(_this.aliases),const DeepCollectionEquality().hash(_this.exclusions));
}

@override
String toString() {
  final _this = this as TagDictionaryEntry;
  return 'TagDictionaryEntry(tagId: ${_this.tagId}, name: ${_this.name}, category: ${_this.category}, parentTagId: ${_this.parentTagId}, aliases: ${_this.aliases}, exclusions: ${_this.exclusions})';
}


}

/// @nodoc
abstract mixin class $TagDictionaryEntryCopyWith<$Res>  {
  factory $TagDictionaryEntryCopyWith(TagDictionaryEntry value, $Res Function(TagDictionaryEntry) _then) = _$TagDictionaryEntryCopyWithImpl;
@useResult
$Res call({
 int tagId, String name, TagCategory category, int? parentTagId, List<TagAlias> aliases, List<String> exclusions
});




}
/// @nodoc
class _$TagDictionaryEntryCopyWithImpl<$Res>
    implements $TagDictionaryEntryCopyWith<$Res> {
  _$TagDictionaryEntryCopyWithImpl(this._self, this._then);

  final TagDictionaryEntry _self;
  final $Res Function(TagDictionaryEntry) _then;

/// Create a copy of TagDictionaryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagId = null,Object? name = null,Object? category = null,Object? parentTagId = freezed,Object? aliases = null,Object? exclusions = null,}) {
  return _then(TagDictionaryEntry(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,parentTagId: freezed == parentTagId ? _self.parentTagId : parentTagId // ignore: cast_nullable_to_non_nullable
as int?,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<TagAlias>,exclusions: null == exclusions ? _self.exclusions : exclusions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TagDictionaryEntry].
extension TagDictionaryEntryPatterns on TagDictionaryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagDictionaryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagDictionaryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagDictionaryEntry value)  $default,){
final _that = this;
switch (_that) {
case _TagDictionaryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagDictionaryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TagDictionaryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tagId,  String name,  TagCategory category,  int? parentTagId,  List<TagAlias> aliases,  List<String> exclusions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagDictionaryEntry() when $default != null:
return $default(_that.tagId,_that.name,_that.category,_that.parentTagId,_that.aliases,_that.exclusions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tagId,  String name,  TagCategory category,  int? parentTagId,  List<TagAlias> aliases,  List<String> exclusions)  $default,) {final _that = this;
switch (_that) {
case _TagDictionaryEntry():
return $default(_that.tagId,_that.name,_that.category,_that.parentTagId,_that.aliases,_that.exclusions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tagId,  String name,  TagCategory category,  int? parentTagId,  List<TagAlias> aliases,  List<String> exclusions)?  $default,) {final _that = this;
switch (_that) {
case _TagDictionaryEntry() when $default != null:
return $default(_that.tagId,_that.name,_that.category,_that.parentTagId,_that.aliases,_that.exclusions);case _:
  return null;

}
}

}

/// @nodoc


class _TagDictionaryEntry implements TagDictionaryEntry {
  const _TagDictionaryEntry({required this.tagId, required this.name, required this.category, this.parentTagId, required  List<TagAlias> aliases, required  List<String> exclusions}): _aliases = aliases,_exclusions = exclusions;
  

@override final  int tagId;
@override final  String name;
@override final  TagCategory category;
/// 부모 태그 id. 자식이 매칭되면 부모는 붙이지 않는다(조회 시 포함).
@override final  int? parentTagId;
/// 이 태그를 알아보는 표현들.
 final  List<TagAlias> _aliases;
/// 이 태그를 알아보는 표현들.
@override List<TagAlias> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

/// 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다.
 final  List<String> _exclusions;
/// 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다.
@override List<String> get exclusions {
  if (_exclusions is EqualUnmodifiableListView) return _exclusions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exclusions);
}


/// Create a copy of TagDictionaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagDictionaryEntryCopyWith<_TagDictionaryEntry> get copyWith => __$TagDictionaryEntryCopyWithImpl<_TagDictionaryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagDictionaryEntry&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.parentTagId, parentTagId) || other.parentTagId == parentTagId)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&const DeepCollectionEquality().equals(other.exclusions, _exclusions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagId,name,category,parentTagId,const DeepCollectionEquality().hash(_aliases),const DeepCollectionEquality().hash(_exclusions));
}

@override
String toString() {
    return 'TagDictionaryEntry(tagId: $tagId, name: $name, category: $category, parentTagId: $parentTagId, aliases: $aliases, exclusions: $exclusions)';
}


}

/// @nodoc
abstract mixin class _$TagDictionaryEntryCopyWith<$Res> implements $TagDictionaryEntryCopyWith<$Res> {
  factory _$TagDictionaryEntryCopyWith(_TagDictionaryEntry value, $Res Function(_TagDictionaryEntry) _then) = __$TagDictionaryEntryCopyWithImpl;
@override @useResult
$Res call({
 int tagId, String name, TagCategory category, int? parentTagId, List<TagAlias> aliases, List<String> exclusions
});




}
/// @nodoc
class __$TagDictionaryEntryCopyWithImpl<$Res>
    implements _$TagDictionaryEntryCopyWith<$Res> {
  __$TagDictionaryEntryCopyWithImpl(this._self, this._then);

  final _TagDictionaryEntry _self;
  final $Res Function(_TagDictionaryEntry) _then;

/// Create a copy of TagDictionaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagId = null,Object? name = null,Object? category = null,Object? parentTagId = freezed,Object? aliases = null,Object? exclusions = null,}) {
  return _then(_TagDictionaryEntry(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,parentTagId: freezed == parentTagId ? _self.parentTagId : parentTagId // ignore: cast_nullable_to_non_nullable
as int?,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<TagAlias>,exclusions: null == exclusions ? _self._exclusions : exclusions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$TagAlias {

 String get alias; AliasConfidence get confidence;
/// Create a copy of TagAlias
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagAliasCopyWith<TagAlias> get copyWith => _$TagAliasCopyWithImpl<TagAlias>(this as TagAlias, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagAlias;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagAlias&&(identical(other.alias, _this.alias) || other.alias == _this.alias)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence));
}


@override
int get hashCode {
  final _this = this as TagAlias;
  return Object.hash(runtimeType,_this.alias,_this.confidence);
}

@override
String toString() {
  final _this = this as TagAlias;
  return 'TagAlias(alias: ${_this.alias}, confidence: ${_this.confidence})';
}


}

/// @nodoc
abstract mixin class $TagAliasCopyWith<$Res>  {
  factory $TagAliasCopyWith(TagAlias value, $Res Function(TagAlias) _then) = _$TagAliasCopyWithImpl;
@useResult
$Res call({
 String alias, AliasConfidence confidence
});




}
/// @nodoc
class _$TagAliasCopyWithImpl<$Res>
    implements $TagAliasCopyWith<$Res> {
  _$TagAliasCopyWithImpl(this._self, this._then);

  final TagAlias _self;
  final $Res Function(TagAlias) _then;

/// Create a copy of TagAlias
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alias = null,Object? confidence = null,}) {
  return _then(TagAlias(
alias: null == alias ? _self.alias : alias // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as AliasConfidence,
  ));
}

}


/// Adds pattern-matching-related methods to [TagAlias].
extension TagAliasPatterns on TagAlias {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagAlias value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagAlias() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagAlias value)  $default,){
final _that = this;
switch (_that) {
case _TagAlias():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagAlias value)?  $default,){
final _that = this;
switch (_that) {
case _TagAlias() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String alias,  AliasConfidence confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagAlias() when $default != null:
return $default(_that.alias,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String alias,  AliasConfidence confidence)  $default,) {final _that = this;
switch (_that) {
case _TagAlias():
return $default(_that.alias,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String alias,  AliasConfidence confidence)?  $default,) {final _that = this;
switch (_that) {
case _TagAlias() when $default != null:
return $default(_that.alias,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _TagAlias implements TagAlias {
  const _TagAlias({required this.alias, required this.confidence});
  

@override final  String alias;
@override final  AliasConfidence confidence;

/// Create a copy of TagAlias
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagAliasCopyWith<_TagAlias> get copyWith => __$TagAliasCopyWithImpl<_TagAlias>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagAlias&&(identical(other.alias, alias) || other.alias == alias)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,alias,confidence);
}

@override
String toString() {
    return 'TagAlias(alias: $alias, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TagAliasCopyWith<$Res> implements $TagAliasCopyWith<$Res> {
  factory _$TagAliasCopyWith(_TagAlias value, $Res Function(_TagAlias) _then) = __$TagAliasCopyWithImpl;
@override @useResult
$Res call({
 String alias, AliasConfidence confidence
});




}
/// @nodoc
class __$TagAliasCopyWithImpl<$Res>
    implements _$TagAliasCopyWith<$Res> {
  __$TagAliasCopyWithImpl(this._self, this._then);

  final _TagAlias _self;
  final $Res Function(_TagAlias) _then;

/// Create a copy of TagAlias
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alias = null,Object? confidence = null,}) {
  return _then(_TagAlias(
alias: null == alias ? _self.alias : alias // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as AliasConfidence,
  ));
}


}

// dart format on
