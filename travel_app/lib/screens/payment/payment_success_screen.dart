import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';

/// Écran terminal après un paiement réussi.
/// On utilise volontairement context.go() sur les deux boutons
/// pour vider le back stack : l'utilisateur ne doit pas pouvoir
/// revenir en arrière sur un paiement déjà effectué.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Bloquer le retour physique sur cet écran terminal :
      // un paiement validé ne doit pas être annulé par erreur.
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Paiement réussi !',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Votre réservation a été confirmée. Vous recevrez un e-mail de confirmation avec tous les détails.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                PrimaryButton(
                  label: 'Voir mes réservations',
                  icon: Icons.bookmark,
                  // go() vide le stack → aucun retour possible
                  onPressed: () => context.go(AppRoutes.reservations),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text(
                    "Retour à l'accueil",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
