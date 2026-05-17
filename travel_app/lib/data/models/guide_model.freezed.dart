// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GuideModel _$GuideModelFromJson(Map<String, dynamic> json) {
  return _GuideModel.fromJson(json);
}

/// @nodoc
mixin _$GuideModel {
  int get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  int get destinationId => throw _privateConstructorUsedError;
  List<String> get langues => throw _privateConstructorUsedError;
  int get experienceAnnees => throw _privateConstructorUsedError;
  double get tarifJour => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  bool get disponible => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuideModelCopyWith<GuideModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuideModelCopyWith<$Res> {
  factory $GuideModelCopyWith(
          GuideModel value, $Res Function(GuideModel) then) =
      _$GuideModelCopyWithImpl<$Res, GuideModel>;
  @useResult
  $Res call(
      {int id,
      String nom,
      int destinationId,
      List<String> langues,
      int experienceAnnees,
      double tarifJour,
      String? description,
      String? image,
      bool disponible});
}

/// @nodoc
class _$GuideModelCopyWithImpl<$Res, $Val extends GuideModel>
    implements $GuideModelCopyWith<$Res> {
  _$GuideModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? destinationId = null,
    Object? langues = null,
    Object? experienceAnnees = null,
    Object? tarifJour = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? disponible = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      destinationId: null == destinationId
          ? _value.destinationId
          : destinationId // ignore: cast_nullable_to_non_nullable
              as int,
      langues: null == langues
          ? _value.langues
          : langues // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceAnnees: null == experienceAnnees
          ? _value.experienceAnnees
          : experienceAnnees // ignore: cast_nullable_to_non_nullable
              as int,
      tarifJour: null == tarifJour
          ? _value.tarifJour
          : tarifJour // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      disponible: null == disponible
          ? _value.disponible
          : disponible // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuideModelImplCopyWith<$Res>
    implements $GuideModelCopyWith<$Res> {
  factory _$$GuideModelImplCopyWith(
          _$GuideModelImpl value, $Res Function(_$GuideModelImpl) then) =
      __$$GuideModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nom,
      int destinationId,
      List<String> langues,
      int experienceAnnees,
      double tarifJour,
      String? description,
      String? image,
      bool disponible});
}

/// @nodoc
class __$$GuideModelImplCopyWithImpl<$Res>
    extends _$GuideModelCopyWithImpl<$Res, _$GuideModelImpl>
    implements _$$GuideModelImplCopyWith<$Res> {
  __$$GuideModelImplCopyWithImpl(
      _$GuideModelImpl _value, $Res Function(_$GuideModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? destinationId = null,
    Object? langues = null,
    Object? experienceAnnees = null,
    Object? tarifJour = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? disponible = null,
  }) {
    return _then(_$GuideModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      destinationId: null == destinationId
          ? _value.destinationId
          : destinationId // ignore: cast_nullable_to_non_nullable
              as int,
      langues: null == langues
          ? _value._langues
          : langues // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceAnnees: null == experienceAnnees
          ? _value.experienceAnnees
          : experienceAnnees // ignore: cast_nullable_to_non_nullable
              as int,
      tarifJour: null == tarifJour
          ? _value.tarifJour
          : tarifJour // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      disponible: null == disponible
          ? _value.disponible
          : disponible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GuideModelImpl implements _GuideModel {
  const _$GuideModelImpl(
      {required this.id,
      required this.nom,
      required this.destinationId,
      required final List<String> langues,
      this.experienceAnnees = 0,
      required this.tarifJour,
      this.description,
      this.image,
      this.disponible = true})
      : _langues = langues;

  factory _$GuideModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuideModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nom;
  @override
  final int destinationId;
  final List<String> _langues;
  @override
  List<String> get langues {
    if (_langues is EqualUnmodifiableListView) return _langues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_langues);
  }

  @override
  @JsonKey()
  final int experienceAnnees;
  @override
  final double tarifJour;
  @override
  final String? description;
  @override
  final String? image;
  @override
  @JsonKey()
  final bool disponible;

  @override
  String toString() {
    return 'GuideModel(id: $id, nom: $nom, destinationId: $destinationId, langues: $langues, experienceAnnees: $experienceAnnees, tarifJour: $tarifJour, description: $description, image: $image, disponible: $disponible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.destinationId, destinationId) ||
                other.destinationId == destinationId) &&
            const DeepCollectionEquality().equals(other._langues, _langues) &&
            (identical(other.experienceAnnees, experienceAnnees) ||
                other.experienceAnnees == experienceAnnees) &&
            (identical(other.tarifJour, tarifJour) ||
                other.tarifJour == tarifJour) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.disponible, disponible) ||
                other.disponible == disponible));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nom,
      destinationId,
      const DeepCollectionEquality().hash(_langues),
      experienceAnnees,
      tarifJour,
      description,
      image,
      disponible);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideModelImplCopyWith<_$GuideModelImpl> get copyWith =>
      __$$GuideModelImplCopyWithImpl<_$GuideModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuideModelImplToJson(
      this,
    );
  }
}

abstract class _GuideModel implements GuideModel {
  const factory _GuideModel(
      {required final int id,
      required final String nom,
      required final int destinationId,
      required final List<String> langues,
      final int experienceAnnees,
      required final double tarifJour,
      final String? description,
      final String? image,
      final bool disponible}) = _$GuideModelImpl;

  factory _GuideModel.fromJson(Map<String, dynamic> json) =
      _$GuideModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nom;
  @override
  int get destinationId;
  @override
  List<String> get langues;
  @override
  int get experienceAnnees;
  @override
  double get tarifJour;
  @override
  String? get description;
  @override
  String? get image;
  @override
  bool get disponible;
  @override
  @JsonKey(ignore: true)
  _$$GuideModelImplCopyWith<_$GuideModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
