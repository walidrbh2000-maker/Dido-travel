import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<AppError, void>> call() => _repository.logout();
}
