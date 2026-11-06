// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 SearchFilter get filter; MemoSort get memoSort; bool get summaryExpanded;/// 요약 칩으로 좁혀 보는 태그. 필터가 아니라 결과 안에서의 보기 상태다.
 Set<int> get summaryTagIds;/// 태그 선택 시트에서 펼친 분류. 시트를 다시 열어도 남아 있다.
 Set<TagCategory> get expandedTagCategories;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&(identical(other.memoSort, _this.memoSort) || other.memoSort == _this.memoSort)&&(identical(other.summaryExpanded, _this.summaryExpanded) || other.summaryExpanded == _this.summaryExpanded)&&const DeepCollectionEquality().equals(other.summaryTagIds, _this.summaryTagIds)&&const DeepCollectionEquality().equals(other.expandedTagCategories, _this.expandedTagCategories));
}


@override
int get hashCode {
  final _this = this as SearchState;
  return Object.hash(runtimeType,_this.filter,_this.memoSort,_this.summaryExpanded,const DeepCollectionEquality().hash(_this.summaryTagIds),const DeepCollectionEquality().hash(_this.expandedTagCategories));
}

@override
String toString() {
  final _this = this as SearchState;
  return 'SearchState(filter: ${_this.filter}, memoSort: ${_this.memoSort}, summaryExpanded: ${_this.summaryExpanded}, summaryTagIds: ${_this.summaryTagIds}, expandedTagCategories: ${_this.expandedTagCategories})';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 SearchFilter filter, MemoSort memoSort, bool summaryExpanded, Set<int> summaryTagIds, Set<TagCategory> expandedTagCategories
});


$SearchFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filter = null,Object? memoSort = null,Object? summaryExpanded = null,Object? summaryTagIds = null,Object? expandedTagCategories = null,}) {
  return _then(SearchState(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as SearchFilter,memoSort: null == memoSort ? _self.memoSort : memoSort // ignore: cast_nullable_to_non_nullable
as MemoSort,summaryExpanded: null == summaryExpanded ? _self.summaryExpanded : summaryExpanded // ignore: cast_nullable_to_non_nullable
as bool,summaryTagIds: null == summaryTagIds ? _self.summaryTagIds : summaryTagIds // ignore: cast_nullable_to_non_nullable
as Set<int>,expandedTagCategories: null == expandedTagCategories ? _self.expandedTagCategories : expandedTagCategories // ignore: cast_nullable_to_non_nullable
as Set<TagCategory>,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchFilterCopyWith<$Res> get filter {
  
  return $SearchFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchFilter filter,  MemoSort memoSort,  bool summaryExpanded,  Set<int> summaryTagIds,  Set<TagCategory> expandedTagCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.filter,_that.memoSort,_that.summaryExpanded,_that.summaryTagIds,_that.expandedTagCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchFilter filter,  MemoSort memoSort,  bool summaryExpanded,  Set<int> summaryTagIds,  Set<TagCategory> expandedTagCategories)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.filter,_that.memoSort,_that.summaryExpanded,_that.summaryTagIds,_that.expandedTagCategories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchFilter filter,  MemoSort memoSort,  bool summaryExpanded,  Set<int> summaryTagIds,  Set<TagCategory> expandedTagCategories)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.filter,_that.memoSort,_that.summaryExpanded,_that.summaryTagIds,_that.expandedTagCategories);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({this.filter = const SearchFilter(), this.memoSort = MemoSort.newest, this.summaryExpanded = false,  Set<int> summaryTagIds = const <int>{},  Set<TagCategory> expandedTagCategories = const <TagCategory>{}}): _summaryTagIds = summaryTagIds,_expandedTagCategories = expandedTagCategories;
  

@override@JsonKey() final  SearchFilter filter;
@override@JsonKey() final  MemoSort memoSort;
@override@JsonKey() final  bool summaryExpanded;
/// 요약 칩으로 좁혀 보는 태그. 필터가 아니라 결과 안에서의 보기 상태다.
 final  Set<int> _summaryTagIds;
/// 요약 칩으로 좁혀 보는 태그. 필터가 아니라 결과 안에서의 보기 상태다.
@override@JsonKey() Set<int> get summaryTagIds {
  if (_summaryTagIds is EqualUnmodifiableSetView) return _summaryTagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_summaryTagIds);
}

/// 태그 선택 시트에서 펼친 분류. 시트를 다시 열어도 남아 있다.
 final  Set<TagCategory> _expandedTagCategories;
/// 태그 선택 시트에서 펼친 분류. 시트를 다시 열어도 남아 있다.
@override@JsonKey() Set<TagCategory> get expandedTagCategories {
  if (_expandedTagCategories is EqualUnmodifiableSetView) return _expandedTagCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_expandedTagCategories);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.memoSort, memoSort) || other.memoSort == memoSort)&&(identical(other.summaryExpanded, summaryExpanded) || other.summaryExpanded == summaryExpanded)&&const DeepCollectionEquality().equals(other.summaryTagIds, _summaryTagIds)&&const DeepCollectionEquality().equals(other.expandedTagCategories, _expandedTagCategories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,filter,memoSort,summaryExpanded,const DeepCollectionEquality().hash(_summaryTagIds),const DeepCollectionEquality().hash(_expandedTagCategories));
}

@override
String toString() {
    return 'SearchState(filter: $filter, memoSort: $memoSort, summaryExpanded: $summaryExpanded, summaryTagIds: $summaryTagIds, expandedTagCategories: $expandedTagCategories)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 SearchFilter filter, MemoSort memoSort, bool summaryExpanded, Set<int> summaryTagIds, Set<TagCategory> expandedTagCategories
});


@override $SearchFilterCopyWith<$Res> get filter;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filter = null,Object? memoSort = null,Object? summaryExpanded = null,Object? summaryTagIds = null,Object? expandedTagCategories = null,}) {
  return _then(_SearchState(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as SearchFilter,memoSort: null == memoSort ? _self.memoSort : memoSort // ignore: cast_nullable_to_non_nullable
as MemoSort,summaryExpanded: null == summaryExpanded ? _self.summaryExpanded : summaryExpanded // ignore: cast_nullable_to_non_nullable
as bool,summaryTagIds: null == summaryTagIds ? _self._summaryTagIds : summaryTagIds // ignore: cast_nullable_to_non_nullable
as Set<int>,expandedTagCategories: null == expandedTagCategories ? _self._expandedTagCategories : expandedTagCategories // ignore: cast_nullable_to_non_nullable
as Set<TagCategory>,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchFilterCopyWith<$Res> get filter {
  
  return $SearchFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

// dart format on
