import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/providers/vol/vol_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';
import 'package:voyageur/shared_widgets/misc/guest_barrier.dart';

class VolDetailScreen extends ConsumerWidget {
  final int volId;

  const VolDetailScreen({super.key, required this.volId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volAsync = ref.watch(volDetailProvider(volId));

    return volAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: AppLoadingIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (vol) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // ── En-tête dégradé ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xxxl,
                    AppSpacing.xl,
                    AppSpacing.md,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vol.dateDepart
                                .toLocal()
                                .toString()
                                .substring(11, 16),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(Icons.flight,
                              color: Colors.white70, size: 32),
                          Text(
                            vol.dateArrivee
                                .toLocal()
                                .toString()
                                .substring(11, 16),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vol.destinationName ?? 'Départ',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            vol.destinationCountry ?? 'Arrivée',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Corps ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                        icon: Icons.airlines,
                        label: 'Compagnie',
                        value: vol.compagnie),
                    _DetailRow(
                        icon: Icons.confirmation_number,
                        label: 'N° de vol',
                        value: vol.numeroVol),
                    _DetailRow(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value:
                          '${vol.dateDepart.day.toString().padLeft(2, '0')}/'
                          '${vol.dateDepart.month.toString().padLeft(2, '0')}/'
                          '${vol.dateDepart.year}',
                    ),
                    _DetailRow(
                        icon: Icons.airline_seat_recline_normal,
                        label: 'Classe',
                        value: vol.classeLabel),
                    _DetailRow(
                      icon: Icons.people,
                      label: 'Places disponibles',
                      value: '${vol.placesDisponibles}',
                      valueColor: vol.placesDisponibles > 20
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Prix
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Prix par personne',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary),
                          ),
                          Text(
                            CurrencyHelper.format(vol.prix),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Booking button — blocked for guests ────────────────
                    GuestBarrier(
                      reason: 'pour réserver ce vol',
                      child: PrimaryButton(
                        label: vol.placesDisponibles > 0
                            ? 'Réserver maintenant'
                            : 'Complet',
                        icon: vol.placesDisponibles > 0
                            ? Icons.bookmark_add
                            : Icons.block,
                        onPressed: vol.placesDisponibles > 0
                            ? () => context.push(
                                  AppRoutes.bookingTripType,
                                  extra: vol,
                                )
                            : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
