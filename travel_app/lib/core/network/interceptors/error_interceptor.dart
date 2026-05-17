import 'package:dio/dio.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/core/utils/app_logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appError = ErrorHandler.handle(err);
    AppLogger.error(
      'API Error: ${err.requestOptions.path}',
      appError,
    );
    handler.next(err);
  }
}
