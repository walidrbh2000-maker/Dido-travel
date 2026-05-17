import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/auth/guest_provider.dart';
import 'package:voyageur/providers/user/user_profile_provider.dart';
import 'package:voyageur/screens/auth/guest_prompt_sheet.dart';
import 'package:voyageur/screens/profile/widgets/language_selector.dart';
import 'package:voyageur/screens/profile/widgets/profile_header.dart';
import 'package:voyageur/screens/profile/widgets/settings_tile.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);

    if (isGuest) return const _GuestProfileView();

    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: userAsync.when(
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) =>
            const Center(child: Text('Erreur de chargement')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Non connecté'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  name: user.name,
                  email: user.email,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.person_outline,
                        title: 'Modifier le profil',
                        subtitle: 'Nom, email, téléphone',
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                      SettingsTile(
                        icon: Icons.bookmark_outline,
                        title: 'Mes réservations',
                        subtitle: 'Historique et suivi',
                        onTap: () => context.go(AppRoutes.reservations),
                      ),
                      const SettingsTile(
                        icon: Icons.payment_outlined,
                        title: 'Moyens de paiement',
                        subtitle: 'Cartes et portefeuilles',
                      ),
                      const SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Alertes et rappels',
                      ),
                      const SettingsTile(
                        icon: Icons.shield_outlined,
                        title: 'Confidentialité',
                        subtitle: 'Données et sécurité',
                      ),
                      const SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Aide et support',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const LanguageSelector(),
                      const SizedBox(height: AppSpacing.lg),
                      SettingsTile(
                        icon: Icons.logout,
                        title: 'Déconnexion',
                        iconColor: AppColors.error,
                        onTap: () async {
                          await ref
                              .read(authProvider.notifier)
                              .logout();
                          if (context.mounted) {
                            context.go(AppRoutes.login);
                          }
                        },
                        trailing: const SizedBox.shrink(),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Vue invité ────────────────────────────────────────────────────────────────

class _GuestProfileView extends ConsumerWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── En-tête invité ────────────────────────────────────────────
            _GuestProfileHeader(),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  // ── Carte d'invitation ───────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusLg),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Rejoignez Voyageur',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text(
                          'Créez un compte pour profiter de toutes les fonctionnalités '
                          'et retrouver vos réservations à tout moment.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Avantages
                        _BenefitRow(
                          icon: Icons.flight,
                          text: 'Réservez des vols en quelques clics',
                        ),
                        _BenefitRow(
                          icon: Icons.hotel,
                          text: 'Gérez vos hôtels et séjours',
                        ),
                        _BenefitRow(
                          icon: Icons.receipt_long,
                          text: 'Suivez toutes vos réservations',
                        ),
                        _BenefitRow(
                          icon: Icons.notifications_active,
                          text: 'Recevez des alertes de prix',
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Bouton connexion
                        SizedBox(
                          width: double.infinity,
                          height: AppSpacing.buttonHeight,
                          child: ElevatedButton(
                            onPressed: () => GuestPromptSheet.show(
                              context,
                              reason: 'pour accéder à votre profil',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.borderRadiusMd),
                              ),
                            ),
                            child: const Text(
                              'Se connecter',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Bouton inscription
                        SizedBox(
                          width: double.infinity,
                          height: AppSpacing.buttonHeight,
                          child: OutlinedButton(
                            onPressed: () {
                              ref
                                  .read(authProvider.notifier)
                                  .exitGuestMode();
                              context.go(AppRoutes.register);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.borderRadiusMd),
                              ),
                            ),
                            child: const Text(
                              'Créer un compte',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Langue toujours accessible ────────────────────────────
                  const LanguageSelector(),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Aide ──────────────────────────────────────────────────
                  const SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Aide et support',
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── En-tête invité ────────────────────────────────────────────────────────────

class _GuestProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.borderRadiusXl),
          bottomRight: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Avatar anonyme
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Mode invité',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius:
                    BorderRadius.circular(AppSpacing.borderRadiusFull),
              ),
              child: const Text(
                'Exploration en lecture seule',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avantage ──────────────────────────────────────────────────────────────────

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.success),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
