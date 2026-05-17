import 'package:dio/dio.dart';
import 'package:voyageur/core/error/app_error.dart';

class ErrorHandler {
  const ErrorHandler._();

  static AppError handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return AppError.unknown(error);
  }

  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppError.network('Délai de connexion dépassé');
      case DioExceptionType.connectionError:
        return const AppError.network('Pas de connexion internet');
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);
      case DioExceptionType.cancel:
        return const AppError.unknown('Requête annulée');
      case DioExceptionType.unknown:
        if (error.error != null && error.error.toString().contains('SocketException')) {
          return const AppError.network('Pas de connexion internet');
        }
        return AppError.unknown(error);
      case DioExceptionType.badCertificate:
        return const AppError.network('Certificat invalide');
    }
  }

  static AppError _handleStatusCode(Response? response) {
    if (response == null) return const AppError.unknown('Réponse vide');

    switch (response.statusCode) {
      case 401:
        return const AppError.unauthorized();
      case 404:
        return AppError.notFound(response.data?['message'] ?? 'Ressource introuvable');
      case 422:
        final errors = <String, List<String>>{};
        final data = response.data;
        if (data is Map && data.containsKey('errors')) {
          final rawErrors = data['errors'] as Map;
          rawErrors.forEach((key, value) {
            errors[key.toString()] = (value as List).map((e) => e.toString()).toList();
          });
        }
        return AppError.validation(errors);
      case 500:
        return const AppError.serverError('Erreur serveur');
      case 503:
        return const AppError.serverError('Service indisponible');
      default:
        return AppError.serverError(
          response.data?['message'] ?? 'Erreur ${response.statusCode}',
        );
    }
  }
}
