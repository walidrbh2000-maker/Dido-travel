import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.when(
      initial: () => '',
      loading: () => '',
      authenticated: (user) => user.name,
      unauthenticated: () => '',
      guest: () => '',          // invité → pas de nom
      error: (_) => '',
    );
    final isGuest = authState.maybeWhen(
      guest: () => true,
      orElse: () => false,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGuest ? 'Bienvenue,' : 'Bon retour,',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              isGuest
                  ? 'Mode invité !'
                  : (userName.isNotEmpty ? '$userName !' : 'Voyageur !'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: isGuest
              ? const Icon(
                  Icons.person_outline,
                  size: 22,
                  color: AppColors.primary,
                )
              : Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'V',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
        ),
      ],
    );
  }
}
