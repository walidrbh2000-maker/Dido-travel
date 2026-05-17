import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';
import 'package:voyageur/data/models/destination_model.dart';

class DestinationRepository {
  final ApiClient _apiClient;

  DestinationRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Either<AppError, List<DestinationModel>>> getDestinations() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.destinations);
      final List data = response.data['data'] ?? response.data;
      final destinations = data.map((e) => DestinationModel.fromJson(e)).toList();
      return Right(destinations);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, DestinationModel>> getDestinationDetail(int id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.destinationDetail(id));
      final destination =
          DestinationModel.fromJson(response.data['data'] ?? response.data);
      return Right(destination);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
