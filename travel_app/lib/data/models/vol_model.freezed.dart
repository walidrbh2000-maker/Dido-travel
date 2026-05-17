// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vol_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VolModel _$VolModelFromJson(Map<String, dynamic> json) {
  return _VolModel.fromJson(json);
}

/// @nodoc
mixin _$VolModel {
  int get id => throw _privateConstructorUsedError;
  String get compagnie => throw _privateConstructorUsedError;
  String get numeroVol => throw _privateConstructorUsedError;
  int get destinationId => throw _privateConstructorUsedError;
  DestinationInfo? get destination => throw _privateConstructorUsedError;
  String get dateDepart => throw _privateConstructorUsedError;
  String get dateArrivee => throw _privateConstructorUsedError;
  double get prix => throw _privateConstructorUsedError;
  int get placesDisponibles => throw _privateConstructorUsedError;
  String get classe => throw _privateConstructorUsedError;
  String get statut => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VolModelCopyWith<VolModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VolModelCopyWith<$Res> {
  factory $VolModelCopyWith(VolModel value, $Res Function(VolModel) then) =
      _$VolModelCopyWithImpl<$Res, VolModel>;
  @useResult
  $Res call(
      {int id,
      String compagnie,
      String numeroVol,
      int destinationId,
      DestinationInfo? destination,
      String dateDepart,
      String dateArrivee,
      double prix,
      int placesDisponibles,
      String classe,
      String statut});

  $DestinationInfoCopyWith<$Res>? get destination;
}

/// @nodoc
class _$VolModelCopyWithImpl<$Res, $Val extends VolModel>
    implements $VolModelCopyWith<$Res> {
  _$VolModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? compagnie = null,
    Object? numeroVol = null,
    Object? destinationId = null,
    Object? destination = freezed,
    Object? dateDepart = null,
    Object? dateArrivee = null,
    Object? prix = null,
    Object? placesDisponibles = null,
    Object? classe = null,
    Object? statut = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      compagnie: null == compagnie
          ? _value.compagnie
          : compagnie // ignore: cast_nullable_to_non_nullable
              as String,
      numeroVol: null == numeroVol
          ? _value.numeroVol
          : numeroVol // ignore: cast_nullable_to_non_nullable
              as String,
      destinationId: null == destinationId
          ? _value.destinationId
          : destinationId // ignore: cast_nullable_to_non_nullable
              as int,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as DestinationInfo?,
      dateDepart: null == dateDepart
          ? _value.dateDepart
          : dateDepart // ignore: cast_nullable_to_non_nullable
              as String,
      dateArrivee: null == dateArrivee
          ? _value.dateArrivee
          : dateArrivee // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as double,
      placesDisponibles: null == placesDisponibles
          ? _value.placesDisponibles
          : placesDisponibles // ignore: cast_nullable_to_non_nullable
              as int,
      classe: null == classe
          ? _value.classe
          : classe // ignore: cast_nullable_to_non_nullable
              as String,
      statut: null == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$VolModelImplCopyWith<$Res>
    implements $VolModelCopyWith<$Res> {
  factory _$$VolModelImplCopyWith(
          _$VolModelImpl value, $Res Function(_$VolModelImpl) then) =
      __$$VolModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String compagnie,
      String numeroVol,
      int destinationId,
      DestinationInfo? destination,
      String dateDepart,
      String dateArrivee,
      double prix,
      int placesDisponibles,
      String classe,
      String statut});

  @override
  $DestinationInfoCopyWith<$Res>? get destination;
}

/// @nodoc
class __$$VolModelImplCopyWithImpl<$Res>
    extends _$VolModelCopyWithImpl<$Res, _$VolModelImpl>
    implements _$$VolModelImplCopyWith<$Res> {
  __$$VolModelImplCopyWithImpl(
      _$VolModelImpl _value, $Res Function(_$VolModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? compagnie = null,
    Object? numeroVol = null,
    Object? destinationId = null,
    Object? destination = freezed,
    Object? dateDepart = null,
    Object? dateArrivee = null,
    Object? prix = null,
    Object? placesDisponibles = null,
    Object? classe = null,
    Object? statut = null,
  }) {
    return _then(_$VolModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      compagnie: null == compagnie
          ? _value.compagnie
          : compagnie // ignore: cast_nullable_to_non_nullable
              as String,
      numeroVol: null == numeroVol
          ? _value.numeroVol
          : numeroVol // ignore: cast_nullable_to_non_nullable
              as String,
      destinationId: null == destinationId
          ? _value.destinationId
          : destinationId // ignore: cast_nullable_to_non_nullable
              as int,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as DestinationInfo?,
      dateDepart: null == dateDepart
          ? _value.dateDepart
          : dateDepart // ignore: cast_nullable_to_non_nullable
              as String,
      dateArrivee: null == dateArrivee
          ? _value.dateArrivee
          : dateArrivee // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as double,
      placesDisponibles: null == placesDisponibles
          ? _value.placesDisponibles
          : placesDisponibles // ignore: cast_nullable_to_non_nullable
              as int,
      classe: null == classe
          ? _value.classe
          : classe // ignore: cast_nullable_to_non_nullable
              as String,
      statut: null == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VolModelImpl implements _VolModel {
  const _$VolModelImpl(
      {required this.id,
      required this.compagnie,
      required this.numeroVol,
      required this.destinationId,
      this.destination,
      required this.dateDepart,
      required this.dateArrivee,
      required this.prix,
      required this.placesDisponibles,
      this.classe = 'economique',
      this.statut = 'programme'});

  factory _$VolModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VolModelImplFromJson(json);

  @override
  final int id;
  @override
  final String compagnie;
  @override
  final String numeroVol;
  @override
  final int destinationId;
  @override
  final DestinationInfo? destination;
  @override
  final String dateDepart;
  @override
  final String dateArrivee;
  @override
  final double prix;
  @override
  final int placesDisponibles;
  @override
  @JsonKey()
  final String classe;
  @override
  @JsonKey()
  final String statut;

  @override
  String toString() {
    return 'VolModel(id: $id, compagnie: $compagnie, numeroVol: $numeroVol, destinationId: $destinationId, destination: $destination, dateDepart: $dateDepart, dateArrivee: $dateArrivee, prix: $prix, placesDisponibles: $placesDisponibles, classe: $classe, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VolModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.compagnie, compagnie) ||
                other.compagnie == compagnie) &&
            (identical(other.numeroVol, numeroVol) ||
                other.numeroVol == numeroVol) &&
            (identical(other.destinationId, destinationId) ||
                other.destinationId == destinationId) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.dateDepart, dateDepart) ||
                other.dateDepart == dateDepart) &&
            (identical(other.dateArrivee, dateArrivee) ||
                other.dateArrivee == dateArrivee) &&
            (identical(other.prix, prix) || other.prix == prix) &&
            (identical(other.placesDisponibles, placesDisponibles) ||
                other.placesDisponibles == placesDisponibles) &&
            (identical(other.classe, classe) || other.classe == classe) &&
            (identical(other.statut, statut) || other.statut == statut));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      compagnie,
      numeroVol,
      destinationId,
      destination,
      dateDepart,
      dateArrivee,
      prix,
      placesDisponibles,
      classe,
      statut);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VolModelImplCopyWith<_$VolModelImpl> get copyWith =>
      __$$VolModelImplCopyWithImpl<_$VolModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VolModelImplToJson(
      this,
    );
  }
}

abstract class _VolModel implements VolModel {
  const factory _VolModel(
      {required final int id,
      required final String compagnie,
      required final String numeroVol,
      required final int destinationId,
      final DestinationInfo? destination,
      required final String dateDepart,
      required final String dateArrivee,
      required final double prix,
      required final int placesDisponibles,
      final String classe,
      final String statut}) = _$VolModelImpl;

  factory _VolModel.fromJson(Map<String, dynamic> json) =
      _$VolModelImpl.fromJson;

  @override
  int get id;
  @override
  String get compagnie;
  @override
  String get numeroVol;
  @override
  int get destinationId;
  @override
  DestinationInfo? get destination;
  @override
  String get dateDepart;
  @override
  String get dateArrivee;
  @override
  double get prix;
  @override
  int get placesDisponibles;
  @override
  String get classe;
  @override
  String get statut;
  @override
  @JsonKey(ignore: true)
  _$$VolModelImplCopyWith<_$VolModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DestinationInfo _$DestinationInfoFromJson(Map<String, dynamic> json) {
  return _DestinationInfo.fromJson(json);
}

/// @nodoc
mixin _$DestinationInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DestinationInfoCopyWith<DestinationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DestinationInfoCopyWith<$Res> {
  factory $DestinationInfoCopyWith(
          DestinationInfo value, $Res Function(DestinationInfo) then) =
      _$DestinationInfoCopyWithImpl<$Res, DestinationInfo>;
  @useResult
  $Res call({int id, String name, String country});
}

/// @nodoc
class _$DestinationInfoCopyWithImpl<$Res, $Val extends DestinationInfo>
    implements $DestinationInfoCopyWith<$Res> {
  _$DestinationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? country = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DestinationInfoImplCopyWith<$Res>
    implements $DestinationInfoCopyWith<$Res> {
  factory _$$DestinationInfoImplCopyWith(_$DestinationInfoImpl value,
          $Res Function(_$DestinationInfoImpl) then) =
      __$$DestinationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String country});
}

/// @nodoc
class __$$DestinationInfoImplCopyWithImpl<$Res>
    extends _$DestinationInfoCopyWithImpl<$Res, _$DestinationInfoImpl>
    implements _$$DestinationInfoImplCopyWith<$Res> {
  __$$DestinationInfoImplCopyWithImpl(
      _$DestinationInfoImpl _value, $Res Function(_$DestinationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? country = null,
  }) {
    return _then(_$DestinationInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DestinationInfoImpl implements _DestinationInfo {
  const _$DestinationInfoImpl(
      {required this.id, required this.name, required this.country});

  factory _$DestinationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DestinationInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String country;

  @override
  String toString() {
    return 'DestinationInfo(id: $id, name: $name, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinationInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, country);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DestinationInfoImplCopyWith<_$DestinationInfoImpl> get copyWith =>
      __$$DestinationInfoImplCopyWithImpl<_$DestinationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DestinationInfoImplToJson(
      this,
    );
  }
}

abstract class _DestinationInfo implements DestinationInfo {
  const factory _DestinationInfo(
      {required final int id,
      required final String name,
      required final String country}) = _$DestinationInfoImpl;

  factory _DestinationInfo.fromJson(Map<String, dynamic> json) =
      _$DestinationInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get country;
  @override
  @JsonKey(ignore: true)
  _$$DestinationInfoImplCopyWith<_$DestinationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
