import 'package:dio/dio.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';

class SeatRemoteDatasource {
  final ApiClient _apiClient;

  SeatRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getSeatMap(int volId) =>
      _apiClient.get(ApiEndpoints.volSeats(volId));

  Future<Response> lockSeat(int volId, int seatId) =>
      _apiClient.post(ApiEndpoints.lockSeat(volId, seatId));

  Future<Response> unlockSeat(int volId, int seatId) =>
      _apiClient.delete(ApiEndpoints.unlockSeat(volId, seatId));
}