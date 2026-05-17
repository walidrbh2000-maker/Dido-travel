import 'package:freezed_annotation/freezed_annotation.dart';

part 'guide_model.freezed.dart';
part 'guide_model.g.dart';

@freezed
class GuideModel with _$GuideModel {
  const factory GuideModel({
    required int id,
    required String nom,
    required int destinationId,
    required List<String> langues,
    @Default(0) int experienceAnnees,
    required double tarifJour,
    String? description,
    String? image,
    @Default(true) bool disponible,
  }) = _GuideModel;

  factory GuideModel.fromJson(Map<String, dynamic> json) =>
      _$GuideModelFromJson(json);
}
