// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_recipe_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlannedRecipeModel {

 String get recipeId; String get recipeTitle; int get servings; String? get computedStartTime;
/// Create a copy of PlannedRecipeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedRecipeModelCopyWith<PlannedRecipeModel> get copyWith => _$PlannedRecipeModelCopyWithImpl<PlannedRecipeModel>(this as PlannedRecipeModel, _$identity);

  /// Serializes this PlannedRecipeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedRecipeModel&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeTitle, recipeTitle) || other.recipeTitle == recipeTitle)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.computedStartTime, computedStartTime) || other.computedStartTime == computedStartTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipeId,recipeTitle,servings,computedStartTime);

@override
String toString() {
  return 'PlannedRecipeModel(recipeId: $recipeId, recipeTitle: $recipeTitle, servings: $servings, computedStartTime: $computedStartTime)';
}


}

/// @nodoc
abstract mixin class $PlannedRecipeModelCopyWith<$Res>  {
  factory $PlannedRecipeModelCopyWith(PlannedRecipeModel value, $Res Function(PlannedRecipeModel) _then) = _$PlannedRecipeModelCopyWithImpl;
@useResult
$Res call({
 String recipeId, String recipeTitle, int servings, String? computedStartTime
});




}
/// @nodoc
class _$PlannedRecipeModelCopyWithImpl<$Res>
    implements $PlannedRecipeModelCopyWith<$Res> {
  _$PlannedRecipeModelCopyWithImpl(this._self, this._then);

  final PlannedRecipeModel _self;
  final $Res Function(PlannedRecipeModel) _then;

/// Create a copy of PlannedRecipeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipeId = null,Object? recipeTitle = null,Object? servings = null,Object? computedStartTime = freezed,}) {
  return _then(_self.copyWith(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,recipeTitle: null == recipeTitle ? _self.recipeTitle : recipeTitle // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,computedStartTime: freezed == computedStartTime ? _self.computedStartTime : computedStartTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedRecipeModel].
extension PlannedRecipeModelPatterns on PlannedRecipeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedRecipeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedRecipeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedRecipeModel value)  $default,){
final _that = this;
switch (_that) {
case _PlannedRecipeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedRecipeModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedRecipeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recipeId,  String recipeTitle,  int servings,  String? computedStartTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedRecipeModel() when $default != null:
return $default(_that.recipeId,_that.recipeTitle,_that.servings,_that.computedStartTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recipeId,  String recipeTitle,  int servings,  String? computedStartTime)  $default,) {final _that = this;
switch (_that) {
case _PlannedRecipeModel():
return $default(_that.recipeId,_that.recipeTitle,_that.servings,_that.computedStartTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recipeId,  String recipeTitle,  int servings,  String? computedStartTime)?  $default,) {final _that = this;
switch (_that) {
case _PlannedRecipeModel() when $default != null:
return $default(_that.recipeId,_that.recipeTitle,_that.servings,_that.computedStartTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlannedRecipeModel implements PlannedRecipeModel {
  const _PlannedRecipeModel({required this.recipeId, required this.recipeTitle, required this.servings, this.computedStartTime});
  factory _PlannedRecipeModel.fromJson(Map<String, dynamic> json) => _$PlannedRecipeModelFromJson(json);

@override final  String recipeId;
@override final  String recipeTitle;
@override final  int servings;
@override final  String? computedStartTime;

/// Create a copy of PlannedRecipeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedRecipeModelCopyWith<_PlannedRecipeModel> get copyWith => __$PlannedRecipeModelCopyWithImpl<_PlannedRecipeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlannedRecipeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedRecipeModel&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeTitle, recipeTitle) || other.recipeTitle == recipeTitle)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.computedStartTime, computedStartTime) || other.computedStartTime == computedStartTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipeId,recipeTitle,servings,computedStartTime);

@override
String toString() {
  return 'PlannedRecipeModel(recipeId: $recipeId, recipeTitle: $recipeTitle, servings: $servings, computedStartTime: $computedStartTime)';
}


}

/// @nodoc
abstract mixin class _$PlannedRecipeModelCopyWith<$Res> implements $PlannedRecipeModelCopyWith<$Res> {
  factory _$PlannedRecipeModelCopyWith(_PlannedRecipeModel value, $Res Function(_PlannedRecipeModel) _then) = __$PlannedRecipeModelCopyWithImpl;
@override @useResult
$Res call({
 String recipeId, String recipeTitle, int servings, String? computedStartTime
});




}
/// @nodoc
class __$PlannedRecipeModelCopyWithImpl<$Res>
    implements _$PlannedRecipeModelCopyWith<$Res> {
  __$PlannedRecipeModelCopyWithImpl(this._self, this._then);

  final _PlannedRecipeModel _self;
  final $Res Function(_PlannedRecipeModel) _then;

/// Create a copy of PlannedRecipeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipeId = null,Object? recipeTitle = null,Object? servings = null,Object? computedStartTime = freezed,}) {
  return _then(_PlannedRecipeModel(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,recipeTitle: null == recipeTitle ? _self.recipeTitle : recipeTitle // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,computedStartTime: freezed == computedStartTime ? _self.computedStartTime : computedStartTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
