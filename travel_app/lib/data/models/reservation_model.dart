import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voyageur/data/models/vol_model.dart';

part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

@freezed
class ReservationModel with _$ReservationModel {
  const factory ReservationModel({
    required int id,
    required int userId,
    required int volId,
    int? hotelId,
    required String dateDebut,
    required String dateFin,
    required int nombrePersonnes,
    required double prixTotal,
    required String statut,
    required String reference,
    String? createdAt,
    VolModel? vol,
    ReservationHotelInfo? hotel,
  }) = _ReservationModel;

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}

@freezed
class ReservationHotelInfo with _$ReservationHotelInfo {
  const factory ReservationHotelInfo({
    required int id,
    required String nom,
    @Default(3) int etoiles,
    String? image,
  }) = _ReservationHotelInfo;

  factory ReservationHotelInfo.fromJson(Map<String, dynamic> json) =>
      _$ReservationHotelInfoFromJson(json);
}
