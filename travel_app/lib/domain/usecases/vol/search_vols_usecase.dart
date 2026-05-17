import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/vol_repository.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';

class SearchVolsUsecase {
  final VolRepository _repository;

  SearchVolsUsecase({required VolRepository repository}) : _repository = repository;

  Future<Either<AppError, List<VolEntity>>> call({
    Map<String, dynamic>? filters,
  }) async {
    final result = await _repository.getVols(filters: filters);
    return result.map((vols) => vols.map(_toEntity).toList());
  }

  VolEntity _toEntity(dynamic vol) {
    return VolEntity(
      id: vol.id,
      compagnie: vol.compagnie,
      numeroVol: vol.numeroVol,
      destinationId: vol.destinationId,
      destinationName: vol.destination?.name,
      destinationCountry: vol.destination?.country,
      dateDepart: DateTime.parse(vol.dateDepart),
      dateArrivee: DateTime.parse(vol.dateArrivee),
      prix: vol.prix,
      placesDisponibles: vol.placesDisponibles,
      classe: vol.classe,
      statut: vol.statut,
    );
  }
}
