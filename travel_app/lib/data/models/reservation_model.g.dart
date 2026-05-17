// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationModelImpl _$$ReservationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationModelImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      volId: (json['vol_id'] as num).toInt(),
      hotelId: (json['hotel_id'] as num?)?.toInt(),
      dateDebut: json['date_debut'] as String,
      dateFin: json['date_fin'] as String,
      nombrePersonnes: (json['nombre_personnes'] as num).toInt(),
      prixTotal: (json['prix_total'] as num).toDouble(),
      statut: json['statut'] as String,
      reference: json['reference'] as String,
      createdAt: json['created_at'] as String?,
      vol: json['vol'] == null
          ? null
          : VolModel.fromJson(json['vol'] as Map<String, dynamic>),
      hotel: json['hotel'] == null
          ? null
          : ReservationHotelInfo.fromJson(
              json['hotel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReservationModelImplToJson(
        _$ReservationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'vol_id': instance.volId,
      'hotel_id': instance.hotelId,
      'date_debut': instance.dateDebut,
      'date_fin': instance.dateFin,
      'nombre_personnes': instance.nombrePersonnes,
      'prix_total': instance.prixTotal,
      'statut': instance.statut,
      'reference': instance.reference,
      'created_at': instance.createdAt,
      'vol': instance.vol,
      'hotel': instance.hotel,
    };

_$ReservationHotelInfoImpl _$$ReservationHotelInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationHotelInfoImpl(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      etoiles: (json['etoiles'] as num?)?.toInt() ?? 3,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$ReservationHotelInfoImplToJson(
        _$ReservationHotelInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'etoiles': instance.etoiles,
      'image': instance.image,
    };