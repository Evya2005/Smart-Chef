// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyPlanModel {

 String get id; String get userId; String get mealTime;// ISO8601
 List<PlannedRecipeModel> get recipes; List<TimelineEventModel>? get timeline; String get createdAt;// ISO8601
 String get notes; String get customInstructions;
/// Create a copy of DailyPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyPlanModelCopyWith<DailyPlanModel> get copyWith => _$DailyPlanModelCopyWithImpl<DailyPlanModel>(this as DailyPlanModel, _$identity);

  /// Serializes this DailyPlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mealTime, mealTime) || other.mealTime == mealTime)&&const DeepCollectionEquality().equals(other.recipes, recipes)&&const DeepCollectionEquality().equals(other.timeline, timeline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.customInstructions, customInstructions) || other.customInstructions == customInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mealTime,const DeepCollectionEquality().hash(recipes),const DeepCollectionEquality().hash(timeline),createdAt,notes,customInstructions);

@override
String toString() {
  return 'DailyPlanModel(id: $id, userId: $userId, mealTime: $mealTime, recipes: $recipes, timeline: $timeline, createdAt: $createdAt, notes: $notes, customInstructions: $customInstructions)';
}


}

/// @nodoc
abstract mixin class $DailyPlanModelCopyWith<$Res>  {
  factory $DailyPlanModelCopyWith(DailyPlanModel value, $Res Function(DailyPlanModel) _then) = _$DailyPlanModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String mealTime, List<PlannedRecipeModel> recipes, List<TimelineEventModel>? timeline, String createdAt, String notes, String customInstructions
});




}
/// @nodoc
class _$DailyPlanModelCopyWithImpl<$Res>
    implements $DailyPlanModelCopyWith<$Res> {
  _$DailyPlanModelCopyWithImpl(this._self, this._then);

  final DailyPlanModel _self;
  final $Res Function(DailyPlanModel) _then;

/// Create a copy of DailyPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mealTime = null,Object? recipes = null,Object? timeline = freezed,Object? createdAt = null,Object? notes = null,Object? customInstructions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mealTime: null == mealTime ? _self.mealTime : mealTime // ignore: cast_nullable_to_non_nullable
as String,recipes: null == recipes ? _self.recipes : recipes // ignore: cast_nullable_to_non_nullable
as List<PlannedRecipeModel>,timeline: freezed == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,customInstructions: null == customInstructions ? _self.customInstructions : customInstructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyPlanModel].
extension DailyPlanModelPatterns on DailyPlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyPlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyPlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyPlanModel value)  $default,){
final _that = this;
switch (_that) {
case _DailyPlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyPlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _DailyPlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String mealTime,  List<PlannedRecipeModel> recipes,  List<TimelineEventModel>? timeline,  String createdAt,  String notes,  String customInstructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyPlanModel() when $default != null:
return $default(_that.id,_that.userId,_that.mealTime,_that.recipes,_that.timeline,_that.createdAt,_that.notes,_that.customInstructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String mealTime,  List<PlannedRecipeModel> recipes,  List<TimelineEventModel>? timeline,  String createdAt,  String notes,  String customInstructions)  $default,) {final _that = this;
switch (_that) {
case _DailyPlanModel():
return $default(_that.id,_that.userId,_that.mealTime,_that.recipes,_that.timeline,_that.createdAt,_that.notes,_that.customInstructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String mealTime,  List<PlannedRecipeModel> recipes,  List<TimelineEventModel>? timeline,  String createdAt,  String notes,  String customInstructions)?  $default,) {final _that = this;
switch (_that) {
case _DailyPlanModel() when $default != null:
return $default(_that.id,_that.userId,_that.mealTime,_that.recipes,_that.timeline,_that.createdAt,_that.notes,_that.customInstructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyPlanModel implements DailyPlanModel {
  const _DailyPlanModel({required this.id, required this.userId, required this.mealTime, required final  List<PlannedRecipeModel> recipes, final  List<TimelineEventModel>? timeline, required this.createdAt, this.notes = '', this.customInstructions = ''}): _recipes = recipes,_timeline = timeline;
  factory _DailyPlanModel.fromJson(Map<String, dynamic> json) => _$DailyPlanModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String mealTime;
// ISO8601
 final  List<PlannedRecipeModel> _recipes;
// ISO8601
@override List<PlannedRecipeModel> get recipes {
  if (_recipes is EqualUnmodifiableListView) return _recipes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recipes);
}

 final  List<TimelineEventModel>? _timeline;
@override List<TimelineEventModel>? get timeline {
  final value = _timeline;
  if (value == null) return null;
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String createdAt;
// ISO8601
@override@JsonKey() final  String notes;
@override@JsonKey() final  String customInstructions;

/// Create a copy of DailyPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyPlanModelCopyWith<_DailyPlanModel> get copyWith => __$DailyPlanModelCopyWithImpl<_DailyPlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyPlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mealTime, mealTime) || other.mealTime == mealTime)&&const DeepCollectionEquality().equals(other._recipes, _recipes)&&const DeepCollectionEquality().equals(other._timeline, _timeline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.customInstructions, customInstructions) || other.customInstructions == customInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mealTime,const DeepCollectionEquality().hash(_recipes),const DeepCollectionEquality().hash(_timeline),createdAt,notes,customInstructions);

@override
String toString() {
  return 'DailyPlanModel(id: $id, userId: $userId, mealTime: $mealTime, recipes: $recipes, timeline: $timeline, createdAt: $createdAt, notes: $notes, customInstructions: $customInstructions)';
}


}

/// @nodoc
abstract mixin class _$DailyPlanModelCopyWith<$Res> implements $DailyPlanModelCopyWith<$Res> {
  factory _$DailyPlanModelCopyWith(_DailyPlanModel value, $Res Function(_DailyPlanModel) _then) = __$DailyPlanModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String mealTime, List<PlannedRecipeModel> recipes, List<TimelineEventModel>? timeline, String createdAt, String notes, String customInstructions
});




}
/// @nodoc
class __$DailyPlanModelCopyWithImpl<$Res>
    implements _$DailyPlanModelCopyWith<$Res> {
  __$DailyPlanModelCopyWithImpl(this._self, this._then);

  final _DailyPlanModel _self;
  final $Res Function(_DailyPlanModel) _then;

/// Create a copy of DailyPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mealTime = null,Object? recipes = null,Object? timeline = freezed,Object? createdAt = null,Object? notes = null,Object? customInstructions = null,}) {
  return _then(_DailyPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mealTime: null == mealTime ? _self.mealTime : mealTime // ignore: cast_nullable_to_non_nullable
as String,recipes: null == recipes ? _self._recipes : recipes // ignore: cast_nullable_to_non_nullable
as List<PlannedRecipeModel>,timeline: freezed == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEventModel>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,customInstructions: null == customInstructions ? _self.customInstructions : customInstructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
