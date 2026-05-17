import 'package:dio/dio.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';

class ReservationRemoteDatasource {
  final ApiClient _apiClient;

  ReservationRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<Response> getReservations() {
    return _apiClient.get(ApiEndpoints.reservations);
  }

  Future<Response> createReservation(Map<String, dynamic> data) {
    return _apiClient.post(ApiEndpoints.reservations, data: data);
  }

  Future<Response> getReservationDetail(int id) {
    return _apiClient.get(ApiEndpoints.reservationDetail(id));
  }

  Future<Response> cancelReservation(int id) {
    return _apiClient.delete(ApiEndpoints.reservationDetail(id));
  }

  Future<Response> getTicket(int id) {
    return _apiClient.get(ApiEndpoints.reservationTicket(id));
  }
}
