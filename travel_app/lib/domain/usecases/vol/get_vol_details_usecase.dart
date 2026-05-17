import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/vol_repository.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';

class GetVolDetailsUsecase {
  final VolRepository _repository;

  GetVolDetailsUsecase({required VolRepository repository})
      : _repository = repository;

  Future<Either<AppError, VolEntity>> call(int id) async {
    final result = await _repository.getVolDetail(id);
    return result.map(_toEntity);
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
