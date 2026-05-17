import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/hotel_repository.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';

class SearchHotelsUsecase {
  final HotelRepository _repository;

  SearchHotelsUsecase({required HotelRepository repository})
      : _repository = repository;

  Future<Either<AppError, List<HotelEntity>>> call({
    Map<String, dynamic>? filters,
  }) async {
    final result = await _repository.getHotels(filters: filters);
    return result.map((hotels) => hotels.map(_toEntity).toList());
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
