// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hotel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HotelModel _$HotelModelFromJson(Map<String, dynamic> json) {
  return _HotelModel.fromJson(json);
}

/// @nodoc
mixin _$HotelModel {
  int get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  int get destinationId => throw _privateConstructorUsedError;
  DestinationInfo? get destination => throw _privateConstructorUsedError;
  int get etoiles => throw _privateConstructorUsedError;
  double get prixNuit => throw _privateConstructorUsedError;
  String get adresse => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  bool get disponible => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HotelModelCopyWith<HotelModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotelModelCopyWith<$Res> {
  factory $HotelModelCopyWith(
          HotelModel value, $Res Function(HotelModel) then) =
      _$HotelModelCopyWithImpl<$Res, HotelModel>;
  @useResult
  $Res call(
      {int id,
      String nom,
      int destinationId,
      DestinationInfo? destination,
      int etoiles,
      double prixNuit,
      String adresse,
      String? description,
      String? image,
      bool disponible});

  $DestinationInfoCopyWith<$Res>? get destination;
}

/// @nodoc
class _$HotelModelCopyWithImpl<$Res, $Val extends HotelModel>
    implements $HotelModelCopyWith<$Res> {
  _$HotelModelCopyWithImpl(this._value, this._then);

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
    Object? destination = freezed,
    Object? etoiles = null,
    Object? prixNuit = null,
    Object? adresse = null,
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
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as DestinationInfo?,
      etoiles: null == etoiles
          ? _value.etoiles
          : etoiles // ignore: cast_nullable_to_non_nullable
              as int,
      prixNuit: null == prixNuit
          ? _value.prixNuit
          : prixNuit // ignore: cast_nullable_to_non_nullable
              as double,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
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

  @override
  @pragma('vm:prefer-inline')
  $DestinationInfoCopyWith<$Res>? get destination {
    if (_value.destination == null) {
      return null;
    }

    return $DestinationInfoCopyWith<$Res>(_value.destination!, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HotelModelImplCopyWith<$Res>
    implements $HotelModelCopyWith<$Res> {
  factory _$$HotelModelImplCopyWith(
          _$HotelModelImpl value, $Res Function(_$HotelModelImpl) then) =
      __$$HotelModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nom,
      int destinationId,
      DestinationInfo? destination,
      int etoiles,
      double prixNuit,
      String adresse,
      String? description,
      String? image,
      bool disponible});

  @override
  $DestinationInfoCopyWith<$Res>? get destination;
}

/// @nodoc
class __$$HotelModelImplCopyWithImpl<$Res>
    extends _$HotelModelCopyWithImpl<$Res, _$HotelModelImpl>
    implements _$$HotelModelImplCopyWith<$Res> {
  __$$HotelModelImplCopyWithImpl(
      _$HotelModelImpl _value, $Res Function(_$HotelModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? destinationId = null,
    Object? destination = freezed,
    Object? etoiles = null,
    Object? prixNuit = null,
    Object? adresse = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? disponible = null,
  }) {
    return _then(_$HotelModelImpl(
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
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as DestinationInfo?,
      etoiles: null == etoiles
          ? _value.etoiles
          : etoiles // ignore: cast_nullable_to_non_nullable
              as int,
      prixNuit: null == prixNuit
          ? _value.prixNuit
          : prixNuit // ignore: cast_nullable_to_non_nullable
              as double,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$HotelModelImpl implements _HotelModel {
  const _$HotelModelImpl(
      {required this.id,
      required this.nom,
      required this.destinationId,
      this.destination,
      this.etoiles = 3,
      required this.prixNuit,
      required this.adresse,
      this.description,
      this.image,
      this.disponible = true});

  factory _$HotelModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HotelModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nom;
  @override
  final int destinationId;
  @override
  final DestinationInfo? destination;
  @override
  @JsonKey()
  final int etoiles;
  @override
  final double prixNuit;
  @override
  final String adresse;
  @override
  final String? description;
  @override
  final String? image;
  @override
  @JsonKey()
  final bool disponible;

  @override
  String toString() {
    return 'HotelModel(id: $id, nom: $nom, destinationId: $destinationId, destination: $destination, etoiles: $etoiles, prixNuit: $prixNuit, adresse: $adresse, description: $description, image: $image, disponible: $disponible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HotelModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.destinationId, destinationId) ||
                other.destinationId == destinationId) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.etoiles, etoiles) || other.etoiles == etoiles) &&
            (identical(other.prixNuit, prixNuit) ||
                other.prixNuit == prixNuit) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.disponible, disponible) ||
                other.disponible == disponible));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, nom, destinationId,
      destination, etoiles, prixNuit, adresse, description, image, disponible);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HotelModelImplCopyWith<_$HotelModelImpl> get copyWith =>
      __$$HotelModelImplCopyWithImpl<_$HotelModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HotelModelImplToJson(
      this,
    );
  }
}

abstract class _HotelModel implements HotelModel {
  const factory _HotelModel(
      {required final int id,
      required final String nom,
      required final int destinationId,
      final DestinationInfo? destination,
      final int etoiles,
      required final double prixNuit,
      required final String adresse,
      final String? description,
      final String? image,
      final bool disponible}) = _$HotelModelImpl;

  factory _HotelModel.fromJson(Map<String, dynamic> json) =
      _$HotelModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nom;
  @override
  int get destinationId;
  @override
  DestinationInfo? get destination;
  @override
  int get etoiles;
  @override
  double get prixNuit;
  @override
  String get adresse;
  @override
  String? get description;
  @override
  String? get image;
  @override
  bool get disponible;
  @override
  @JsonKey(ignore: true)
  _$$HotelModelImplCopyWith<_$HotelModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
