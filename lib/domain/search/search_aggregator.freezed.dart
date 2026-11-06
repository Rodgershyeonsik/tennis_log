// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_aggregator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EvaluationCounts {

 int get good; int get bad; int get question; int get none;
/// Create a copy of EvaluationCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvaluationCountsCopyWith<EvaluationCounts> get copyWith => _$EvaluationCountsCopyWithImpl<EvaluationCounts>(this as EvaluationCounts, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EvaluationCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvaluationCounts&&(identical(other.good, _this.good) || other.good == _this.good)&&(identical(other.bad, _this.bad) || other.bad == _this.bad)&&(identical(other.question, _this.question) || other.question == _this.question)&&(identical(other.none, _this.none) || other.none == _this.none));
}


@override
int get hashCode {
  final _this = this as EvaluationCounts;
  return Object.hash(runtimeType,_this.good,_this.bad,_this.question,_this.none);
}

@override
String toString() {
  final _this = this as EvaluationCounts;
  return 'EvaluationCounts(good: ${_this.good}, bad: ${_this.bad}, question: ${_this.question}, none: ${_this.none})';
}


}

/// @nodoc
abstract mixin class $EvaluationCountsCopyWith<$Res>  {
  factory $EvaluationCountsCopyWith(EvaluationCounts value, $Res Function(EvaluationCounts) _then) = _$EvaluationCountsCopyWithImpl;
@useResult
$Res call({
 int good, int bad, int question, int none
});




}
/// @nodoc
class _$EvaluationCountsCopyWithImpl<$Res>
    implements $EvaluationCountsCopyWith<$Res> {
  _$EvaluationCountsCopyWithImpl(this._self, this._then);

  final EvaluationCounts _self;
  final $Res Function(EvaluationCounts) _then;

/// Create a copy of EvaluationCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? good = null,Object? bad = null,Object? question = null,Object? none = null,}) {
  return _then(EvaluationCounts(
good: null == good ? _self.good : good // ignore: cast_nullable_to_non_nullable
as int,bad: null == bad ? _self.bad : bad // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as int,none: null == none ? _self.none : none // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EvaluationCounts].
extension EvaluationCountsPatterns on EvaluationCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvaluationCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvaluationCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvaluationCounts value)  $default,){
final _that = this;
switch (_that) {
case _EvaluationCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvaluationCounts value)?  $default,){
final _that = this;
switch (_that) {
case _EvaluationCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int good,  int bad,  int question,  int none)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvaluationCounts() when $default != null:
return $default(_that.good,_that.bad,_that.question,_that.none);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int good,  int bad,  int question,  int none)  $default,) {final _that = this;
switch (_that) {
case _EvaluationCounts():
return $default(_that.good,_that.bad,_that.question,_that.none);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int good,  int bad,  int question,  int none)?  $default,) {final _that = this;
switch (_that) {
case _EvaluationCounts() when $default != null:
return $default(_that.good,_that.bad,_that.question,_that.none);case _:
  return null;

}
}

}

/// @nodoc


class _EvaluationCounts extends EvaluationCounts {
  const _EvaluationCounts({this.good = 0, this.bad = 0, this.question = 0, this.none = 0}): super._();
  

@override@JsonKey() final  int good;
@override@JsonKey() final  int bad;
@override@JsonKey() final  int question;
@override@JsonKey() final  int none;

/// Create a copy of EvaluationCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvaluationCountsCopyWith<_EvaluationCounts> get copyWith => __$EvaluationCountsCopyWithImpl<_EvaluationCounts>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvaluationCounts&&(identical(other.good, good) || other.good == good)&&(identical(other.bad, bad) || other.bad == bad)&&(identical(other.question, question) || other.question == question)&&(identical(other.none, none) || other.none == none));
}


@override
int get hashCode {
    return Object.hash(runtimeType,good,bad,question,none);
}

@override
String toString() {
    return 'EvaluationCounts(good: $good, bad: $bad, question: $question, none: $none)';
}


}

/// @nodoc
abstract mixin class _$EvaluationCountsCopyWith<$Res> implements $EvaluationCountsCopyWith<$Res> {
  factory _$EvaluationCountsCopyWith(_EvaluationCounts value, $Res Function(_EvaluationCounts) _then) = __$EvaluationCountsCopyWithImpl;
@override @useResult
$Res call({
 int good, int bad, int question, int none
});




}
/// @nodoc
class __$EvaluationCountsCopyWithImpl<$Res>
    implements _$EvaluationCountsCopyWith<$Res> {
  __$EvaluationCountsCopyWithImpl(this._self, this._then);

  final _EvaluationCounts _self;
  final $Res Function(_EvaluationCounts) _then;

/// Create a copy of EvaluationCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? good = null,Object? bad = null,Object? question = null,Object? none = null,}) {
  return _then(_EvaluationCounts(
good: null == good ? _self.good : good // ignore: cast_nullable_to_non_nullable
as int,bad: null == bad ? _self.bad : bad // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as int,none: null == none ? _self.none : none // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TagSummaryItem {

 int get tagId; String get name; int get count; EvaluationCounts get evaluations;
/// Create a copy of TagSummaryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagSummaryItemCopyWith<TagSummaryItem> get copyWith => _$TagSummaryItemCopyWithImpl<TagSummaryItem>(this as TagSummaryItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagSummaryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagSummaryItem&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.evaluations, _this.evaluations) || other.evaluations == _this.evaluations));
}


@override
int get hashCode {
  final _this = this as TagSummaryItem;
  return Object.hash(runtimeType,_this.tagId,_this.name,_this.count,_this.evaluations);
}

@override
String toString() {
  final _this = this as TagSummaryItem;
  return 'TagSummaryItem(tagId: ${_this.tagId}, name: ${_this.name}, count: ${_this.count}, evaluations: ${_this.evaluations})';
}


}

/// @nodoc
abstract mixin class $TagSummaryItemCopyWith<$Res>  {
  factory $TagSummaryItemCopyWith(TagSummaryItem value, $Res Function(TagSummaryItem) _then) = _$TagSummaryItemCopyWithImpl;
@useResult
$Res call({
 int tagId, String name, int count, EvaluationCounts evaluations
});


$EvaluationCountsCopyWith<$Res> get evaluations;

}
/// @nodoc
class _$TagSummaryItemCopyWithImpl<$Res>
    implements $TagSummaryItemCopyWith<$Res> {
  _$TagSummaryItemCopyWithImpl(this._self, this._then);

  final TagSummaryItem _self;
  final $Res Function(TagSummaryItem) _then;

/// Create a copy of TagSummaryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagId = null,Object? name = null,Object? count = null,Object? evaluations = null,}) {
  return _then(TagSummaryItem(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,evaluations: null == evaluations ? _self.evaluations : evaluations // ignore: cast_nullable_to_non_nullable
as EvaluationCounts,
  ));
}
/// Create a copy of TagSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EvaluationCountsCopyWith<$Res> get evaluations {
  
  return $EvaluationCountsCopyWith<$Res>(_self.evaluations, (value) {
    return _then(_self.copyWith(evaluations: value));
  });
}
}


/// Adds pattern-matching-related methods to [TagSummaryItem].
extension TagSummaryItemPatterns on TagSummaryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagSummaryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagSummaryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagSummaryItem value)  $default,){
final _that = this;
switch (_that) {
case _TagSummaryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagSummaryItem value)?  $default,){
final _that = this;
switch (_that) {
case _TagSummaryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tagId,  String name,  int count,  EvaluationCounts evaluations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagSummaryItem() when $default != null:
return $default(_that.tagId,_that.name,_that.count,_that.evaluations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tagId,  String name,  int count,  EvaluationCounts evaluations)  $default,) {final _that = this;
switch (_that) {
case _TagSummaryItem():
return $default(_that.tagId,_that.name,_that.count,_that.evaluations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tagId,  String name,  int count,  EvaluationCounts evaluations)?  $default,) {final _that = this;
switch (_that) {
case _TagSummaryItem() when $default != null:
return $default(_that.tagId,_that.name,_that.count,_that.evaluations);case _:
  return null;

}
}

}

/// @nodoc


class _TagSummaryItem implements TagSummaryItem {
  const _TagSummaryItem({required this.tagId, required this.name, required this.count, required this.evaluations});
  

@override final  int tagId;
@override final  String name;
@override final  int count;
@override final  EvaluationCounts evaluations;

/// Create a copy of TagSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagSummaryItemCopyWith<_TagSummaryItem> get copyWith => __$TagSummaryItemCopyWithImpl<_TagSummaryItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagSummaryItem&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&(identical(other.evaluations, evaluations) || other.evaluations == evaluations));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagId,name,count,evaluations);
}

@override
String toString() {
    return 'TagSummaryItem(tagId: $tagId, name: $name, count: $count, evaluations: $evaluations)';
}


}

/// @nodoc
abstract mixin class _$TagSummaryItemCopyWith<$Res> implements $TagSummaryItemCopyWith<$Res> {
  factory _$TagSummaryItemCopyWith(_TagSummaryItem value, $Res Function(_TagSummaryItem) _then) = __$TagSummaryItemCopyWithImpl;
@override @useResult
$Res call({
 int tagId, String name, int count, EvaluationCounts evaluations
});


@override $EvaluationCountsCopyWith<$Res> get evaluations;

}
/// @nodoc
class __$TagSummaryItemCopyWithImpl<$Res>
    implements _$TagSummaryItemCopyWith<$Res> {
  __$TagSummaryItemCopyWithImpl(this._self, this._then);

  final _TagSummaryItem _self;
  final $Res Function(_TagSummaryItem) _then;

/// Create a copy of TagSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagId = null,Object? name = null,Object? count = null,Object? evaluations = null,}) {
  return _then(_TagSummaryItem(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,evaluations: null == evaluations ? _self.evaluations : evaluations // ignore: cast_nullable_to_non_nullable
as EvaluationCounts,
  ));
}

/// Create a copy of TagSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EvaluationCountsCopyWith<$Res> get evaluations {
  
  return $EvaluationCountsCopyWith<$Res>(_self.evaluations, (value) {
    return _then(_self.copyWith(evaluations: value));
  });
}
}

/// @nodoc
mixin _$TagStatRow {

 int get tagId; String get name; TagCategory get category;/// 자기 자신 또는 자손이 붙은 메모 수. 같은 메모는 한 번만 센다.
 int get count;/// 이 태그 자체가 붙은 메모 수.
 int get directCount; EvaluationCounts get evaluations;/// 결과에 등장한 자식들.
 List<TagStatRow> get children;
/// Create a copy of TagStatRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagStatRowCopyWith<TagStatRow> get copyWith => _$TagStatRowCopyWithImpl<TagStatRow>(this as TagStatRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TagStatRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagStatRow&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.directCount, _this.directCount) || other.directCount == _this.directCount)&&(identical(other.evaluations, _this.evaluations) || other.evaluations == _this.evaluations)&&const DeepCollectionEquality().equals(other.children, _this.children));
}


@override
int get hashCode {
  final _this = this as TagStatRow;
  return Object.hash(runtimeType,_this.tagId,_this.name,_this.category,_this.count,_this.directCount,_this.evaluations,const DeepCollectionEquality().hash(_this.children));
}

@override
String toString() {
  final _this = this as TagStatRow;
  return 'TagStatRow(tagId: ${_this.tagId}, name: ${_this.name}, category: ${_this.category}, count: ${_this.count}, directCount: ${_this.directCount}, evaluations: ${_this.evaluations}, children: ${_this.children})';
}


}

/// @nodoc
abstract mixin class $TagStatRowCopyWith<$Res>  {
  factory $TagStatRowCopyWith(TagStatRow value, $Res Function(TagStatRow) _then) = _$TagStatRowCopyWithImpl;
@useResult
$Res call({
 int tagId, String name, TagCategory category, int count, int directCount, EvaluationCounts evaluations, List<TagStatRow> children
});


$EvaluationCountsCopyWith<$Res> get evaluations;

}
/// @nodoc
class _$TagStatRowCopyWithImpl<$Res>
    implements $TagStatRowCopyWith<$Res> {
  _$TagStatRowCopyWithImpl(this._self, this._then);

  final TagStatRow _self;
  final $Res Function(TagStatRow) _then;

/// Create a copy of TagStatRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagId = null,Object? name = null,Object? category = null,Object? count = null,Object? directCount = null,Object? evaluations = null,Object? children = null,}) {
  return _then(TagStatRow(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,directCount: null == directCount ? _self.directCount : directCount // ignore: cast_nullable_to_non_nullable
as int,evaluations: null == evaluations ? _self.evaluations : evaluations // ignore: cast_nullable_to_non_nullable
as EvaluationCounts,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<TagStatRow>,
  ));
}
/// Create a copy of TagStatRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EvaluationCountsCopyWith<$Res> get evaluations {
  
  return $EvaluationCountsCopyWith<$Res>(_self.evaluations, (value) {
    return _then(_self.copyWith(evaluations: value));
  });
}
}


/// Adds pattern-matching-related methods to [TagStatRow].
extension TagStatRowPatterns on TagStatRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagStatRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagStatRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagStatRow value)  $default,){
final _that = this;
switch (_that) {
case _TagStatRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagStatRow value)?  $default,){
final _that = this;
switch (_that) {
case _TagStatRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tagId,  String name,  TagCategory category,  int count,  int directCount,  EvaluationCounts evaluations,  List<TagStatRow> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagStatRow() when $default != null:
return $default(_that.tagId,_that.name,_that.category,_that.count,_that.directCount,_that.evaluations,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tagId,  String name,  TagCategory category,  int count,  int directCount,  EvaluationCounts evaluations,  List<TagStatRow> children)  $default,) {final _that = this;
switch (_that) {
case _TagStatRow():
return $default(_that.tagId,_that.name,_that.category,_that.count,_that.directCount,_that.evaluations,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tagId,  String name,  TagCategory category,  int count,  int directCount,  EvaluationCounts evaluations,  List<TagStatRow> children)?  $default,) {final _that = this;
switch (_that) {
case _TagStatRow() when $default != null:
return $default(_that.tagId,_that.name,_that.category,_that.count,_that.directCount,_that.evaluations,_that.children);case _:
  return null;

}
}

}

/// @nodoc


class _TagStatRow implements TagStatRow {
  const _TagStatRow({required this.tagId, required this.name, required this.category, required this.count, required this.directCount, required this.evaluations, required  List<TagStatRow> children}): _children = children;
  

@override final  int tagId;
@override final  String name;
@override final  TagCategory category;
/// 자기 자신 또는 자손이 붙은 메모 수. 같은 메모는 한 번만 센다.
@override final  int count;
/// 이 태그 자체가 붙은 메모 수.
@override final  int directCount;
@override final  EvaluationCounts evaluations;
/// 결과에 등장한 자식들.
 final  List<TagStatRow> _children;
/// 결과에 등장한 자식들.
@override List<TagStatRow> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of TagStatRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagStatRowCopyWith<_TagStatRow> get copyWith => __$TagStatRowCopyWithImpl<_TagStatRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagStatRow&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count)&&(identical(other.directCount, directCount) || other.directCount == directCount)&&(identical(other.evaluations, evaluations) || other.evaluations == evaluations)&&const DeepCollectionEquality().equals(other.children, _children));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tagId,name,category,count,directCount,evaluations,const DeepCollectionEquality().hash(_children));
}

@override
String toString() {
    return 'TagStatRow(tagId: $tagId, name: $name, category: $category, count: $count, directCount: $directCount, evaluations: $evaluations, children: $children)';
}


}

/// @nodoc
abstract mixin class _$TagStatRowCopyWith<$Res> implements $TagStatRowCopyWith<$Res> {
  factory _$TagStatRowCopyWith(_TagStatRow value, $Res Function(_TagStatRow) _then) = __$TagStatRowCopyWithImpl;
@override @useResult
$Res call({
 int tagId, String name, TagCategory category, int count, int directCount, EvaluationCounts evaluations, List<TagStatRow> children
});


@override $EvaluationCountsCopyWith<$Res> get evaluations;

}
/// @nodoc
class __$TagStatRowCopyWithImpl<$Res>
    implements _$TagStatRowCopyWith<$Res> {
  __$TagStatRowCopyWithImpl(this._self, this._then);

  final _TagStatRow _self;
  final $Res Function(_TagStatRow) _then;

/// Create a copy of TagStatRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagId = null,Object? name = null,Object? category = null,Object? count = null,Object? directCount = null,Object? evaluations = null,Object? children = null,}) {
  return _then(_TagStatRow(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TagCategory,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,directCount: null == directCount ? _self.directCount : directCount // ignore: cast_nullable_to_non_nullable
as int,evaluations: null == evaluations ? _self.evaluations : evaluations // ignore: cast_nullable_to_non_nullable
as EvaluationCounts,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<TagStatRow>,
  ));
}

/// Create a copy of TagStatRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EvaluationCountsCopyWith<$Res> get evaluations {
  
  return $EvaluationCountsCopyWith<$Res>(_self.evaluations, (value) {
    return _then(_self.copyWith(evaluations: value));
  });
}
}

// dart format on
