// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: (json['id'] as num).toInt(),
      reservationId: (json['reservation_id'] as num).toInt(),
      montant: (json['montant'] as num).toDouble(),
      methode: json['methode'] as String,
      stripePaymentId: json['stripe_payment_id'] as String?,
      statut: json['statut'] as String? ?? 'pending',
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reservation_id': instance.reservationId,
      'montant': instance.montant,
      'methode': instance.methode,
      'stripe_payment_id': instance.stripePaymentId,
      'statut': instance.statut,
      'created_at': instance.createdAt,
    };