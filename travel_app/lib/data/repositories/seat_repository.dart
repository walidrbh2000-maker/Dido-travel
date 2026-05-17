import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/data/datasources/remote/seat_remote_datasource.dart';
import 'package:voyageur/data/models/seat_model.dart';

class SeatRepository {
  final SeatRemoteDatasource _datasource;

  SeatRepository({required SeatRemoteDatasource datasource})
      : _datasource = datasource;

  Future<Either<AppError, SeatMapResponse>> getSeatMap(int volId) async {
    try {
      final response = await _datasource.getSeatMap(volId);
      return Right(SeatMapResponse.fromJson(
        response.data as Map<String, dynamic>,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, SeatModel>> lockSeat(int volId, int seatId) async {
    try {
      final response = await _datasource.lockSeat(volId, seatId);
      return Right(SeatModel.fromJson(
        response.data['siege'] as Map<String, dynamic>,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, void>> unlockSeat(int volId, int seatId) async {
    try {
      await _datasource.unlockSeat(volId, seatId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}