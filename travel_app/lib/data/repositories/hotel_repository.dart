import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/data/datasources/remote/hotel_remote_datasource.dart';
import 'package:voyageur/data/models/hotel_model.dart';

class HotelRepository {
  final HotelRemoteDatasource _remoteDatasource;

  HotelRepository({required HotelRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<Either<AppError, List<HotelModel>>> getHotels({
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _remoteDatasource.getHotels(queryParameters: filters);
      final List data = response.data['data'] ?? response.data;
      final hotels = data.map((e) => HotelModel.fromJson(e)).toList();
      return Right(hotels);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, HotelModel>> getHotelDetail(int id) async {
    try {
      final response = await _remoteDatasource.getHotelDetail(id);
      final hotel = HotelModel.fromJson(response.data['data'] ?? response.data);
      return Right(hotel);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
