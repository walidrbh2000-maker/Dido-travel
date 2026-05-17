import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/data/repositories/auth_repository.dart';
import 'package:voyageur/domain/entities/user_entity.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<AppError, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    final result = await _repository.login(email: email, password: password);
    return result.map((data) => _toEntity(data['user'] as dynamic));
  }

  UserEntity _toEntity(dynamic user) {
    return UserEntity(
      id: user.id as int,
      name: user.name as String,
      email: user.email as String,
      phone: user.phone as String?,
      role: user.role as String,
    );
  }
}
