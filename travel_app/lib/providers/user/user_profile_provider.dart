import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/domain/entities/user_entity.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserEntity?>(() {
  return UserProfileNotifier();
});

class UserProfileNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final authState = ref.watch(authProvider);
    return authState.when(
      initial: () => null,
      loading: () => null,
      authenticated: (user) => user,
      unauthenticated: () => null,
      guest: () => null,        // invité → pas de profil utilisateur
      error: (_) => null,
    );
  }

  Future<void> refresh() async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.getMe();
    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (user) => state = AsyncData(UserEntity(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
      )),
    );
  }
}
