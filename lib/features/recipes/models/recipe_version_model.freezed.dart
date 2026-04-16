// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_version_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeVersionModel {

 String get id; int get versionNumber; RecipeModel get snapshot; DateTime get savedAt; String? get changeNote;
/// Create a copy of RecipeVersionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeVersionModelCopyWith<RecipeVersionModel> get copyWith => _$RecipeVersionModelCopyWithImpl<RecipeVersionModel>(this as RecipeVersionModel, _$identity);

  /// Serializes this RecipeVersionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeVersionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.changeNote, changeNote) || other.changeNote == changeNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,versionNumber,snapshot,savedAt,changeNote);

@override
String toString() {
  return 'RecipeVersionModel(id: $id, versionNumber: $versionNumber, snapshot: $snapshot, savedAt: $savedAt, changeNote: $changeNote)';
}


}

/// @nodoc
abstract mixin class $RecipeVersionModelCopyWith<$Res>  {
  factory $RecipeVersionModelCopyWith(RecipeVersionModel value, $Res Function(RecipeVersionModel) _then) = _$RecipeVersionModelCopyWithImpl;
@useResult
$Res call({
 String id, int versionNumber, RecipeModel snapshot, DateTime savedAt, String? changeNote
});


$RecipeModelCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$RecipeVersionModelCopyWithImpl<$Res>
    implements $RecipeVersionModelCopyWith<$Res> {
  _$RecipeVersionModelCopyWithImpl(this._self, this._then);

  final RecipeVersionModel _self;
  final $Res Function(RecipeVersionModel) _then;

/// Create a copy of RecipeVersionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? versionNumber = null,Object? snapshot = null,Object? savedAt = null,Object? changeNote = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as RecipeModel,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,changeNote: freezed == changeNote ? _self.changeNote : changeNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RecipeVersionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeModelCopyWith<$Res> get snapshot {
  
  return $RecipeModelCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecipeVersionModel].
extension RecipeVersionModelPatterns on RecipeVersionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeVersionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeVersionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeVersionModel value)  $default,){
final _that = this;
switch (_that) {
case _RecipeVersionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeVersionModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeVersionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int versionNumber,  RecipeModel snapshot,  DateTime savedAt,  String? changeNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeVersionModel() when $default != null:
return $default(_that.id,_that.versionNumber,_that.snapshot,_that.savedAt,_that.changeNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int versionNumber,  RecipeModel snapshot,  DateTime savedAt,  String? changeNote)  $default,) {final _that = this;
switch (_that) {
case _RecipeVersionModel():
return $default(_that.id,_that.versionNumber,_that.snapshot,_that.savedAt,_that.changeNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int versionNumber,  RecipeModel snapshot,  DateTime savedAt,  String? changeNote)?  $default,) {final _that = this;
switch (_that) {
case _RecipeVersionModel() when $default != null:
return $default(_that.id,_that.versionNumber,_that.snapshot,_that.savedAt,_that.changeNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeVersionModel implements RecipeVersionModel {
  const _RecipeVersionModel({required this.id, required this.versionNumber, required this.snapshot, required this.savedAt, this.changeNote});
  factory _RecipeVersionModel.fromJson(Map<String, dynamic> json) => _$RecipeVersionModelFromJson(json);

@override final  String id;
@override final  int versionNumber;
@override final  RecipeModel snapshot;
@override final  DateTime savedAt;
@override final  String? changeNote;

/// Create a copy of RecipeVersionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeVersionModelCopyWith<_RecipeVersionModel> get copyWith => __$RecipeVersionModelCopyWithImpl<_RecipeVersionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeVersionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeVersionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.changeNote, changeNote) || other.changeNote == changeNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,versionNumber,snapshot,savedAt,changeNote);

@override
String toString() {
  return 'RecipeVersionModel(id: $id, versionNumber: $versionNumber, snapshot: $snapshot, savedAt: $savedAt, changeNote: $changeNote)';
}


}

/// @nodoc
abstract mixin class _$RecipeVersionModelCopyWith<$Res> implements $RecipeVersionModelCopyWith<$Res> {
  factory _$RecipeVersionModelCopyWith(_RecipeVersionModel value, $Res Function(_RecipeVersionModel) _then) = __$RecipeVersionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, int versionNumber, RecipeModel snapshot, DateTime savedAt, String? changeNote
});


@override $RecipeModelCopyWith<$Res> get snapshot;

}
/// @nodoc
class __$RecipeVersionModelCopyWithImpl<$Res>
    implements _$RecipeVersionModelCopyWith<$Res> {
  __$RecipeVersionModelCopyWithImpl(this._self, this._then);

  final _RecipeVersionModel _self;
  final $Res Function(_RecipeVersionModel) _then;

/// Create a copy of RecipeVersionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? versionNumber = null,Object? snapshot = null,Object? savedAt = null,Object? changeNote = freezed,}) {
  return _then(_RecipeVersionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as RecipeModel,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,changeNote: freezed == changeNote ? _self.changeNote : changeNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RecipeVersionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeModelCopyWith<$Res> get snapshot {
  
  return $RecipeModelCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

// dart format on
