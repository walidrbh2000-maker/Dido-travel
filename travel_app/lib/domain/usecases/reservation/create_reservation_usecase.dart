import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/reservation_repository.dart';
import 'package:voyageur/domain/entities/reservation_entity.dart';

class CreateReservationUsecase {
  final ReservationRepository _repository;

  CreateReservationUsecase({required ReservationRepository repository})
      : _repository = repository;

  Future<Either<AppError, ReservationEntity>> call(
    Map<String, dynamic> data,
  ) async {
    final result = await _repository.createReservation(data);
    return result.map(_toEntity);
  }

  ReservationEntity _toEntity(dynamic r) {
    return ReservationEntity(
      id: r.id,
      userId: r.userId,
      volId: r.volId,
      hotelId: r.hotelId,
      dateDebut: DateTime.parse(r.dateDebut),
      dateFin: DateTime.parse(r.dateFin),
      nombrePersonnes: r.nombrePersonnes,
      prixTotal: r.prixTotal,
      statut: r.statut,
      reference: r.reference,
    );
  }
}
