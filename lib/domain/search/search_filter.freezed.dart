// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchScope {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchScope);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchScope()';
}


}

/// @nodoc
class $SearchScopeCopyWith<$Res>  {
$SearchScopeCopyWith(SearchScope _, $Res Function(SearchScope) __);
}


/// Adds pattern-matching-related methods to [SearchScope].
extension SearchScopePatterns on SearchScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchScopeAll value)?  all,TResult Function( SearchScopePreset value)?  preset,TResult Function( SearchScopeCustom value)?  custom,TResult Function( SearchScopeRecentSessions value)?  recentSessions,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchScopeAll() when all != null:
return all(_that);case SearchScopePreset() when preset != null:
return preset(_that);case SearchScopeCustom() when custom != null:
return custom(_that);case SearchScopeRecentSessions() when recentSessions != null:
return recentSessions(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchScopeAll value)  all,required TResult Function( SearchScopePreset value)  preset,required TResult Function( SearchScopeCustom value)  custom,required TResult Function( SearchScopeRecentSessions value)  recentSessions,}){
final _that = this;
switch (_that) {
case SearchScopeAll():
return all(_that);case SearchScopePreset():
return preset(_that);case SearchScopeCustom():
return custom(_that);case SearchScopeRecentSessions():
return recentSessions(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchScopeAll value)?  all,TResult? Function( SearchScopePreset value)?  preset,TResult? Function( SearchScopeCustom value)?  custom,TResult? Function( SearchScopeRecentSessions value)?  recentSessions,}){
final _that = this;
switch (_that) {
case SearchScopeAll() when all != null:
return all(_that);case SearchScopePreset() when preset != null:
return preset(_that);case SearchScopeCustom() when custom != null:
return custom(_that);case SearchScopeRecentSessions() when recentSessions != null:
return recentSessions(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function( PeriodPreset preset)?  preset,TResult Function( DateTime start,  DateTime end)?  custom,TResult Function( int count)?  recentSessions,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchScopeAll() when all != null:
return all();case SearchScopePreset() when preset != null:
return preset(_that.preset);case SearchScopeCustom() when custom != null:
return custom(_that.start,_that.end);case SearchScopeRecentSessions() when recentSessions != null:
return recentSessions(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function( PeriodPreset preset)  preset,required TResult Function( DateTime start,  DateTime end)  custom,required TResult Function( int count)  recentSessions,}) {final _that = this;
switch (_that) {
case SearchScopeAll():
return all();case SearchScopePreset():
return preset(_that.preset);case SearchScopeCustom():
return custom(_that.start,_that.end);case SearchScopeRecentSessions():
return recentSessions(_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function( PeriodPreset preset)?  preset,TResult? Function( DateTime start,  DateTime end)?  custom,TResult? Function( int count)?  recentSessions,}) {final _that = this;
switch (_that) {
case SearchScopeAll() when all != null:
return all();case SearchScopePreset() when preset != null:
return preset(_that.preset);case SearchScopeCustom() when custom != null:
return custom(_that.start,_that.end);case SearchScopeRecentSessions() when recentSessions != null:
return recentSessions(_that.count);case _:
  return null;

}
}

}

/// @nodoc


class SearchScopeAll implements SearchScope {
  const SearchScopeAll();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchScopeAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchScope.all()';
}


}




/// @nodoc


class SearchScopePreset implements SearchScope {
  const SearchScopePreset(this.preset);
  

 final  PeriodPreset preset;

/// Create a copy of SearchScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchScopePresetCopyWith<SearchScopePreset> get copyWith => _$SearchScopePresetCopyWithImpl<SearchScopePreset>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchScopePreset&&(identical(other.preset, preset) || other.preset == preset));
}


@override
int get hashCode {
    return Object.hash(runtimeType,preset);
}

@override
String toString() {
    return 'SearchScope.preset(preset: $preset)';
}


}

/// @nodoc
abstract mixin class $SearchScopePresetCopyWith<$Res> implements $SearchScopeCopyWith<$Res> {
  factory $SearchScopePresetCopyWith(SearchScopePreset value, $Res Function(SearchScopePreset) _then) = _$SearchScopePresetCopyWithImpl;
@useResult
$Res call({
 PeriodPreset preset
});




}
/// @nodoc
class _$SearchScopePresetCopyWithImpl<$Res>
    implements $SearchScopePresetCopyWith<$Res> {
  _$SearchScopePresetCopyWithImpl(this._self, this._then);

  final SearchScopePreset _self;
  final $Res Function(SearchScopePreset) _then;

/// Create a copy of SearchScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preset = null,}) {
  return _then(SearchScopePreset(
null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as PeriodPreset,
  ));
}


}

/// @nodoc


class SearchScopeCustom implements SearchScope {
  const SearchScopeCustom({required this.start, required this.end});
  

 final  DateTime start;
 final  DateTime end;

/// Create a copy of SearchScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchScopeCustomCopyWith<SearchScopeCustom> get copyWith => _$SearchScopeCustomCopyWithImpl<SearchScopeCustom>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchScopeCustom&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode {
    return Object.hash(runtimeType,start,end);
}

@override
String toString() {
    return 'SearchScope.custom(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $SearchScopeCustomCopyWith<$Res> implements $SearchScopeCopyWith<$Res> {
  factory $SearchScopeCustomCopyWith(SearchScopeCustom value, $Res Function(SearchScopeCustom) _then) = _$SearchScopeCustomCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class _$SearchScopeCustomCopyWithImpl<$Res>
    implements $SearchScopeCustomCopyWith<$Res> {
  _$SearchScopeCustomCopyWithImpl(this._self, this._then);

  final SearchScopeCustom _self;
  final $Res Function(SearchScopeCustom) _then;

/// Create a copy of SearchScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(SearchScopeCustom(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class SearchScopeRecentSessions implements SearchScope {
  const SearchScopeRecentSessions(this.count);
  

 final  int count;

/// Create a copy of SearchScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchScopeRecentSessionsCopyWith<SearchScopeRecentSessions> get copyWith => _$SearchScopeRecentSessionsCopyWithImpl<SearchScopeRecentSessions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchScopeRecentSessions&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode {
    return Object.hash(runtimeType,count);
}

@override
String toString() {
    return 'SearchScope.recentSessions(count: $count)';
}


}

/// @nodoc
abstract mixin class $SearchScopeRecentSessionsCopyWith<$Res> implements $SearchScopeCopyWith<$Res> {
  factory $SearchScopeRecentSessionsCopyWith(SearchScopeRecentSessions value, $Res Function(SearchScopeRecentSessions) _then) = _$SearchScopeRecentSessionsCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$SearchScopeRecentSessionsCopyWithImpl<$Res>
    implements $SearchScopeRecentSessionsCopyWith<$Res> {
  _$SearchScopeRecentSessionsCopyWithImpl(this._self, this._then);

  final SearchScopeRecentSessions _self;
  final $Res Function(SearchScopeRecentSessions) _then;

/// Create a copy of SearchScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(SearchScopeRecentSessions(
null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SearchFilter {

 SearchScope get scope; Set<MemoEvaluation> get evaluations; Set<int> get tagIds; TagMatchMode get tagMatch; Set<SessionType> get sessionTypes; Set<SurfaceType> get surfaces;/// true = 실내, false = 야외
 Set<bool> get indoorOptions; Set<int> get placeIds;/// 1~3과, "기록 없음"을 뜻하는 null
 Set<int?> get conditionScores;/// null은 "기록 없음"이다.
 Set<CueApplied?> get cueApplied;
/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFilterCopyWith<SearchFilter> get copyWith => _$SearchFilterCopyWithImpl<SearchFilter>(this as SearchFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFilter&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&const DeepCollectionEquality().equals(other.evaluations, _this.evaluations)&&const DeepCollectionEquality().equals(other.tagIds, _this.tagIds)&&(identical(other.tagMatch, _this.tagMatch) || other.tagMatch == _this.tagMatch)&&const DeepCollectionEquality().equals(other.sessionTypes, _this.sessionTypes)&&const DeepCollectionEquality().equals(other.surfaces, _this.surfaces)&&const DeepCollectionEquality().equals(other.indoorOptions, _this.indoorOptions)&&const DeepCollectionEquality().equals(other.placeIds, _this.placeIds)&&const DeepCollectionEquality().equals(other.conditionScores, _this.conditionScores)&&const DeepCollectionEquality().equals(other.cueApplied, _this.cueApplied));
}


@override
int get hashCode {
  final _this = this as SearchFilter;
  return Object.hash(runtimeType,_this.scope,const DeepCollectionEquality().hash(_this.evaluations),const DeepCollectionEquality().hash(_this.tagIds),_this.tagMatch,const DeepCollectionEquality().hash(_this.sessionTypes),const DeepCollectionEquality().hash(_this.surfaces),const DeepCollectionEquality().hash(_this.indoorOptions),const DeepCollectionEquality().hash(_this.placeIds),const DeepCollectionEquality().hash(_this.conditionScores),const DeepCollectionEquality().hash(_this.cueApplied));
}

@override
String toString() {
  final _this = this as SearchFilter;
  return 'SearchFilter(scope: ${_this.scope}, evaluations: ${_this.evaluations}, tagIds: ${_this.tagIds}, tagMatch: ${_this.tagMatch}, sessionTypes: ${_this.sessionTypes}, surfaces: ${_this.surfaces}, indoorOptions: ${_this.indoorOptions}, placeIds: ${_this.placeIds}, conditionScores: ${_this.conditionScores}, cueApplied: ${_this.cueApplied})';
}


}

/// @nodoc
abstract mixin class $SearchFilterCopyWith<$Res>  {
  factory $SearchFilterCopyWith(SearchFilter value, $Res Function(SearchFilter) _then) = _$SearchFilterCopyWithImpl;
@useResult
$Res call({
 SearchScope scope, Set<MemoEvaluation> evaluations, Set<int> tagIds, TagMatchMode tagMatch, Set<SessionType> sessionTypes, Set<SurfaceType> surfaces, Set<bool> indoorOptions, Set<int> placeIds, Set<int?> conditionScores, Set<CueApplied?> cueApplied
});


$SearchScopeCopyWith<$Res> get scope;

}
/// @nodoc
class _$SearchFilterCopyWithImpl<$Res>
    implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._self, this._then);

  final SearchFilter _self;
  final $Res Function(SearchFilter) _then;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? evaluations = null,Object? tagIds = null,Object? tagMatch = null,Object? sessionTypes = null,Object? surfaces = null,Object? indoorOptions = null,Object? placeIds = null,Object? conditionScores = null,Object? cueApplied = null,}) {
  return _then(SearchFilter(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as SearchScope,evaluations: null == evaluations ? _self.evaluations : evaluations // ignore: cast_nullable_to_non_nullable
as Set<MemoEvaluation>,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as Set<int>,tagMatch: null == tagMatch ? _self.tagMatch : tagMatch // ignore: cast_nullable_to_non_nullable
as TagMatchMode,sessionTypes: null == sessionTypes ? _self.sessionTypes : sessionTypes // ignore: cast_nullable_to_non_nullable
as Set<SessionType>,surfaces: null == surfaces ? _self.surfaces : surfaces // ignore: cast_nullable_to_non_nullable
as Set<SurfaceType>,indoorOptions: null == indoorOptions ? _self.indoorOptions : indoorOptions // ignore: cast_nullable_to_non_nullable
as Set<bool>,placeIds: null == placeIds ? _self.placeIds : placeIds // ignore: cast_nullable_to_non_nullable
as Set<int>,conditionScores: null == conditionScores ? _self.conditionScores : conditionScores // ignore: cast_nullable_to_non_nullable
as Set<int?>,cueApplied: null == cueApplied ? _self.cueApplied : cueApplied // ignore: cast_nullable_to_non_nullable
as Set<CueApplied?>,
  ));
}
/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchScopeCopyWith<$Res> get scope {
  
  return $SearchScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchFilter].
extension SearchFilterPatterns on SearchFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchFilter value)  $default,){
final _that = this;
switch (_that) {
case _SearchFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchScope scope,  Set<MemoEvaluation> evaluations,  Set<int> tagIds,  TagMatchMode tagMatch,  Set<SessionType> sessionTypes,  Set<SurfaceType> surfaces,  Set<bool> indoorOptions,  Set<int> placeIds,  Set<int?> conditionScores,  Set<CueApplied?> cueApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that.scope,_that.evaluations,_that.tagIds,_that.tagMatch,_that.sessionTypes,_that.surfaces,_that.indoorOptions,_that.placeIds,_that.conditionScores,_that.cueApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchScope scope,  Set<MemoEvaluation> evaluations,  Set<int> tagIds,  TagMatchMode tagMatch,  Set<SessionType> sessionTypes,  Set<SurfaceType> surfaces,  Set<bool> indoorOptions,  Set<int> placeIds,  Set<int?> conditionScores,  Set<CueApplied?> cueApplied)  $default,) {final _that = this;
switch (_that) {
case _SearchFilter():
return $default(_that.scope,_that.evaluations,_that.tagIds,_that.tagMatch,_that.sessionTypes,_that.surfaces,_that.indoorOptions,_that.placeIds,_that.conditionScores,_that.cueApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchScope scope,  Set<MemoEvaluation> evaluations,  Set<int> tagIds,  TagMatchMode tagMatch,  Set<SessionType> sessionTypes,  Set<SurfaceType> surfaces,  Set<bool> indoorOptions,  Set<int> placeIds,  Set<int?> conditionScores,  Set<CueApplied?> cueApplied)?  $default,) {final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that.scope,_that.evaluations,_that.tagIds,_that.tagMatch,_that.sessionTypes,_that.surfaces,_that.indoorOptions,_that.placeIds,_that.conditionScores,_that.cueApplied);case _:
  return null;

}
}

}

/// @nodoc


class _SearchFilter implements SearchFilter {
  const _SearchFilter({this.scope = const SearchScope.all(),  Set<MemoEvaluation> evaluations = const <MemoEvaluation>{},  Set<int> tagIds = const <int>{}, this.tagMatch = TagMatchMode.any,  Set<SessionType> sessionTypes = const <SessionType>{},  Set<SurfaceType> surfaces = const <SurfaceType>{},  Set<bool> indoorOptions = const <bool>{},  Set<int> placeIds = const <int>{},  Set<int?> conditionScores = const <int?>{},  Set<CueApplied?> cueApplied = const <CueApplied?>{}}): _evaluations = evaluations,_tagIds = tagIds,_sessionTypes = sessionTypes,_surfaces = surfaces,_indoorOptions = indoorOptions,_placeIds = placeIds,_conditionScores = conditionScores,_cueApplied = cueApplied;
  

@override@JsonKey() final  SearchScope scope;
 final  Set<MemoEvaluation> _evaluations;
@override@JsonKey() Set<MemoEvaluation> get evaluations {
  if (_evaluations is EqualUnmodifiableSetView) return _evaluations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_evaluations);
}

 final  Set<int> _tagIds;
@override@JsonKey() Set<int> get tagIds {
  if (_tagIds is EqualUnmodifiableSetView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_tagIds);
}

@override@JsonKey() final  TagMatchMode tagMatch;
 final  Set<SessionType> _sessionTypes;
@override@JsonKey() Set<SessionType> get sessionTypes {
  if (_sessionTypes is EqualUnmodifiableSetView) return _sessionTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_sessionTypes);
}

 final  Set<SurfaceType> _surfaces;
@override@JsonKey() Set<SurfaceType> get surfaces {
  if (_surfaces is EqualUnmodifiableSetView) return _surfaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_surfaces);
}

/// true = 실내, false = 야외
 final  Set<bool> _indoorOptions;
/// true = 실내, false = 야외
@override@JsonKey() Set<bool> get indoorOptions {
  if (_indoorOptions is EqualUnmodifiableSetView) return _indoorOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_indoorOptions);
}

 final  Set<int> _placeIds;
@override@JsonKey() Set<int> get placeIds {
  if (_placeIds is EqualUnmodifiableSetView) return _placeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_placeIds);
}

/// 1~3과, "기록 없음"을 뜻하는 null
 final  Set<int?> _conditionScores;
/// 1~3과, "기록 없음"을 뜻하는 null
@override@JsonKey() Set<int?> get conditionScores {
  if (_conditionScores is EqualUnmodifiableSetView) return _conditionScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_conditionScores);
}

/// null은 "기록 없음"이다.
 final  Set<CueApplied?> _cueApplied;
/// null은 "기록 없음"이다.
@override@JsonKey() Set<CueApplied?> get cueApplied {
  if (_cueApplied is EqualUnmodifiableSetView) return _cueApplied;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_cueApplied);
}


/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchFilterCopyWith<_SearchFilter> get copyWith => __$SearchFilterCopyWithImpl<_SearchFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchFilter&&(identical(other.scope, scope) || other.scope == scope)&&const DeepCollectionEquality().equals(other.evaluations, _evaluations)&&const DeepCollectionEquality().equals(other.tagIds, _tagIds)&&(identical(other.tagMatch, tagMatch) || other.tagMatch == tagMatch)&&const DeepCollectionEquality().equals(other.sessionTypes, _sessionTypes)&&const DeepCollectionEquality().equals(other.surfaces, _surfaces)&&const DeepCollectionEquality().equals(other.indoorOptions, _indoorOptions)&&const DeepCollectionEquality().equals(other.placeIds, _placeIds)&&const DeepCollectionEquality().equals(other.conditionScores, _conditionScores)&&const DeepCollectionEquality().equals(other.cueApplied, _cueApplied));
}


@override
int get hashCode {
    return Object.hash(runtimeType,scope,const DeepCollectionEquality().hash(_evaluations),const DeepCollectionEquality().hash(_tagIds),tagMatch,const DeepCollectionEquality().hash(_sessionTypes),const DeepCollectionEquality().hash(_surfaces),const DeepCollectionEquality().hash(_indoorOptions),const DeepCollectionEquality().hash(_placeIds),const DeepCollectionEquality().hash(_conditionScores),const DeepCollectionEquality().hash(_cueApplied));
}

@override
String toString() {
    return 'SearchFilter(scope: $scope, evaluations: $evaluations, tagIds: $tagIds, tagMatch: $tagMatch, sessionTypes: $sessionTypes, surfaces: $surfaces, indoorOptions: $indoorOptions, placeIds: $placeIds, conditionScores: $conditionScores, cueApplied: $cueApplied)';
}


}

/// @nodoc
abstract mixin class _$SearchFilterCopyWith<$Res> implements $SearchFilterCopyWith<$Res> {
  factory _$SearchFilterCopyWith(_SearchFilter value, $Res Function(_SearchFilter) _then) = __$SearchFilterCopyWithImpl;
@override @useResult
$Res call({
 SearchScope scope, Set<MemoEvaluation> evaluations, Set<int> tagIds, TagMatchMode tagMatch, Set<SessionType> sessionTypes, Set<SurfaceType> surfaces, Set<bool> indoorOptions, Set<int> placeIds, Set<int?> conditionScores, Set<CueApplied?> cueApplied
});


@override $SearchScopeCopyWith<$Res> get scope;

}
/// @nodoc
class __$SearchFilterCopyWithImpl<$Res>
    implements _$SearchFilterCopyWith<$Res> {
  __$SearchFilterCopyWithImpl(this._self, this._then);

  final _SearchFilter _self;
  final $Res Function(_SearchFilter) _then;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? evaluations = null,Object? tagIds = null,Object? tagMatch = null,Object? sessionTypes = null,Object? surfaces = null,Object? indoorOptions = null,Object? placeIds = null,Object? conditionScores = null,Object? cueApplied = null,}) {
  return _then(_SearchFilter(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as SearchScope,evaluations: null == evaluations ? _self._evaluations : evaluations // ignore: cast_nullable_to_non_nullable
as Set<MemoEvaluation>,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as Set<int>,tagMatch: null == tagMatch ? _self.tagMatch : tagMatch // ignore: cast_nullable_to_non_nullable
as TagMatchMode,sessionTypes: null == sessionTypes ? _self._sessionTypes : sessionTypes // ignore: cast_nullable_to_non_nullable
as Set<SessionType>,surfaces: null == surfaces ? _self._surfaces : surfaces // ignore: cast_nullable_to_non_nullable
as Set<SurfaceType>,indoorOptions: null == indoorOptions ? _self._indoorOptions : indoorOptions // ignore: cast_nullable_to_non_nullable
as Set<bool>,placeIds: null == placeIds ? _self._placeIds : placeIds // ignore: cast_nullable_to_non_nullable
as Set<int>,conditionScores: null == conditionScores ? _self._conditionScores : conditionScores // ignore: cast_nullable_to_non_nullable
as Set<int?>,cueApplied: null == cueApplied ? _self._cueApplied : cueApplied // ignore: cast_nullable_to_non_nullable
as Set<CueApplied?>,
  ));
}

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchScopeCopyWith<$Res> get scope {
  
  return $SearchScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}
}

// dart format on
