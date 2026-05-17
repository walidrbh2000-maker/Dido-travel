import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voyageur/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// The user chose to browse without an account.
  /// Grants read-only access to destinations, flights and hotels,
  /// but blocks any write action (booking, reservations, profile).
  const factory AuthState.guest() = AuthGuest;

  const factory AuthState.error(String message) = AuthError;
}
