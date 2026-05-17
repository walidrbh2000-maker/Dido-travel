// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HotelModelImpl _$$HotelModelImplFromJson(Map<String, dynamic> json) =>
    _$HotelModelImpl(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      destinationId: (json['destination_id'] as num).toInt(),
      destination: json['destination'] == null
          ? null
          : DestinationInfo.fromJson(
              json['destination'] as Map<String, dynamic>),
      etoiles: (json['etoiles'] as num?)?.toInt() ?? 3,
      prixNuit: (json['prix_nuit'] as num).toDouble(),
      adresse: json['adresse'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      disponible: json['disponible'] as bool? ?? true,
    );

Map<String, dynamic> _$$HotelModelImplToJson(_$HotelModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'destination_id': instance.destinationId,
      'destination': instance.destination,
      'etoiles': instance.etoiles,
      'prix_nuit': instance.prixNuit,
      'adresse': instance.adresse,
      'description': instance.description,
      'image': instance.image,
      'disponible': instance.disponible,
    };