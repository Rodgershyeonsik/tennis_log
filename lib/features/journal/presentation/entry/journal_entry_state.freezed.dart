// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalEntryState {

/// draft 세션이 아직 안 만들어졌으면 null.
 int? get sessionId; SessionDraft get draft;/// 큐 입력칸의 텍스트. **큐 행(cueId)의 원본은 이 텍스트다.**
/// 텍스트 → cueId 변환은 저장할 때 한다(명세 3번).
 String get cueText;/// 시간 시트의 "자주 쓴 시간" 칩.
 List<SessionTimeRange> get frequentRanges; AutoSaveState get autoSave;/// 저장 버튼을 눌렀는데 장소가 없을 때만 true.
 bool get placeMissing;/// ± 버튼이 한계에 걸려 값이 움직이지 않았을 때의 이유.
 TimeLimit? get timeLimit;/// 저장 버튼 처리 중(중복 실행 방지 + 버튼 비활성).
 bool get finalizing;
/// Create a copy of JournalEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryStateCopyWith<JournalEntryState> get copyWith => _$JournalEntryStateCopyWithImpl<JournalEntryState>(this as JournalEntryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JournalEntryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryState&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.cueText, _this.cueText) || other.cueText == _this.cueText)&&const DeepCollectionEquality().equals(other.frequentRanges, _this.frequentRanges)&&(identical(other.autoSave, _this.autoSave) || other.autoSave == _this.autoSave)&&(identical(other.placeMissing, _this.placeMissing) || other.placeMissing == _this.placeMissing)&&(identical(other.timeLimit, _this.timeLimit) || other.timeLimit == _this.timeLimit)&&(identical(other.finalizing, _this.finalizing) || other.finalizing == _this.finalizing));
}


@override
int get hashCode {
  final _this = this as JournalEntryState;
  return Object.hash(runtimeType,_this.sessionId,_this.draft,_this.cueText,const DeepCollectionEquality().hash(_this.frequentRanges),_this.autoSave,_this.placeMissing,_this.timeLimit,_this.finalizing);
}

@override
String toString() {
  final _this = this as JournalEntryState;
  return 'JournalEntryState(sessionId: ${_this.sessionId}, draft: ${_this.draft}, cueText: ${_this.cueText}, frequentRanges: ${_this.frequentRanges}, autoSave: ${_this.autoSave}, placeMissing: ${_this.placeMissing}, timeLimit: ${_this.timeLimit}, finalizing: ${_this.finalizing})';
}


}

/// @nodoc
abstract mixin class $JournalEntryStateCopyWith<$Res>  {
  factory $JournalEntryStateCopyWith(JournalEntryState value, $Res Function(JournalEntryState) _then) = _$JournalEntryStateCopyWithImpl;
@useResult
$Res call({
 int? sessionId, SessionDraft draft, String cueText, List<SessionTimeRange> frequentRanges, AutoSaveState autoSave, bool placeMissing, TimeLimit? timeLimit, bool finalizing
});


$SessionDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$JournalEntryStateCopyWithImpl<$Res>
    implements $JournalEntryStateCopyWith<$Res> {
  _$JournalEntryStateCopyWithImpl(this._self, this._then);

  final JournalEntryState _self;
  final $Res Function(JournalEntryState) _then;

/// Create a copy of JournalEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? draft = null,Object? cueText = null,Object? frequentRanges = null,Object? autoSave = null,Object? placeMissing = null,Object? timeLimit = freezed,Object? finalizing = null,}) {
  return _then(JournalEntryState(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as SessionDraft,cueText: null == cueText ? _self.cueText : cueText // ignore: cast_nullable_to_non_nullable
as String,frequentRanges: null == frequentRanges ? _self.frequentRanges : frequentRanges // ignore: cast_nullable_to_non_nullable
as List<SessionTimeRange>,autoSave: null == autoSave ? _self.autoSave : autoSave // ignore: cast_nullable_to_non_nullable
as AutoSaveState,placeMissing: null == placeMissing ? _self.placeMissing : placeMissing // ignore: cast_nullable_to_non_nullable
as bool,timeLimit: freezed == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as TimeLimit?,finalizing: null == finalizing ? _self.finalizing : finalizing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of JournalEntryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionDraftCopyWith<$Res> get draft {
  
  return $SessionDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [JournalEntryState].
extension JournalEntryStatePatterns on JournalEntryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryState value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryState value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? sessionId,  SessionDraft draft,  String cueText,  List<SessionTimeRange> frequentRanges,  AutoSaveState autoSave,  bool placeMissing,  TimeLimit? timeLimit,  bool finalizing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryState() when $default != null:
return $default(_that.sessionId,_that.draft,_that.cueText,_that.frequentRanges,_that.autoSave,_that.placeMissing,_that.timeLimit,_that.finalizing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? sessionId,  SessionDraft draft,  String cueText,  List<SessionTimeRange> frequentRanges,  AutoSaveState autoSave,  bool placeMissing,  TimeLimit? timeLimit,  bool finalizing)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryState():
return $default(_that.sessionId,_that.draft,_that.cueText,_that.frequentRanges,_that.autoSave,_that.placeMissing,_that.timeLimit,_that.finalizing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? sessionId,  SessionDraft draft,  String cueText,  List<SessionTimeRange> frequentRanges,  AutoSaveState autoSave,  bool placeMissing,  TimeLimit? timeLimit,  bool finalizing)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryState() when $default != null:
return $default(_that.sessionId,_that.draft,_that.cueText,_that.frequentRanges,_that.autoSave,_that.placeMissing,_that.timeLimit,_that.finalizing);case _:
  return null;

}
}

}

/// @nodoc


class _JournalEntryState extends JournalEntryState {
  const _JournalEntryState({this.sessionId, required this.draft, this.cueText = '',  List<SessionTimeRange> frequentRanges = const <SessionTimeRange>[], this.autoSave = AutoSaveState.idle, this.placeMissing = false, this.timeLimit, this.finalizing = false}): _frequentRanges = frequentRanges,super._();
  

/// draft 세션이 아직 안 만들어졌으면 null.
@override final  int? sessionId;
@override final  SessionDraft draft;
/// 큐 입력칸의 텍스트. **큐 행(cueId)의 원본은 이 텍스트다.**
/// 텍스트 → cueId 변환은 저장할 때 한다(명세 3번).
@override@JsonKey() final  String cueText;
/// 시간 시트의 "자주 쓴 시간" 칩.
 final  List<SessionTimeRange> _frequentRanges;
/// 시간 시트의 "자주 쓴 시간" 칩.
@override@JsonKey() List<SessionTimeRange> get frequentRanges {
  if (_frequentRanges is EqualUnmodifiableListView) return _frequentRanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_frequentRanges);
}

@override@JsonKey() final  AutoSaveState autoSave;
/// 저장 버튼을 눌렀는데 장소가 없을 때만 true.
@override@JsonKey() final  bool placeMissing;
/// ± 버튼이 한계에 걸려 값이 움직이지 않았을 때의 이유.
@override final  TimeLimit? timeLimit;
/// 저장 버튼 처리 중(중복 실행 방지 + 버튼 비활성).
@override@JsonKey() final  bool finalizing;

/// Create a copy of JournalEntryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryStateCopyWith<_JournalEntryState> get copyWith => __$JournalEntryStateCopyWithImpl<_JournalEntryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryState&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.cueText, cueText) || other.cueText == cueText)&&const DeepCollectionEquality().equals(other.frequentRanges, _frequentRanges)&&(identical(other.autoSave, autoSave) || other.autoSave == autoSave)&&(identical(other.placeMissing, placeMissing) || other.placeMissing == placeMissing)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.finalizing, finalizing) || other.finalizing == finalizing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,draft,cueText,const DeepCollectionEquality().hash(_frequentRanges),autoSave,placeMissing,timeLimit,finalizing);
}

@override
String toString() {
    return 'JournalEntryState(sessionId: $sessionId, draft: $draft, cueText: $cueText, frequentRanges: $frequentRanges, autoSave: $autoSave, placeMissing: $placeMissing, timeLimit: $timeLimit, finalizing: $finalizing)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryStateCopyWith<$Res> implements $JournalEntryStateCopyWith<$Res> {
  factory _$JournalEntryStateCopyWith(_JournalEntryState value, $Res Function(_JournalEntryState) _then) = __$JournalEntryStateCopyWithImpl;
@override @useResult
$Res call({
 int? sessionId, SessionDraft draft, String cueText, List<SessionTimeRange> frequentRanges, AutoSaveState autoSave, bool placeMissing, TimeLimit? timeLimit, bool finalizing
});


@override $SessionDraftCopyWith<$Res> get draft;

}
/// @nodoc
class __$JournalEntryStateCopyWithImpl<$Res>
    implements _$JournalEntryStateCopyWith<$Res> {
  __$JournalEntryStateCopyWithImpl(this._self, this._then);

  final _JournalEntryState _self;
  final $Res Function(_JournalEntryState) _then;

/// Create a copy of JournalEntryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? draft = null,Object? cueText = null,Object? frequentRanges = null,Object? autoSave = null,Object? placeMissing = null,Object? timeLimit = freezed,Object? finalizing = null,}) {
  return _then(_JournalEntryState(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as SessionDraft,cueText: null == cueText ? _self.cueText : cueText // ignore: cast_nullable_to_non_nullable
as String,frequentRanges: null == frequentRanges ? _self._frequentRanges : frequentRanges // ignore: cast_nullable_to_non_nullable
as List<SessionTimeRange>,autoSave: null == autoSave ? _self.autoSave : autoSave // ignore: cast_nullable_to_non_nullable
as AutoSaveState,placeMissing: null == placeMissing ? _self.placeMissing : placeMissing // ignore: cast_nullable_to_non_nullable
as bool,timeLimit: freezed == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as TimeLimit?,finalizing: null == finalizing ? _self.finalizing : finalizing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of JournalEntryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionDraftCopyWith<$Res> get draft {
  
  return $SessionDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
