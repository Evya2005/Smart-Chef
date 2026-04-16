// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeModel {

 String get id; String get userId; String get title; String? get description; String? get notes; List<String> get tags; int get activeTimeMinutes; int get totalTimeMinutes; int get defaultServings; List<IngredientModel> get ingredients; List<CookStepModel> get steps; String? get imageUrl; String? get sourceUrl; String? get sourceType; String get category; int get version; String? get forkedFromId; bool get isPublic; bool get isFavorite; int get rating; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RecipeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeModelCopyWith<RecipeModel> get copyWith => _$RecipeModelCopyWithImpl<RecipeModel>(this as RecipeModel, _$identity);

  /// Serializes this RecipeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.activeTimeMinutes, activeTimeMinutes) || other.activeTimeMinutes == activeTimeMinutes)&&(identical(other.totalTimeMinutes, totalTimeMinutes) || other.totalTimeMinutes == totalTimeMinutes)&&(identical(other.defaultServings, defaultServings) || other.defaultServings == defaultServings)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.category, category) || other.category == category)&&(identical(other.version, version) || other.version == version)&&(identical(other.forkedFromId, forkedFromId) || other.forkedFromId == forkedFromId)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,title,description,notes,const DeepCollectionEquality().hash(tags),activeTimeMinutes,totalTimeMinutes,defaultServings,const DeepCollectionEquality().hash(ingredients),const DeepCollectionEquality().hash(steps),imageUrl,sourceUrl,sourceType,category,version,forkedFromId,isPublic,isFavorite,rating,createdAt,updatedAt]);

@override
String toString() {
  return 'RecipeModel(id: $id, userId: $userId, title: $title, description: $description, notes: $notes, tags: $tags, activeTimeMinutes: $activeTimeMinutes, totalTimeMinutes: $totalTimeMinutes, defaultServings: $defaultServings, ingredients: $ingredients, steps: $steps, imageUrl: $imageUrl, sourceUrl: $sourceUrl, sourceType: $sourceType, category: $category, version: $version, forkedFromId: $forkedFromId, isPublic: $isPublic, isFavorite: $isFavorite, rating: $rating, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RecipeModelCopyWith<$Res>  {
  factory $RecipeModelCopyWith(RecipeModel value, $Res Function(RecipeModel) _then) = _$RecipeModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String? description, String? notes, List<String> tags, int activeTimeMinutes, int totalTimeMinutes, int defaultServings, List<IngredientModel> ingredients, List<CookStepModel> steps, String? imageUrl, String? sourceUrl, String? sourceType, String category, int version, String? forkedFromId, bool isPublic, bool isFavorite, int rating, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RecipeModelCopyWithImpl<$Res>
    implements $RecipeModelCopyWith<$Res> {
  _$RecipeModelCopyWithImpl(this._self, this._then);

  final RecipeModel _self;
  final $Res Function(RecipeModel) _then;

/// Create a copy of RecipeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? description = freezed,Object? notes = freezed,Object? tags = null,Object? activeTimeMinutes = null,Object? totalTimeMinutes = null,Object? defaultServings = null,Object? ingredients = null,Object? steps = null,Object? imageUrl = freezed,Object? sourceUrl = freezed,Object? sourceType = freezed,Object? category = null,Object? version = null,Object? forkedFromId = freezed,Object? isPublic = null,Object? isFavorite = null,Object? rating = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,activeTimeMinutes: null == activeTimeMinutes ? _self.activeTimeMinutes : activeTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,totalTimeMinutes: null == totalTimeMinutes ? _self.totalTimeMinutes : totalTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultServings: null == defaultServings ? _self.defaultServings : defaultServings // ignore: cast_nullable_to_non_nullable
as int,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<IngredientModel>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<CookStepModel>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,forkedFromId: freezed == forkedFromId ? _self.forkedFromId : forkedFromId // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeModel].
extension RecipeModelPatterns on RecipeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeModel value)  $default,){
final _that = this;
switch (_that) {
case _RecipeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String? description,  String? notes,  List<String> tags,  int activeTimeMinutes,  int totalTimeMinutes,  int defaultServings,  List<IngredientModel> ingredients,  List<CookStepModel> steps,  String? imageUrl,  String? sourceUrl,  String? sourceType,  String category,  int version,  String? forkedFromId,  bool isPublic,  bool isFavorite,  int rating,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.description,_that.notes,_that.tags,_that.activeTimeMinutes,_that.totalTimeMinutes,_that.defaultServings,_that.ingredients,_that.steps,_that.imageUrl,_that.sourceUrl,_that.sourceType,_that.category,_that.version,_that.forkedFromId,_that.isPublic,_that.isFavorite,_that.rating,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String? description,  String? notes,  List<String> tags,  int activeTimeMinutes,  int totalTimeMinutes,  int defaultServings,  List<IngredientModel> ingredients,  List<CookStepModel> steps,  String? imageUrl,  String? sourceUrl,  String? sourceType,  String category,  int version,  String? forkedFromId,  bool isPublic,  bool isFavorite,  int rating,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RecipeModel():
return $default(_that.id,_that.userId,_that.title,_that.description,_that.notes,_that.tags,_that.activeTimeMinutes,_that.totalTimeMinutes,_that.defaultServings,_that.ingredients,_that.steps,_that.imageUrl,_that.sourceUrl,_that.sourceType,_that.category,_that.version,_that.forkedFromId,_that.isPublic,_that.isFavorite,_that.rating,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String? description,  String? notes,  List<String> tags,  int activeTimeMinutes,  int totalTimeMinutes,  int defaultServings,  List<IngredientModel> ingredients,  List<CookStepModel> steps,  String? imageUrl,  String? sourceUrl,  String? sourceType,  String category,  int version,  String? forkedFromId,  bool isPublic,  bool isFavorite,  int rating,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecipeModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.description,_that.notes,_that.tags,_that.activeTimeMinutes,_that.totalTimeMinutes,_that.defaultServings,_that.ingredients,_that.steps,_that.imageUrl,_that.sourceUrl,_that.sourceType,_that.category,_that.version,_that.forkedFromId,_that.isPublic,_that.isFavorite,_that.rating,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeModel implements RecipeModel {
  const _RecipeModel({required this.id, required this.userId, required this.title, this.description, this.notes, required final  List<String> tags, required this.activeTimeMinutes, required this.totalTimeMinutes, required this.defaultServings, required final  List<IngredientModel> ingredients, required final  List<CookStepModel> steps, this.imageUrl, this.sourceUrl, this.sourceType, this.category = 'שונות', this.version = 1, this.forkedFromId, this.isPublic = false, this.isFavorite = false, this.rating = 0, required this.createdAt, required this.updatedAt}): _tags = tags,_ingredients = ingredients,_steps = steps;
  factory _RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String? description;
@override final  String? notes;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  int activeTimeMinutes;
@override final  int totalTimeMinutes;
@override final  int defaultServings;
 final  List<IngredientModel> _ingredients;
@override List<IngredientModel> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

 final  List<CookStepModel> _steps;
@override List<CookStepModel> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  String? imageUrl;
@override final  String? sourceUrl;
@override final  String? sourceType;
@override@JsonKey() final  String category;
@override@JsonKey() final  int version;
@override final  String? forkedFromId;
@override@JsonKey() final  bool isPublic;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  int rating;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RecipeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeModelCopyWith<_RecipeModel> get copyWith => __$RecipeModelCopyWithImpl<_RecipeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.activeTimeMinutes, activeTimeMinutes) || other.activeTimeMinutes == activeTimeMinutes)&&(identical(other.totalTimeMinutes, totalTimeMinutes) || other.totalTimeMinutes == totalTimeMinutes)&&(identical(other.defaultServings, defaultServings) || other.defaultServings == defaultServings)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.category, category) || other.category == category)&&(identical(other.version, version) || other.version == version)&&(identical(other.forkedFromId, forkedFromId) || other.forkedFromId == forkedFromId)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,title,description,notes,const DeepCollectionEquality().hash(_tags),activeTimeMinutes,totalTimeMinutes,defaultServings,const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_steps),imageUrl,sourceUrl,sourceType,category,version,forkedFromId,isPublic,isFavorite,rating,createdAt,updatedAt]);

@override
String toString() {
  return 'RecipeModel(id: $id, userId: $userId, title: $title, description: $description, notes: $notes, tags: $tags, activeTimeMinutes: $activeTimeMinutes, totalTimeMinutes: $totalTimeMinutes, defaultServings: $defaultServings, ingredients: $ingredients, steps: $steps, imageUrl: $imageUrl, sourceUrl: $sourceUrl, sourceType: $sourceType, category: $category, version: $version, forkedFromId: $forkedFromId, isPublic: $isPublic, isFavorite: $isFavorite, rating: $rating, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeModelCopyWith<$Res> implements $RecipeModelCopyWith<$Res> {
  factory _$RecipeModelCopyWith(_RecipeModel value, $Res Function(_RecipeModel) _then) = __$RecipeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String? description, String? notes, List<String> tags, int activeTimeMinutes, int totalTimeMinutes, int defaultServings, List<IngredientModel> ingredients, List<CookStepModel> steps, String? imageUrl, String? sourceUrl, String? sourceType, String category, int version, String? forkedFromId, bool isPublic, bool isFavorite, int rating, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RecipeModelCopyWithImpl<$Res>
    implements _$RecipeModelCopyWith<$Res> {
  __$RecipeModelCopyWithImpl(this._self, this._then);

  final _RecipeModel _self;
  final $Res Function(_RecipeModel) _then;

/// Create a copy of RecipeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? description = freezed,Object? notes = freezed,Object? tags = null,Object? activeTimeMinutes = null,Object? totalTimeMinutes = null,Object? defaultServings = null,Object? ingredients = null,Object? steps = null,Object? imageUrl = freezed,Object? sourceUrl = freezed,Object? sourceType = freezed,Object? category = null,Object? version = null,Object? forkedFromId = freezed,Object? isPublic = null,Object? isFavorite = null,Object? rating = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RecipeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,activeTimeMinutes: null == activeTimeMinutes ? _self.activeTimeMinutes : activeTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,totalTimeMinutes: null == totalTimeMinutes ? _self.totalTimeMinutes : totalTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultServings: null == defaultServings ? _self.defaultServings : defaultServings // ignore: cast_nullable_to_non_nullable
as int,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<IngredientModel>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<CookStepModel>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,forkedFromId: freezed == forkedFromId ? _self.forkedFromId : forkedFromId // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
