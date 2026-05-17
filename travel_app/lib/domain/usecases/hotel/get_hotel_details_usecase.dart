import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/hotel_repository.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';

class GetHotelDetailsUsecase {
  final HotelRepository _repository;

  GetHotelDetailsUsecase({required HotelRepository repository})
      : _repository = repository;

  Future<Either<AppError, HotelEntity>> call(int id) async {
    final result = await _repository.getHotelDetail(id);
    return result.map(_toEntity);
  }

  HotelEntity _toEntity(dynamic hotel) {
    return HotelEntity(
      id: hotel.id,
      nom: hotel.nom,
      destinationId: hotel.destinationId,
      etoiles: hotel.etoiles,
      prixNuit: hotel.prixNuit,
      adresse: hotel.adresse,
      description: hotel.description,
      image: hotel.image,
      disponible: hotel.disponible,
    );
  }
}
