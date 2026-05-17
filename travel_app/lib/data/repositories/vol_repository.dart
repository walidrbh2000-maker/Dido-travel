import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/data/datasources/remote/vol_remote_datasource.dart';
import 'package:voyageur/data/models/vol_model.dart';

class VolRepository {
  final VolRemoteDatasource _remoteDatasource;

  VolRepository({required VolRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<Either<AppError, List<VolModel>>> getVols({
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _remoteDatasource.getVols(queryParameters: filters);
      final List data = response.data['data'] ?? response.data;
      final vols = data.map((e) => VolModel.fromJson(e)).toList();
      return Right(vols);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, VolModel>> getVolDetail(int id) async {
    try {
      final response = await _remoteDatasource.getVolDetail(id);
      final vol = VolModel.fromJson(response.data['data'] ?? response.data);
      return Right(vol);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
