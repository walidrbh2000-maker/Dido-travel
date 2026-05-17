import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/auth/auth_state.dart';

/// Returns `true` when the user is browsing in guest mode (not authenticated).
final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthGuest;
});
