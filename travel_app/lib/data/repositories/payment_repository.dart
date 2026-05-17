import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/network/api_endpoints.dart';
import 'package:voyageur/data/models/payment_model.dart';

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Either<AppError, PaymentModel>> processPayment({
    required int reservationId,
    required String methode,
    required String token,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.payments,
        data: {
          'reservation_id': reservationId,
          'methode': methode,
          'token': token,
        },
      );
      final payment =
          PaymentModel.fromJson(response.data['data'] ?? response.data['payment']);
      return Right(payment);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
