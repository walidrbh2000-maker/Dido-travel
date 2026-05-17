import 'package:dio/dio.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';

class HotelRemoteDatasource {
  final ApiClient _apiClient;

  HotelRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getHotels({Map<String, dynamic>? queryParameters}) {
    return _apiClient.get(ApiEndpoints.hotels, queryParameters: queryParameters);
  }

  Future<Response> getHotelDetail(int id) {
    return _apiClient.get(ApiEndpoints.hotelDetail(id));
  }
}
