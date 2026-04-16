// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimelineEventModel {

 String get recipeId; String get recipeTitle; int get stepNumber; String get instruction; String get startTime;// ISO8601
 String get endTime;// ISO8601
 int? get timerSeconds;
/// Create a copy of TimelineEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEventModelCopyWith<TimelineEventModel> get copyWith => _$TimelineEventModelCopyWithImpl<TimelineEventModel>(this as TimelineEventModel, _$identity);

  /// Serializes this TimelineEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEventModel&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeTitle, recipeTitle) || other.recipeTitle == recipeTitle)&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipeId,recipeTitle,stepNumber,instruction,startTime,endTime,timerSeconds);

@override
String toString() {
  return 'TimelineEventModel(recipeId: $recipeId, recipeTitle: $recipeTitle, stepNumber: $stepNumber, instruction: $instruction, startTime: $startTime, endTime: $endTime, timerSeconds: $timerSeconds)';
}


}

/// @nodoc
abstract mixin class $TimelineEventModelCopyWith<$Res>  {
  factory $TimelineEventModelCopyWith(TimelineEventModel value, $Res Function(TimelineEventModel) _then) = _$TimelineEventModelCopyWithImpl;
@useResult
$Res call({
 String recipeId, String recipeTitle, int stepNumber, String instruction, String startTime, String endTime, int? timerSeconds
});




}
/// @nodoc
class _$TimelineEventModelCopyWithImpl<$Res>
    implements $TimelineEventModelCopyWith<$Res> {
  _$TimelineEventModelCopyWithImpl(this._self, this._then);

  final TimelineEventModel _self;
  final $Res Function(TimelineEventModel) _then;

/// Create a copy of TimelineEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipeId = null,Object? recipeTitle = null,Object? stepNumber = null,Object? instruction = null,Object? startTime = null,Object? endTime = null,Object? timerSeconds = freezed,}) {
  return _then(_self.copyWith(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,recipeTitle: null == recipeTitle ? _self.recipeTitle : recipeTitle // ignore: cast_nullable_to_non_nullable
as String,stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,timerSeconds: freezed == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineEventModel].
extension TimelineEventModelPatterns on TimelineEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineEventModel value)  $default,){
final _that = this;
switch (_that) {
case _TimelineEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recipeId,  String recipeTitle,  int stepNumber,  String instruction,  String startTime,  String endTime,  int? timerSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineEventModel() when $default != null:
return $default(_that.recipeId,_that.recipeTitle,_that.stepNumber,_that.instruction,_that.startTime,_that.endTime,_that.timerSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recipeId,  String recipeTitle,  int stepNumber,  String instruction,  String startTime,  String endTime,  int? timerSeconds)  $default,) {final _that = this;
switch (_that) {
case _TimelineEventModel():
return $default(_that.recipeId,_that.recipeTitle,_that.stepNumber,_that.instruction,_that.startTime,_that.endTime,_that.timerSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recipeId,  String recipeTitle,  int stepNumber,  String instruction,  String startTime,  String endTime,  int? timerSeconds)?  $default,) {final _that = this;
switch (_that) {
case _TimelineEventModel() when $default != null:
return $default(_that.recipeId,_that.recipeTitle,_that.stepNumber,_that.instruction,_that.startTime,_that.endTime,_that.timerSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimelineEventModel implements TimelineEventModel {
  const _TimelineEventModel({required this.recipeId, required this.recipeTitle, required this.stepNumber, required this.instruction, required this.startTime, required this.endTime, this.timerSeconds});
  factory _TimelineEventModel.fromJson(Map<String, dynamic> json) => _$TimelineEventModelFromJson(json);

@override final  String recipeId;
@override final  String recipeTitle;
@override final  int stepNumber;
@override final  String instruction;
@override final  String startTime;
// ISO8601
@override final  String endTime;
// ISO8601
@override final  int? timerSeconds;

/// Create a copy of TimelineEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineEventModelCopyWith<_TimelineEventModel> get copyWith => __$TimelineEventModelCopyWithImpl<_TimelineEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineEventModel&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeTitle, recipeTitle) || other.recipeTitle == recipeTitle)&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipeId,recipeTitle,stepNumber,instruction,startTime,endTime,timerSeconds);

@override
String toString() {
  return 'TimelineEventModel(recipeId: $recipeId, recipeTitle: $recipeTitle, stepNumber: $stepNumber, instruction: $instruction, startTime: $startTime, endTime: $endTime, timerSeconds: $timerSeconds)';
}


}

/// @nodoc
abstract mixin class _$TimelineEventModelCopyWith<$Res> implements $TimelineEventModelCopyWith<$Res> {
  factory _$TimelineEventModelCopyWith(_TimelineEventModel value, $Res Function(_TimelineEventModel) _then) = __$TimelineEventModelCopyWithImpl;
@override @useResult
$Res call({
 String recipeId, String recipeTitle, int stepNumber, String instruction, String startTime, String endTime, int? timerSeconds
});




}
/// @nodoc
class __$TimelineEventModelCopyWithImpl<$Res>
    implements _$TimelineEventModelCopyWith<$Res> {
  __$TimelineEventModelCopyWithImpl(this._self, this._then);

  final _TimelineEventModel _self;
  final $Res Function(_TimelineEventModel) _then;

/// Create a copy of TimelineEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipeId = null,Object? recipeTitle = null,Object? stepNumber = null,Object? instruction = null,Object? startTime = null,Object? endTime = null,Object? timerSeconds = freezed,}) {
  return _then(_TimelineEventModel(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,recipeTitle: null == recipeTitle ? _self.recipeTitle : recipeTitle // ignore: cast_nullable_to_non_nullable
as String,stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,timerSeconds: freezed == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
