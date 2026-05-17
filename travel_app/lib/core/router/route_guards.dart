import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/auth/auth_state.dart';

/// Retourne true uniquement si l'utilisateur est authentifié.
/// Les états intermédiaires (initial, loading) retournent false
/// mais le redirect dans app_router.dart les ignore explicitement
/// pour éviter une redirection prématurée vers le login.
final authGuardProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is AuthAuthenticated;
});
