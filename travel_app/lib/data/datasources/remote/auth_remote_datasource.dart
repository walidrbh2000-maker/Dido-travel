import 'package:dio/dio.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';

class AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> register(Map<String, dynamic> data) {
    return _apiClient.post(ApiEndpoints.register, data: data);
  }

  Future<Response> login(Map<String, dynamic> data) {
    return _apiClient.post(ApiEndpoints.login, data: data);
  }

  Future<Response> logout() {
    return _apiClient.post(ApiEndpoints.logout);
  }

  Future<Response> me() {
    return _apiClient.get(ApiEndpoints.me);
  }
}
