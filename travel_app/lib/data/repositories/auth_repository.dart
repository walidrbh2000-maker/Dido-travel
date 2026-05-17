import 'package:dartz/dartz.dart';
import 'package:voyageur/core/error/app_error.dart';
import 'package:voyageur/core/error/error_handler.dart';
import 'package:voyageur/core/storage/secure_storage.dart';
import 'package:voyageur/data/datasources/remote/auth_remote_datasource.dart';
import 'package:voyageur/data/models/user_model.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SecureStorage _secureStorage;

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
    required SecureStorage secureStorage,
  })  : _remoteDatasource = remoteDatasource,
        _secureStorage = secureStorage;

  Future<Either<AppError, Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _remoteDatasource.register({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone,
      });

      final data = response.data;
      await _secureStorage.saveToken(data['token']);
      final user = UserModel.fromJson(data['user']);
      return Right({'user': user, 'token': data['token']});
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDatasource.login({
        'email': email,
        'password': password,
      });

      final data = response.data;
      await _secureStorage.saveToken(data['token']);
      final user = UserModel.fromJson(data['user']);
      return Right({'user': user, 'token': data['token']});
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, void>> logout() async {
    try {
      await _remoteDatasource.logout();
      await _secureStorage.deleteToken();
      return const Right(null);
    } catch (e) {
      await _secureStorage.deleteToken();
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<AppError, UserModel>> getMe() async {
    try {
      final response = await _remoteDatasource.me();
      final user = UserModel.fromJson(response.data);
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<bool> isAuthenticated() => _secureStorage.hasToken();
}
