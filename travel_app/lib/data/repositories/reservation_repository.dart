import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/data/datasources/remote/reservation_remote_datasource.dart';
import 'package:voyageur/data/models/reservation_model.dart';

class ReservationRepository {
  final ReservationRemoteDatasource _remoteDatasource;

  ReservationRepository({required ReservationRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<Either<AppError, List<ReservationModel>>> getReservations() async {
    try {
      final response = await _remoteDatasource.getReservations();
      final List data = response.data['data'] ?? response.data;
      final reservations = data.map((e) => ReservationModel.fromJson(e)).toList();
      return Right(reservations);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, ReservationModel>> createReservation(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _remoteDatasource.createReservation(data);
      final reservation =
          ReservationModel.fromJson(response.data['data'] ?? response.data['reservation']);
      return Right(reservation);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, ReservationModel>> getReservationDetail(int id) async {
    try {
      final response = await _remoteDatasource.getReservationDetail(id);
      final reservation =
          ReservationModel.fromJson(response.data['data'] ?? response.data);
      return Right(reservation);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, void>> cancelReservation(int id) async {
    try {
      await _remoteDatasource.cancelReservation(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
