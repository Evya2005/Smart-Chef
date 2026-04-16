// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cook_step_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CookStepModel {

 int get stepNumber; String get instruction; int? get timerSeconds; String? get timerLabel;
/// Create a copy of CookStepModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookStepModelCopyWith<CookStepModel> get copyWith => _$CookStepModelCopyWithImpl<CookStepModel>(this as CookStepModel, _$identity);

  /// Serializes this CookStepModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CookStepModel&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds)&&(identical(other.timerLabel, timerLabel) || other.timerLabel == timerLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,instruction,timerSeconds,timerLabel);

@override
String toString() {
  return 'CookStepModel(stepNumber: $stepNumber, instruction: $instruction, timerSeconds: $timerSeconds, timerLabel: $timerLabel)';
}


}

/// @nodoc
abstract mixin class $CookStepModelCopyWith<$Res>  {
  factory $CookStepModelCopyWith(CookStepModel value, $Res Function(CookStepModel) _then) = _$CookStepModelCopyWithImpl;
@useResult
$Res call({
 int stepNumber, String instruction, int? timerSeconds, String? timerLabel
});




}
/// @nodoc
class _$CookStepModelCopyWithImpl<$Res>
    implements $CookStepModelCopyWith<$Res> {
  _$CookStepModelCopyWithImpl(this._self, this._then);

  final CookStepModel _self;
  final $Res Function(CookStepModel) _then;

/// Create a copy of CookStepModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepNumber = null,Object? instruction = null,Object? timerSeconds = freezed,Object? timerLabel = freezed,}) {
  return _then(_self.copyWith(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,timerSeconds: freezed == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int?,timerLabel: freezed == timerLabel ? _self.timerLabel : timerLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CookStepModel].
extension CookStepModelPatterns on CookStepModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CookStepModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CookStepModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CookStepModel value)  $default,){
final _that = this;
switch (_that) {
case _CookStepModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CookStepModel value)?  $default,){
final _that = this;
switch (_that) {
case _CookStepModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepNumber,  String instruction,  int? timerSeconds,  String? timerLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CookStepModel() when $default != null:
return $default(_that.stepNumber,_that.instruction,_that.timerSeconds,_that.timerLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepNumber,  String instruction,  int? timerSeconds,  String? timerLabel)  $default,) {final _that = this;
switch (_that) {
case _CookStepModel():
return $default(_that.stepNumber,_that.instruction,_that.timerSeconds,_that.timerLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepNumber,  String instruction,  int? timerSeconds,  String? timerLabel)?  $default,) {final _that = this;
switch (_that) {
case _CookStepModel() when $default != null:
return $default(_that.stepNumber,_that.instruction,_that.timerSeconds,_that.timerLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CookStepModel implements CookStepModel {
  const _CookStepModel({required this.stepNumber, required this.instruction, this.timerSeconds, this.timerLabel});
  factory _CookStepModel.fromJson(Map<String, dynamic> json) => _$CookStepModelFromJson(json);

@override final  int stepNumber;
@override final  String instruction;
@override final  int? timerSeconds;
@override final  String? timerLabel;

/// Create a copy of CookStepModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CookStepModelCopyWith<_CookStepModel> get copyWith => __$CookStepModelCopyWithImpl<_CookStepModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CookStepModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CookStepModel&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds)&&(identical(other.timerLabel, timerLabel) || other.timerLabel == timerLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,instruction,timerSeconds,timerLabel);

@override
String toString() {
  return 'CookStepModel(stepNumber: $stepNumber, instruction: $instruction, timerSeconds: $timerSeconds, timerLabel: $timerLabel)';
}


}

/// @nodoc
abstract mixin class _$CookStepModelCopyWith<$Res> implements $CookStepModelCopyWith<$Res> {
  factory _$CookStepModelCopyWith(_CookStepModel value, $Res Function(_CookStepModel) _then) = __$CookStepModelCopyWithImpl;
@override @useResult
$Res call({
 int stepNumber, String instruction, int? timerSeconds, String? timerLabel
});




}
/// @nodoc
class __$CookStepModelCopyWithImpl<$Res>
    implements _$CookStepModelCopyWith<$Res> {
  __$CookStepModelCopyWithImpl(this._self, this._then);

  final _CookStepModel _self;
  final $Res Function(_CookStepModel) _then;

/// Create a copy of CookStepModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepNumber = null,Object? instruction = null,Object? timerSeconds = freezed,Object? timerLabel = freezed,}) {
  return _then(_CookStepModel(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,timerSeconds: freezed == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int?,timerLabel: freezed == timerLabel ? _self.timerLabel : timerLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
