// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DestinationModelImpl _$$DestinationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DestinationModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      country: json['country'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      isPopular: json['is_popular'] as bool? ?? false,
    );

Map<String, dynamic> _$$DestinationModelImplToJson(
        _$DestinationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'description': instance.description,
      'image': instance.image,
      'is_popular': instance.isPopular,
    };