// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'substitution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubstitutionModel {

 String get category; String get name; double get quantity; UnitType get unit; String? get prepNote; List<StepUpdate> get stepUpdates;
/// Create a copy of SubstitutionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubstitutionModelCopyWith<SubstitutionModel> get copyWith => _$SubstitutionModelCopyWithImpl<SubstitutionModel>(this as SubstitutionModel, _$identity);

  /// Serializes this SubstitutionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubstitutionModel&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.prepNote, prepNote) || other.prepNote == prepNote)&&const DeepCollectionEquality().equals(other.stepUpdates, stepUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,name,quantity,unit,prepNote,const DeepCollectionEquality().hash(stepUpdates));

@override
String toString() {
  return 'SubstitutionModel(category: $category, name: $name, quantity: $quantity, unit: $unit, prepNote: $prepNote, stepUpdates: $stepUpdates)';
}


}

/// @nodoc
abstract mixin class $SubstitutionModelCopyWith<$Res>  {
  factory $SubstitutionModelCopyWith(SubstitutionModel value, $Res Function(SubstitutionModel) _then) = _$SubstitutionModelCopyWithImpl;
@useResult
$Res call({
 String category, String name, double quantity, UnitType unit, String? prepNote, List<StepUpdate> stepUpdates
});




}
/// @nodoc
class _$SubstitutionModelCopyWithImpl<$Res>
    implements $SubstitutionModelCopyWith<$Res> {
  _$SubstitutionModelCopyWithImpl(this._self, this._then);

  final SubstitutionModel _self;
  final $Res Function(SubstitutionModel) _then;

/// Create a copy of SubstitutionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? name = null,Object? quantity = null,Object? unit = null,Object? prepNote = freezed,Object? stepUpdates = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as UnitType,prepNote: freezed == prepNote ? _self.prepNote : prepNote // ignore: cast_nullable_to_non_nullable
as String?,stepUpdates: null == stepUpdates ? _self.stepUpdates : stepUpdates // ignore: cast_nullable_to_non_nullable
as List<StepUpdate>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubstitutionModel].
extension SubstitutionModelPatterns on SubstitutionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubstitutionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubstitutionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubstitutionModel value)  $default,){
final _that = this;
switch (_that) {
case _SubstitutionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubstitutionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubstitutionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  String name,  double quantity,  UnitType unit,  String? prepNote,  List<StepUpdate> stepUpdates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubstitutionModel() when $default != null:
return $default(_that.category,_that.name,_that.quantity,_that.unit,_that.prepNote,_that.stepUpdates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  String name,  double quantity,  UnitType unit,  String? prepNote,  List<StepUpdate> stepUpdates)  $default,) {final _that = this;
switch (_that) {
case _SubstitutionModel():
return $default(_that.category,_that.name,_that.quantity,_that.unit,_that.prepNote,_that.stepUpdates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  String name,  double quantity,  UnitType unit,  String? prepNote,  List<StepUpdate> stepUpdates)?  $default,) {final _that = this;
switch (_that) {
case _SubstitutionModel() when $default != null:
return $default(_that.category,_that.name,_that.quantity,_that.unit,_that.prepNote,_that.stepUpdates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubstitutionModel implements SubstitutionModel {
  const _SubstitutionModel({required this.category, required this.name, required this.quantity, required this.unit, this.prepNote, final  List<StepUpdate> stepUpdates = const []}): _stepUpdates = stepUpdates;
  factory _SubstitutionModel.fromJson(Map<String, dynamic> json) => _$SubstitutionModelFromJson(json);

@override final  String category;
@override final  String name;
@override final  double quantity;
@override final  UnitType unit;
@override final  String? prepNote;
 final  List<StepUpdate> _stepUpdates;
@override@JsonKey() List<StepUpdate> get stepUpdates {
  if (_stepUpdates is EqualUnmodifiableListView) return _stepUpdates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stepUpdates);
}


/// Create a copy of SubstitutionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubstitutionModelCopyWith<_SubstitutionModel> get copyWith => __$SubstitutionModelCopyWithImpl<_SubstitutionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubstitutionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubstitutionModel&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.prepNote, prepNote) || other.prepNote == prepNote)&&const DeepCollectionEquality().equals(other._stepUpdates, _stepUpdates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,name,quantity,unit,prepNote,const DeepCollectionEquality().hash(_stepUpdates));

@override
String toString() {
  return 'SubstitutionModel(category: $category, name: $name, quantity: $quantity, unit: $unit, prepNote: $prepNote, stepUpdates: $stepUpdates)';
}


}

/// @nodoc
abstract mixin class _$SubstitutionModelCopyWith<$Res> implements $SubstitutionModelCopyWith<$Res> {
  factory _$SubstitutionModelCopyWith(_SubstitutionModel value, $Res Function(_SubstitutionModel) _then) = __$SubstitutionModelCopyWithImpl;
@override @useResult
$Res call({
 String category, String name, double quantity, UnitType unit, String? prepNote, List<StepUpdate> stepUpdates
});




}
/// @nodoc
class __$SubstitutionModelCopyWithImpl<$Res>
    implements _$SubstitutionModelCopyWith<$Res> {
  __$SubstitutionModelCopyWithImpl(this._self, this._then);

  final _SubstitutionModel _self;
  final $Res Function(_SubstitutionModel) _then;

/// Create a copy of SubstitutionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? name = null,Object? quantity = null,Object? unit = null,Object? prepNote = freezed,Object? stepUpdates = null,}) {
  return _then(_SubstitutionModel(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as UnitType,prepNote: freezed == prepNote ? _self.prepNote : prepNote // ignore: cast_nullable_to_non_nullable
as String?,stepUpdates: null == stepUpdates ? _self._stepUpdates : stepUpdates // ignore: cast_nullable_to_non_nullable
as List<StepUpdate>,
  ));
}


}


/// @nodoc
mixin _$StepUpdate {

 int get stepNumber; String get instruction;
/// Create a copy of StepUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepUpdateCopyWith<StepUpdate> get copyWith => _$StepUpdateCopyWithImpl<StepUpdate>(this as StepUpdate, _$identity);

  /// Serializes this StepUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepUpdate&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,instruction);

@override
String toString() {
  return 'StepUpdate(stepNumber: $stepNumber, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class $StepUpdateCopyWith<$Res>  {
  factory $StepUpdateCopyWith(StepUpdate value, $Res Function(StepUpdate) _then) = _$StepUpdateCopyWithImpl;
@useResult
$Res call({
 int stepNumber, String instruction
});




}
/// @nodoc
class _$StepUpdateCopyWithImpl<$Res>
    implements $StepUpdateCopyWith<$Res> {
  _$StepUpdateCopyWithImpl(this._self, this._then);

  final StepUpdate _self;
  final $Res Function(StepUpdate) _then;

/// Create a copy of StepUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepNumber = null,Object? instruction = null,}) {
  return _then(_self.copyWith(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StepUpdate].
extension StepUpdatePatterns on StepUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepUpdate value)  $default,){
final _that = this;
switch (_that) {
case _StepUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _StepUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepNumber,  String instruction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepUpdate() when $default != null:
return $default(_that.stepNumber,_that.instruction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepNumber,  String instruction)  $default,) {final _that = this;
switch (_that) {
case _StepUpdate():
return $default(_that.stepNumber,_that.instruction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepNumber,  String instruction)?  $default,) {final _that = this;
switch (_that) {
case _StepUpdate() when $default != null:
return $default(_that.stepNumber,_that.instruction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepUpdate implements StepUpdate {
  const _StepUpdate({required this.stepNumber, required this.instruction});
  factory _StepUpdate.fromJson(Map<String, dynamic> json) => _$StepUpdateFromJson(json);

@override final  int stepNumber;
@override final  String instruction;

/// Create a copy of StepUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepUpdateCopyWith<_StepUpdate> get copyWith => __$StepUpdateCopyWithImpl<_StepUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepUpdate&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,instruction);

@override
String toString() {
  return 'StepUpdate(stepNumber: $stepNumber, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class _$StepUpdateCopyWith<$Res> implements $StepUpdateCopyWith<$Res> {
  factory _$StepUpdateCopyWith(_StepUpdate value, $Res Function(_StepUpdate) _then) = __$StepUpdateCopyWithImpl;
@override @useResult
$Res call({
 int stepNumber, String instruction
});




}
/// @nodoc
class __$StepUpdateCopyWithImpl<$Res>
    implements _$StepUpdateCopyWith<$Res> {
  __$StepUpdateCopyWithImpl(this._self, this._then);

  final _StepUpdate _self;
  final $Res Function(_StepUpdate) _then;

/// Create a copy of StepUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepNumber = null,Object? instruction = null,}) {
  return _then(_StepUpdate(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
