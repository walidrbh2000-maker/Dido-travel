import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/auth/guest_provider.dart';
import 'package:voyageur/providers/reservation/reservation_provider.dart';
import 'package:voyageur/screens/auth/guest_prompt_sheet.dart';
import 'package:voyageur/screens/reservations/widgets/reservation_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/errors/error_widget.dart';
import 'package:voyageur/shared_widgets/shimmer/list_shimmer.dart';

class ReservationsScreen extends ConsumerWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);

    // Guests see a dedicated upsell screen instead of an empty list
    if (isGuest) return const _GuestReservationsView();

    final reservationsAsync = ref.watch(reservationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes réservations')),
      body: reservationsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListShimmer(itemCount: 4),
        ),
        error: (e, _) => AppErrorWidget(
          message: 'Erreur de chargement',
          onRetry: () => ref.invalidate(reservationsProvider),
        ),
        data: (reservations) {
          if (reservations.isEmpty) {
            return EmptyStateWidget(
              message: 'Aucune réservation',
              icon: Icons.bookmark_border,
              actionLabel: 'Réserver un vol',
              onAction: () => context.go(AppRoutes.vols),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(reservationsProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                return ReservationCard(
                  reservation: r,
                  onTap: () => context.push(
                    AppRoutes.reservationDetailPath(r.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Full-screen upsell shown to guest users when they tap the Reservations tab.
class _GuestReservationsView extends StatelessWidget {
  const _GuestReservationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes réservations')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Illustration ─────────────────────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Title ────────────────────────────────────────────────────
              const Text(
                'Vos réservations ici',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Subtitle ─────────────────────────────────────────────────
              const Text(
                'Créez un compte pour réserver des vols, des hôtels et des guides, '
                'et retrouvez toutes vos réservations ici.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── CTA ──────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => GuestPromptSheet.show(
                    context,
                    reason: 'pour accéder à vos réservations',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusMd),
                    ),
                  ),
                  child: const Text(
                    'Se connecter ou s\'inscrire',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Browse CTA ────────────────────────────────────────────────
              TextButton.icon(
                onPressed: () => context.go(AppRoutes.vols),
                icon: const Icon(Icons.flight, size: 16,
                    color: AppColors.primary),
                label: const Text(
                  'Explorer les vols',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
