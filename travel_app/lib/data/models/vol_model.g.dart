// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vol_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VolModelImpl _$$VolModelImplFromJson(Map<String, dynamic> json) =>
    _$VolModelImpl(
      id: (json['id'] as num).toInt(),
      compagnie: json['compagnie'] as String,
      numeroVol: json['numero_vol'] as String,
      destinationId: json['destination'] != null
          ? ((json['destination'] as Map<String, dynamic>)['id'] as num?)
                  ?.toInt() ??
              0
          : (json['destination_id'] as num?)?.toInt() ?? 0,
      destination: json['destination'] == null
          ? null
          : DestinationInfo.fromJson(
              json['destination'] as Map<String, dynamic>),
      dateDepart: json['date_depart'] as String,
      dateArrivee: json['date_arrivee'] as String,
      prix: (json['prix'] as num).toDouble(),
      placesDisponibles: (json['places_disponibles'] as num).toInt(),
      classe: json['classe'] as String? ?? 'economique',
      statut: json['statut'] as String? ?? 'programme',
    );

Map<String, dynamic> _$$VolModelImplToJson(_$VolModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'compagnie': instance.compagnie,
      'numero_vol': instance.numeroVol,
      'destination_id': instance.destinationId,
      'destination': instance.destination,
      'date_depart': instance.dateDepart,
      'date_arrivee': instance.dateArrivee,
      'prix': instance.prix,
      'places_disponibles': instance.placesDisponibles,
      'classe': instance.classe,
      'statut': instance.statut,
    };

_$DestinationInfoImpl _$$DestinationInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$DestinationInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$$DestinationInfoImplToJson(
        _$DestinationInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
    };