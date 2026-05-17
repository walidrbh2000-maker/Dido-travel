import 'package:freezed_annotation/freezed_annotation.dart';
// FIX: DestinationInfo is defined in vol_model.dart — import was missing.
import 'package:voyageur/data/models/vol_model.dart';

part 'hotel_model.freezed.dart';
part 'hotel_model.g.dart';

@freezed
class HotelModel with _$HotelModel {
  const factory HotelModel({
    required int id,
    required String nom,
    required int destinationId,
    DestinationInfo? destination,
    @Default(3) int etoiles,
    required double prixNuit,
    required String adresse,
    String? description,
    String? image,
    @Default(true) bool disponible,
  }) = _HotelModel;

  factory HotelModel.fromJson(Map<String, dynamic> json) =>
      _$HotelModelFromJson(json);
}
