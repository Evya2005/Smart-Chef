// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cook_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CookHistoryModel {

 String get id; String get recipeId; String get userId; int get servingsCooked; DateTime get cookedAt; String? get notes; int get rating;
/// Create a copy of CookHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookHistoryModelCopyWith<CookHistoryModel> get copyWith => _$CookHistoryModelCopyWithImpl<CookHistoryModel>(this as CookHistoryModel, _$identity);

  /// Serializes this CookHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CookHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.servingsCooked, servingsCooked) || other.servingsCooked == servingsCooked)&&(identical(other.cookedAt, cookedAt) || other.cookedAt == cookedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipeId,userId,servingsCooked,cookedAt,notes,rating);

@override
String toString() {
  return 'CookHistoryModel(id: $id, recipeId: $recipeId, userId: $userId, servingsCooked: $servingsCooked, cookedAt: $cookedAt, notes: $notes, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $CookHistoryModelCopyWith<$Res>  {
  factory $CookHistoryModelCopyWith(CookHistoryModel value, $Res Function(CookHistoryModel) _then) = _$CookHistoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String recipeId, String userId, int servingsCooked, DateTime cookedAt, String? notes, int rating
});




}
/// @nodoc
class _$CookHistoryModelCopyWithImpl<$Res>
    implements $CookHistoryModelCopyWith<$Res> {
  _$CookHistoryModelCopyWithImpl(this._self, this._then);

  final CookHistoryModel _self;
  final $Res Function(CookHistoryModel) _then;

/// Create a copy of CookHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipeId = null,Object? userId = null,Object? servingsCooked = null,Object? cookedAt = null,Object? notes = freezed,Object? rating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,servingsCooked: null == servingsCooked ? _self.servingsCooked : servingsCooked // ignore: cast_nullable_to_non_nullable
as int,cookedAt: null == cookedAt ? _self.cookedAt : cookedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CookHistoryModel].
extension CookHistoryModelPatterns on CookHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CookHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CookHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CookHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CookHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CookHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CookHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipeId,  String userId,  int servingsCooked,  DateTime cookedAt,  String? notes,  int rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CookHistoryModel() when $default != null:
return $default(_that.id,_that.recipeId,_that.userId,_that.servingsCooked,_that.cookedAt,_that.notes,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipeId,  String userId,  int servingsCooked,  DateTime cookedAt,  String? notes,  int rating)  $default,) {final _that = this;
switch (_that) {
case _CookHistoryModel():
return $default(_that.id,_that.recipeId,_that.userId,_that.servingsCooked,_that.cookedAt,_that.notes,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipeId,  String userId,  int servingsCooked,  DateTime cookedAt,  String? notes,  int rating)?  $default,) {final _that = this;
switch (_that) {
case _CookHistoryModel() when $default != null:
return $default(_that.id,_that.recipeId,_that.userId,_that.servingsCooked,_that.cookedAt,_that.notes,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CookHistoryModel implements CookHistoryModel {
  const _CookHistoryModel({required this.id, required this.recipeId, required this.userId, required this.servingsCooked, required this.cookedAt, this.notes, this.rating = 0});
  factory _CookHistoryModel.fromJson(Map<String, dynamic> json) => _$CookHistoryModelFromJson(json);

@override final  String id;
@override final  String recipeId;
@override final  String userId;
@override final  int servingsCooked;
@override final  DateTime cookedAt;
@override final  String? notes;
@override@JsonKey() final  int rating;

/// Create a copy of CookHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CookHistoryModelCopyWith<_CookHistoryModel> get copyWith => __$CookHistoryModelCopyWithImpl<_CookHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CookHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CookHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.servingsCooked, servingsCooked) || other.servingsCooked == servingsCooked)&&(identical(other.cookedAt, cookedAt) || other.cookedAt == cookedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipeId,userId,servingsCooked,cookedAt,notes,rating);

@override
String toString() {
  return 'CookHistoryModel(id: $id, recipeId: $recipeId, userId: $userId, servingsCooked: $servingsCooked, cookedAt: $cookedAt, notes: $notes, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$CookHistoryModelCopyWith<$Res> implements $CookHistoryModelCopyWith<$Res> {
  factory _$CookHistoryModelCopyWith(_CookHistoryModel value, $Res Function(_CookHistoryModel) _then) = __$CookHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipeId, String userId, int servingsCooked, DateTime cookedAt, String? notes, int rating
});




}
/// @nodoc
class __$CookHistoryModelCopyWithImpl<$Res>
    implements _$CookHistoryModelCopyWith<$Res> {
  __$CookHistoryModelCopyWithImpl(this._self, this._then);

  final _CookHistoryModel _self;
  final $Res Function(_CookHistoryModel) _then;

/// Create a copy of CookHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipeId = null,Object? userId = null,Object? servingsCooked = null,Object? cookedAt = null,Object? notes = freezed,Object? rating = null,}) {
  return _then(_CookHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,servingsCooked: null == servingsCooked ? _self.servingsCooked : servingsCooked // ignore: cast_nullable_to_non_nullable
as int,cookedAt: null == cookedAt ? _self.cookedAt : cookedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
