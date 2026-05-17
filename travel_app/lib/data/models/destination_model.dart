import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_model.freezed.dart';
part 'destination_model.g.dart';

@freezed
class DestinationModel with _$DestinationModel {
  const factory DestinationModel({
    required int id,
    required String name,
    required String country,
    String? description,
    String? image,
    @Default(false) bool isPopular,
  }) = _DestinationModel;

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      _$DestinationModelFromJson(json);
}
