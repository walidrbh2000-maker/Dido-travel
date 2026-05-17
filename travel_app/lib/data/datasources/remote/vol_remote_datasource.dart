import 'package:dio/dio.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';

class VolRemoteDatasource {
  final ApiClient _apiClient;

  VolRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getVols({Map<String, dynamic>? queryParameters}) {
    return _apiClient.get(ApiEndpoints.vols, queryParameters: queryParameters);
  }

  Future<Response> getVolDetail(int id) {
    return _apiClient.get(ApiEndpoints.volDetail(id));
  }
}
