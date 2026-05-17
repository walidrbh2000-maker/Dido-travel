// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) {
  return _ReservationModel.fromJson(json);
}

/// @nodoc
mixin _$ReservationModel {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  int get volId => throw _privateConstructorUsedError;
  int? get hotelId => throw _privateConstructorUsedError;
  String get dateDebut => throw _privateConstructorUsedError;
  String get dateFin => throw _privateConstructorUsedError;
  int get nombrePersonnes => throw _privateConstructorUsedError;
  double get prixTotal => throw _privateConstructorUsedError;
  String get statut => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  VolModel? get vol => throw _privateConstructorUsedError;
  ReservationHotelInfo? get hotel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReservationModelCopyWith<ReservationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationModelCopyWith<$Res> {
  factory $ReservationModelCopyWith(
          ReservationModel value, $Res Function(ReservationModel) then) =
      _$ReservationModelCopyWithImpl<$Res, ReservationModel>;
  @useResult
  $Res call(
      {int id,
      int userId,
      int volId,
      int? hotelId,
      String dateDebut,
      String dateFin,
      int nombrePersonnes,
      double prixTotal,
      String statut,
      String reference,
      String? createdAt,
      VolModel? vol,
      ReservationHotelInfo? hotel});

  $VolModelCopyWith<$Res>? get vol;
  $ReservationHotelInfoCopyWith<$Res>? get hotel;
}

/// @nodoc
class _$ReservationModelCopyWithImpl<$Res, $Val extends ReservationModel>
    implements $ReservationModelCopyWith<$Res> {
  _$ReservationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? volId = null,
    Object? hotelId = freezed,
    Object? dateDebut = null,
    Object? dateFin = null,
    Object? nombrePersonnes = null,
    Object? prixTotal = null,
    Object? statut = null,
    Object? reference = null,
    Object? createdAt = freezed,
    Object? vol = freezed,
    Object? hotel = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      volId: null == volId
          ? _value.volId
          : volId // ignore: cast_nullable_to_non_nullable
              as int,
      hotelId: freezed == hotelId
          ? _value.hotelId
          : hotelId // ignore: cast_nullable_to_non_nullable
              as int?,
      dateDebut: null == dateDebut
          ? _value.dateDebut
          : dateDebut // ignore: cast_nullable_to_non_nullable
              as String,
      dateFin: null == dateFin
          ? _value.dateFin
          : dateFin // ignore: cast_nullable_to_non_nullable
              as String,
      nombrePersonnes: null == nombrePersonnes
          ? _value.nombrePersonnes
          : nombrePersonnes // ignore: cast_nullable_to_non_nullable
              as int,
      prixTotal: null == prixTotal
          ? _value.prixTotal
          : prixTotal // ignore: cast_nullable_to_non_nullable
              as double,
      statut: null == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      vol: freezed == vol
          ? _value.vol
          : vol // ignore: cast_nullable_to_non_nullable
              as VolModel?,
      hotel: freezed == hotel
          ? _value.hotel
          : hotel // ignore: cast_nullable_to_non_nullable
              as ReservationHotelInfo?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VolModelCopyWith<$Res>? get vol {
    if (_value.vol == null) {
      return null;
    }

    return $VolModelCopyWith<$Res>(_value.vol!, (value) {
      return _then(_value.copyWith(vol: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReservationHotelInfoCopyWith<$Res>? get hotel {
    if (_value.hotel == null) {
      return null;
    }

    return $ReservationHotelInfoCopyWith<$Res>(_value.hotel!, (value) {
      return _then(_value.copyWith(hotel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReservationModelImplCopyWith<$Res>
    implements $ReservationModelCopyWith<$Res> {
  factory _$$ReservationModelImplCopyWith(_$ReservationModelImpl value,
          $Res Function(_$ReservationModelImpl) then) =
      __$$ReservationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int userId,
      int volId,
      int? hotelId,
      String dateDebut,
      String dateFin,
      int nombrePersonnes,
      double prixTotal,
      String statut,
      String reference,
      String? createdAt,
      VolModel? vol,
      ReservationHotelInfo? hotel});

  @override
  $VolModelCopyWith<$Res>? get vol;
  @override
  $ReservationHotelInfoCopyWith<$Res>? get hotel;
}

/// @nodoc
class __$$ReservationModelImplCopyWithImpl<$Res>
    extends _$ReservationModelCopyWithImpl<$Res, _$ReservationModelImpl>
    implements _$$ReservationModelImplCopyWith<$Res> {
  __$$ReservationModelImplCopyWithImpl(_$ReservationModelImpl _value,
      $Res Function(_$ReservationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? volId = null,
    Object? hotelId = freezed,
    Object? dateDebut = null,
    Object? dateFin = null,
    Object? nombrePersonnes = null,
    Object? prixTotal = null,
    Object? statut = null,
    Object? reference = null,
    Object? createdAt = freezed,
    Object? vol = freezed,
    Object? hotel = freezed,
  }) {
    return _then(_$ReservationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      volId: null == volId
          ? _value.volId
          : volId // ignore: cast_nullable_to_non_nullable
              as int,
      hotelId: freezed == hotelId
          ? _value.hotelId
          : hotelId // ignore: cast_nullable_to_non_nullable
              as int?,
      dateDebut: null == dateDebut
          ? _value.dateDebut
          : dateDebut // ignore: cast_nullable_to_non_nullable
              as String,
      dateFin: null == dateFin
          ? _value.dateFin
          : dateFin // ignore: cast_nullable_to_non_nullable
              as String,
      nombrePersonnes: null == nombrePersonnes
          ? _value.nombrePersonnes
          : nombrePersonnes // ignore: cast_nullable_to_non_nullable
              as int,
      prixTotal: null == prixTotal
          ? _value.prixTotal
          : prixTotal // ignore: cast_nullable_to_non_nullable
              as double,
      statut: null == statut
          ? _value.statut
          : statut // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      vol: freezed == vol
          ? _value.vol
          : vol // ignore: cast_nullable_to_non_nullable
              as VolModel?,
      hotel: freezed == hotel
          ? _value.hotel
          : hotel // ignore: cast_nullable_to_non_nullable
              as ReservationHotelInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationModelImpl implements _ReservationModel {
  const _$ReservationModelImpl(
      {required this.id,
      required this.userId,
      required this.volId,
      this.hotelId,
      required this.dateDebut,
      required this.dateFin,
      required this.nombrePersonnes,
      required this.prixTotal,
      required this.statut,
      required this.reference,
      this.createdAt,
      this.vol,
      this.hotel});

  factory _$ReservationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationModelImplFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final int volId;
  @override
  final int? hotelId;
  @override
  final String dateDebut;
  @override
  final String dateFin;
  @override
  final int nombrePersonnes;
  @override
  final double prixTotal;
  @override
  final String statut;
  @override
  final String reference;
  @override
  final String? createdAt;
  @override
  final VolModel? vol;
  @override
  final ReservationHotelInfo? hotel;

  @override
  String toString() {
    return 'ReservationModel(id: $id, userId: $userId, volId: $volId, hotelId: $hotelId, dateDebut: $dateDebut, dateFin: $dateFin, nombrePersonnes: $nombrePersonnes, prixTotal: $prixTotal, statut: $statut, reference: $reference, createdAt: $createdAt, vol: $vol, hotel: $hotel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.volId, volId) || other.volId == volId) &&
            (identical(other.hotelId, hotelId) || other.hotelId == hotelId) &&
            (identical(other.dateDebut, dateDebut) ||
                other.dateDebut == dateDebut) &&
            (identical(other.dateFin, dateFin) || other.dateFin == dateFin) &&
            (identical(other.nombrePersonnes, nombrePersonnes) ||
                other.nombrePersonnes == nombrePersonnes) &&
            (identical(other.prixTotal, prixTotal) ||
                other.prixTotal == prixTotal) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.vol, vol) || other.vol == vol) &&
            (identical(other.hotel, hotel) || other.hotel == hotel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      volId,
      hotelId,
      dateDebut,
      dateFin,
      nombrePersonnes,
      prixTotal,
      statut,
      reference,
      createdAt,
      vol,
      hotel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationModelImplCopyWith<_$ReservationModelImpl> get copyWith =>
      __$$ReservationModelImplCopyWithImpl<_$ReservationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationModelImplToJson(
      this,
    );
  }
}

abstract class _ReservationModel implements ReservationModel {
  const factory _ReservationModel(
      {required final int id,
      required final int userId,
      required final int volId,
      final int? hotelId,
      required final String dateDebut,
      required final String dateFin,
      required final int nombrePersonnes,
      required final double prixTotal,
      required final String statut,
      required final String reference,
      final String? createdAt,
      final VolModel? vol,
      final ReservationHotelInfo? hotel}) = _$ReservationModelImpl;

  factory _ReservationModel.fromJson(Map<String, dynamic> json) =
      _$ReservationModelImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  int get volId;
  @override
  int? get hotelId;
  @override
  String get dateDebut;
  @override
  String get dateFin;
  @override
  int get nombrePersonnes;
  @override
  double get prixTotal;
  @override
  String get statut;
  @override
  String get reference;
  @override
  String? get createdAt;
  @override
  VolModel? get vol;
  @override
  ReservationHotelInfo? get hotel;
  @override
  @JsonKey(ignore: true)
  _$$ReservationModelImplCopyWith<_$ReservationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReservationHotelInfo _$ReservationHotelInfoFromJson(Map<String, dynamic> json) {
  return _ReservationHotelInfo.fromJson(json);
}

/// @nodoc
mixin _$ReservationHotelInfo {
  int get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  int get etoiles => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReservationHotelInfoCopyWith<ReservationHotelInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationHotelInfoCopyWith<$Res> {
  factory $ReservationHotelInfoCopyWith(ReservationHotelInfo value,
          $Res Function(ReservationHotelInfo) then) =
      _$ReservationHotelInfoCopyWithImpl<$Res, ReservationHotelInfo>;
  @useResult
  $Res call({int id, String nom, int etoiles, String? image});
}

/// @nodoc
class _$ReservationHotelInfoCopyWithImpl<$Res,
        $Val extends ReservationHotelInfo>
    implements $ReservationHotelInfoCopyWith<$Res> {
  _$ReservationHotelInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? etoiles = null,
    Object? image = freezed,
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
      etoiles: null == etoiles
          ? _value.etoiles
          : etoiles // ignore: cast_nullable_to_non_nullable
              as int,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationHotelInfoImplCopyWith<$Res>
    implements $ReservationHotelInfoCopyWith<$Res> {
  factory _$$ReservationHotelInfoImplCopyWith(_$ReservationHotelInfoImpl value,
          $Res Function(_$ReservationHotelInfoImpl) then) =
      __$$ReservationHotelInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nom, int etoiles, String? image});
}

/// @nodoc
class __$$ReservationHotelInfoImplCopyWithImpl<$Res>
    extends _$ReservationHotelInfoCopyWithImpl<$Res, _$ReservationHotelInfoImpl>
    implements _$$ReservationHotelInfoImplCopyWith<$Res> {
  __$$ReservationHotelInfoImplCopyWithImpl(_$ReservationHotelInfoImpl _value,
      $Res Function(_$ReservationHotelInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? etoiles = null,
    Object? image = freezed,
  }) {
    return _then(_$ReservationHotelInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      etoiles: null == etoiles
          ? _value.etoiles
          : etoiles // ignore: cast_nullable_to_non_nullable
              as int,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationHotelInfoImpl implements _ReservationHotelInfo {
  const _$ReservationHotelInfoImpl(
      {required this.id, required this.nom, this.etoiles = 3, this.image});

  factory _$ReservationHotelInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationHotelInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String nom;
  @override
  @JsonKey()
  final int etoiles;
  @override
  final String? image;

  @override
  String toString() {
    return 'ReservationHotelInfo(id: $id, nom: $nom, etoiles: $etoiles, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationHotelInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.etoiles, etoiles) || other.etoiles == etoiles) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, nom, etoiles, image);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationHotelInfoImplCopyWith<_$ReservationHotelInfoImpl>
      get copyWith =>
          __$$ReservationHotelInfoImplCopyWithImpl<_$ReservationHotelInfoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationHotelInfoImplToJson(
      this,
    );
  }
}

abstract class _ReservationHotelInfo implements ReservationHotelInfo {
  const factory _ReservationHotelInfo(
      {required final int id,
      required final String nom,
      final int etoiles,
      final String? image}) = _$ReservationHotelInfoImpl;

  factory _ReservationHotelInfo.fromJson(Map<String, dynamic> json) =
      _$ReservationHotelInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get nom;
  @override
  int get etoiles;
  @override
  String? get image;
  @override
  @JsonKey(ignore: true)
  _$$ReservationHotelInfoImplCopyWith<_$ReservationHotelInfoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
