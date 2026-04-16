// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cooking_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiseEnPlaceItemModel {

 String get id; String get name; double get quantity; UnitType get unit; String? get prepNote; List<String> get forRecipeIds;
/// Create a copy of MiseEnPlaceItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiseEnPlaceItemModelCopyWith<MiseEnPlaceItemModel> get copyWith => _$MiseEnPlaceItemModelCopyWithImpl<MiseEnPlaceItemModel>(this as MiseEnPlaceItemModel, _$identity);

  /// Serializes this MiseEnPlaceItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiseEnPlaceItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.prepNote, prepNote) || other.prepNote == prepNote)&&const DeepCollectionEquality().equals(other.forRecipeIds, forRecipeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,quantity,unit,prepNote,const DeepCollectionEquality().hash(forRecipeIds));

@override
String toString() {
  return 'MiseEnPlaceItemModel(id: $id, name: $name, quantity: $quantity, unit: $unit, prepNote: $prepNote, forRecipeIds: $forRecipeIds)';
}


}

/// @nodoc
abstract mixin class $MiseEnPlaceItemModelCopyWith<$Res>  {
  factory $MiseEnPlaceItemModelCopyWith(MiseEnPlaceItemModel value, $Res Function(MiseEnPlaceItemModel) _then) = _$MiseEnPlaceItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, double quantity, UnitType unit, String? prepNote, List<String> forRecipeIds
});




}
/// @nodoc
class _$MiseEnPlaceItemModelCopyWithImpl<$Res>
    implements $MiseEnPlaceItemModelCopyWith<$Res> {
  _$MiseEnPlaceItemModelCopyWithImpl(this._self, this._then);

  final MiseEnPlaceItemModel _self;
  final $Res Function(MiseEnPlaceItemModel) _then;

/// Create a copy of MiseEnPlaceItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? unit = null,Object? prepNote = freezed,Object? forRecipeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as UnitType,prepNote: freezed == prepNote ? _self.prepNote : prepNote // ignore: cast_nullable_to_non_nullable
as String?,forRecipeIds: null == forRecipeIds ? _self.forRecipeIds : forRecipeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiseEnPlaceItemModel].
extension MiseEnPlaceItemModelPatterns on MiseEnPlaceItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiseEnPlaceItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiseEnPlaceItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiseEnPlaceItemModel value)  $default,){
final _that = this;
switch (_that) {
case _MiseEnPlaceItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiseEnPlaceItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _MiseEnPlaceItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double quantity,  UnitType unit,  String? prepNote,  List<String> forRecipeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiseEnPlaceItemModel() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.unit,_that.prepNote,_that.forRecipeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double quantity,  UnitType unit,  String? prepNote,  List<String> forRecipeIds)  $default,) {final _that = this;
switch (_that) {
case _MiseEnPlaceItemModel():
return $default(_that.id,_that.name,_that.quantity,_that.unit,_that.prepNote,_that.forRecipeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double quantity,  UnitType unit,  String? prepNote,  List<String> forRecipeIds)?  $default,) {final _that = this;
switch (_that) {
case _MiseEnPlaceItemModel() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.unit,_that.prepNote,_that.forRecipeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiseEnPlaceItemModel implements MiseEnPlaceItemModel {
  const _MiseEnPlaceItemModel({required this.id, required this.name, required this.quantity, required this.unit, this.prepNote, final  List<String> forRecipeIds = const []}): _forRecipeIds = forRecipeIds;
  factory _MiseEnPlaceItemModel.fromJson(Map<String, dynamic> json) => _$MiseEnPlaceItemModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  double quantity;
@override final  UnitType unit;
@override final  String? prepNote;
 final  List<String> _forRecipeIds;
@override@JsonKey() List<String> get forRecipeIds {
  if (_forRecipeIds is EqualUnmodifiableListView) return _forRecipeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_forRecipeIds);
}


/// Create a copy of MiseEnPlaceItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiseEnPlaceItemModelCopyWith<_MiseEnPlaceItemModel> get copyWith => __$MiseEnPlaceItemModelCopyWithImpl<_MiseEnPlaceItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiseEnPlaceItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiseEnPlaceItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.prepNote, prepNote) || other.prepNote == prepNote)&&const DeepCollectionEquality().equals(other._forRecipeIds, _forRecipeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,quantity,unit,prepNote,const DeepCollectionEquality().hash(_forRecipeIds));

@override
String toString() {
  return 'MiseEnPlaceItemModel(id: $id, name: $name, quantity: $quantity, unit: $unit, prepNote: $prepNote, forRecipeIds: $forRecipeIds)';
}


}

/// @nodoc
abstract mixin class _$MiseEnPlaceItemModelCopyWith<$Res> implements $MiseEnPlaceItemModelCopyWith<$Res> {
  factory _$MiseEnPlaceItemModelCopyWith(_MiseEnPlaceItemModel value, $Res Function(_MiseEnPlaceItemModel) _then) = __$MiseEnPlaceItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double quantity, UnitType unit, String? prepNote, List<String> forRecipeIds
});




}
/// @nodoc
class __$MiseEnPlaceItemModelCopyWithImpl<$Res>
    implements _$MiseEnPlaceItemModelCopyWith<$Res> {
  __$MiseEnPlaceItemModelCopyWithImpl(this._self, this._then);

  final _MiseEnPlaceItemModel _self;
  final $Res Function(_MiseEnPlaceItemModel) _then;

/// Create a copy of MiseEnPlaceItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? unit = null,Object? prepNote = freezed,Object? forRecipeIds = null,}) {
  return _then(_MiseEnPlaceItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as UnitType,prepNote: freezed == prepNote ? _self.prepNote : prepNote // ignore: cast_nullable_to_non_nullable
as String?,forRecipeIds: null == forRecipeIds ? _self._forRecipeIds : forRecipeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CookingSessionModel {

 String get id; String get userId;/// Ordered list of recipe IDs (longest-first suggested order).
 List<String> get recipeIds;/// Current step index per recipe (recipeId → stepIndex).
 Map<String, int> get recipeProgress;/// Which recipe is currently in focus.
 String? get activeRecipeId;/// Optional target ready time (ISO8601).
 String? get targetReadyTime;/// When the session was started (ISO8601).
 String get startedAt;/// Non-null when all recipes are done (ISO8601).
 String? get completedAt; List<String> get completedRecipeIds;/// Aggregated mise en place items across all recipes.
 List<MiseEnPlaceItemModel> get miseEnPlace;/// Which mise en place items have been checked off (itemId → done).
 Map<String, bool> get miseEnPlaceChecked;/// Snapshot of recipe titles at session-creation time (recipeId → title).
 Map<String, String> get recipeNames;
/// Create a copy of CookingSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookingSessionModelCopyWith<CookingSessionModel> get copyWith => _$CookingSessionModelCopyWithImpl<CookingSessionModel>(this as CookingSessionModel, _$identity);

  /// Serializes this CookingSessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CookingSessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.recipeIds, recipeIds)&&const DeepCollectionEquality().equals(other.recipeProgress, recipeProgress)&&(identical(other.activeRecipeId, activeRecipeId) || other.activeRecipeId == activeRecipeId)&&(identical(other.targetReadyTime, targetReadyTime) || other.targetReadyTime == targetReadyTime)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other.completedRecipeIds, completedRecipeIds)&&const DeepCollectionEquality().equals(other.miseEnPlace, miseEnPlace)&&const DeepCollectionEquality().equals(other.miseEnPlaceChecked, miseEnPlaceChecked)&&const DeepCollectionEquality().equals(other.recipeNames, recipeNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(recipeIds),const DeepCollectionEquality().hash(recipeProgress),activeRecipeId,targetReadyTime,startedAt,completedAt,const DeepCollectionEquality().hash(completedRecipeIds),const DeepCollectionEquality().hash(miseEnPlace),const DeepCollectionEquality().hash(miseEnPlaceChecked),const DeepCollectionEquality().hash(recipeNames));

@override
String toString() {
  return 'CookingSessionModel(id: $id, userId: $userId, recipeIds: $recipeIds, recipeProgress: $recipeProgress, activeRecipeId: $activeRecipeId, targetReadyTime: $targetReadyTime, startedAt: $startedAt, completedAt: $completedAt, completedRecipeIds: $completedRecipeIds, miseEnPlace: $miseEnPlace, miseEnPlaceChecked: $miseEnPlaceChecked, recipeNames: $recipeNames)';
}


}

/// @nodoc
abstract mixin class $CookingSessionModelCopyWith<$Res>  {
  factory $CookingSessionModelCopyWith(CookingSessionModel value, $Res Function(CookingSessionModel) _then) = _$CookingSessionModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, List<String> recipeIds, Map<String, int> recipeProgress, String? activeRecipeId, String? targetReadyTime, String startedAt, String? completedAt, List<String> completedRecipeIds, List<MiseEnPlaceItemModel> miseEnPlace, Map<String, bool> miseEnPlaceChecked, Map<String, String> recipeNames
});




}
/// @nodoc
class _$CookingSessionModelCopyWithImpl<$Res>
    implements $CookingSessionModelCopyWith<$Res> {
  _$CookingSessionModelCopyWithImpl(this._self, this._then);

  final CookingSessionModel _self;
  final $Res Function(CookingSessionModel) _then;

/// Create a copy of CookingSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? recipeIds = null,Object? recipeProgress = null,Object? activeRecipeId = freezed,Object? targetReadyTime = freezed,Object? startedAt = null,Object? completedAt = freezed,Object? completedRecipeIds = null,Object? miseEnPlace = null,Object? miseEnPlaceChecked = null,Object? recipeNames = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,recipeIds: null == recipeIds ? _self.recipeIds : recipeIds // ignore: cast_nullable_to_non_nullable
as List<String>,recipeProgress: null == recipeProgress ? _self.recipeProgress : recipeProgress // ignore: cast_nullable_to_non_nullable
as Map<String, int>,activeRecipeId: freezed == activeRecipeId ? _self.activeRecipeId : activeRecipeId // ignore: cast_nullable_to_non_nullable
as String?,targetReadyTime: freezed == targetReadyTime ? _self.targetReadyTime : targetReadyTime // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,completedRecipeIds: null == completedRecipeIds ? _self.completedRecipeIds : completedRecipeIds // ignore: cast_nullable_to_non_nullable
as List<String>,miseEnPlace: null == miseEnPlace ? _self.miseEnPlace : miseEnPlace // ignore: cast_nullable_to_non_nullable
as List<MiseEnPlaceItemModel>,miseEnPlaceChecked: null == miseEnPlaceChecked ? _self.miseEnPlaceChecked : miseEnPlaceChecked // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,recipeNames: null == recipeNames ? _self.recipeNames : recipeNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CookingSessionModel].
extension CookingSessionModelPatterns on CookingSessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CookingSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CookingSessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CookingSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _CookingSessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CookingSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _CookingSessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  List<String> recipeIds,  Map<String, int> recipeProgress,  String? activeRecipeId,  String? targetReadyTime,  String startedAt,  String? completedAt,  List<String> completedRecipeIds,  List<MiseEnPlaceItemModel> miseEnPlace,  Map<String, bool> miseEnPlaceChecked,  Map<String, String> recipeNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CookingSessionModel() when $default != null:
return $default(_that.id,_that.userId,_that.recipeIds,_that.recipeProgress,_that.activeRecipeId,_that.targetReadyTime,_that.startedAt,_that.completedAt,_that.completedRecipeIds,_that.miseEnPlace,_that.miseEnPlaceChecked,_that.recipeNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  List<String> recipeIds,  Map<String, int> recipeProgress,  String? activeRecipeId,  String? targetReadyTime,  String startedAt,  String? completedAt,  List<String> completedRecipeIds,  List<MiseEnPlaceItemModel> miseEnPlace,  Map<String, bool> miseEnPlaceChecked,  Map<String, String> recipeNames)  $default,) {final _that = this;
switch (_that) {
case _CookingSessionModel():
return $default(_that.id,_that.userId,_that.recipeIds,_that.recipeProgress,_that.activeRecipeId,_that.targetReadyTime,_that.startedAt,_that.completedAt,_that.completedRecipeIds,_that.miseEnPlace,_that.miseEnPlaceChecked,_that.recipeNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  List<String> recipeIds,  Map<String, int> recipeProgress,  String? activeRecipeId,  String? targetReadyTime,  String startedAt,  String? completedAt,  List<String> completedRecipeIds,  List<MiseEnPlaceItemModel> miseEnPlace,  Map<String, bool> miseEnPlaceChecked,  Map<String, String> recipeNames)?  $default,) {final _that = this;
switch (_that) {
case _CookingSessionModel() when $default != null:
return $default(_that.id,_that.userId,_that.recipeIds,_that.recipeProgress,_that.activeRecipeId,_that.targetReadyTime,_that.startedAt,_that.completedAt,_that.completedRecipeIds,_that.miseEnPlace,_that.miseEnPlaceChecked,_that.recipeNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CookingSessionModel implements CookingSessionModel {
  const _CookingSessionModel({required this.id, required this.userId, required final  List<String> recipeIds, final  Map<String, int> recipeProgress = const {}, this.activeRecipeId, this.targetReadyTime, required this.startedAt, this.completedAt, final  List<String> completedRecipeIds = const [], final  List<MiseEnPlaceItemModel> miseEnPlace = const [], final  Map<String, bool> miseEnPlaceChecked = const {}, final  Map<String, String> recipeNames = const {}}): _recipeIds = recipeIds,_recipeProgress = recipeProgress,_completedRecipeIds = completedRecipeIds,_miseEnPlace = miseEnPlace,_miseEnPlaceChecked = miseEnPlaceChecked,_recipeNames = recipeNames;
  factory _CookingSessionModel.fromJson(Map<String, dynamic> json) => _$CookingSessionModelFromJson(json);

@override final  String id;
@override final  String userId;
/// Ordered list of recipe IDs (longest-first suggested order).
 final  List<String> _recipeIds;
/// Ordered list of recipe IDs (longest-first suggested order).
@override List<String> get recipeIds {
  if (_recipeIds is EqualUnmodifiableListView) return _recipeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recipeIds);
}

/// Current step index per recipe (recipeId → stepIndex).
 final  Map<String, int> _recipeProgress;
/// Current step index per recipe (recipeId → stepIndex).
@override@JsonKey() Map<String, int> get recipeProgress {
  if (_recipeProgress is EqualUnmodifiableMapView) return _recipeProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_recipeProgress);
}

/// Which recipe is currently in focus.
@override final  String? activeRecipeId;
/// Optional target ready time (ISO8601).
@override final  String? targetReadyTime;
/// When the session was started (ISO8601).
@override final  String startedAt;
/// Non-null when all recipes are done (ISO8601).
@override final  String? completedAt;
 final  List<String> _completedRecipeIds;
@override@JsonKey() List<String> get completedRecipeIds {
  if (_completedRecipeIds is EqualUnmodifiableListView) return _completedRecipeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedRecipeIds);
}

/// Aggregated mise en place items across all recipes.
 final  List<MiseEnPlaceItemModel> _miseEnPlace;
/// Aggregated mise en place items across all recipes.
@override@JsonKey() List<MiseEnPlaceItemModel> get miseEnPlace {
  if (_miseEnPlace is EqualUnmodifiableListView) return _miseEnPlace;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_miseEnPlace);
}

/// Which mise en place items have been checked off (itemId → done).
 final  Map<String, bool> _miseEnPlaceChecked;
/// Which mise en place items have been checked off (itemId → done).
@override@JsonKey() Map<String, bool> get miseEnPlaceChecked {
  if (_miseEnPlaceChecked is EqualUnmodifiableMapView) return _miseEnPlaceChecked;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_miseEnPlaceChecked);
}

/// Snapshot of recipe titles at session-creation time (recipeId → title).
 final  Map<String, String> _recipeNames;
/// Snapshot of recipe titles at session-creation time (recipeId → title).
@override@JsonKey() Map<String, String> get recipeNames {
  if (_recipeNames is EqualUnmodifiableMapView) return _recipeNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_recipeNames);
}


/// Create a copy of CookingSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CookingSessionModelCopyWith<_CookingSessionModel> get copyWith => __$CookingSessionModelCopyWithImpl<_CookingSessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CookingSessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CookingSessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._recipeIds, _recipeIds)&&const DeepCollectionEquality().equals(other._recipeProgress, _recipeProgress)&&(identical(other.activeRecipeId, activeRecipeId) || other.activeRecipeId == activeRecipeId)&&(identical(other.targetReadyTime, targetReadyTime) || other.targetReadyTime == targetReadyTime)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other._completedRecipeIds, _completedRecipeIds)&&const DeepCollectionEquality().equals(other._miseEnPlace, _miseEnPlace)&&const DeepCollectionEquality().equals(other._miseEnPlaceChecked, _miseEnPlaceChecked)&&const DeepCollectionEquality().equals(other._recipeNames, _recipeNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(_recipeIds),const DeepCollectionEquality().hash(_recipeProgress),activeRecipeId,targetReadyTime,startedAt,completedAt,const DeepCollectionEquality().hash(_completedRecipeIds),const DeepCollectionEquality().hash(_miseEnPlace),const DeepCollectionEquality().hash(_miseEnPlaceChecked),const DeepCollectionEquality().hash(_recipeNames));

@override
String toString() {
  return 'CookingSessionModel(id: $id, userId: $userId, recipeIds: $recipeIds, recipeProgress: $recipeProgress, activeRecipeId: $activeRecipeId, targetReadyTime: $targetReadyTime, startedAt: $startedAt, completedAt: $completedAt, completedRecipeIds: $completedRecipeIds, miseEnPlace: $miseEnPlace, miseEnPlaceChecked: $miseEnPlaceChecked, recipeNames: $recipeNames)';
}


}

/// @nodoc
abstract mixin class _$CookingSessionModelCopyWith<$Res> implements $CookingSessionModelCopyWith<$Res> {
  factory _$CookingSessionModelCopyWith(_CookingSessionModel value, $Res Function(_CookingSessionModel) _then) = __$CookingSessionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, List<String> recipeIds, Map<String, int> recipeProgress, String? activeRecipeId, String? targetReadyTime, String startedAt, String? completedAt, List<String> completedRecipeIds, List<MiseEnPlaceItemModel> miseEnPlace, Map<String, bool> miseEnPlaceChecked, Map<String, String> recipeNames
});




}
/// @nodoc
class __$CookingSessionModelCopyWithImpl<$Res>
    implements _$CookingSessionModelCopyWith<$Res> {
  __$CookingSessionModelCopyWithImpl(this._self, this._then);

  final _CookingSessionModel _self;
  final $Res Function(_CookingSessionModel) _then;

/// Create a copy of CookingSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? recipeIds = null,Object? recipeProgress = null,Object? activeRecipeId = freezed,Object? targetReadyTime = freezed,Object? startedAt = null,Object? completedAt = freezed,Object? completedRecipeIds = null,Object? miseEnPlace = null,Object? miseEnPlaceChecked = null,Object? recipeNames = null,}) {
  return _then(_CookingSessionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,recipeIds: null == recipeIds ? _self._recipeIds : recipeIds // ignore: cast_nullable_to_non_nullable
as List<String>,recipeProgress: null == recipeProgress ? _self._recipeProgress : recipeProgress // ignore: cast_nullable_to_non_nullable
as Map<String, int>,activeRecipeId: freezed == activeRecipeId ? _self.activeRecipeId : activeRecipeId // ignore: cast_nullable_to_non_nullable
as String?,targetReadyTime: freezed == targetReadyTime ? _self.targetReadyTime : targetReadyTime // ignore: cast_nullable_to_non_nullable
as String?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,completedRecipeIds: null == completedRecipeIds ? _self._completedRecipeIds : completedRecipeIds // ignore: cast_nullable_to_non_nullable
as List<String>,miseEnPlace: null == miseEnPlace ? _self._miseEnPlace : miseEnPlace // ignore: cast_nullable_to_non_nullable
as List<MiseEnPlaceItemModel>,miseEnPlaceChecked: null == miseEnPlaceChecked ? _self._miseEnPlaceChecked : miseEnPlaceChecked // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,recipeNames: null == recipeNames ? _self._recipeNames : recipeNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
