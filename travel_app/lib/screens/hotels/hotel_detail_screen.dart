import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/providers/hotel/hotel_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';
import 'package:voyageur/shared_widgets/misc/rating_stars.dart';
import 'package:voyageur/shared_widgets/misc/guest_barrier.dart';

class HotelDetailScreen extends ConsumerWidget {
  final int hotelId;

  const HotelDetailScreen({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelAsync = ref.watch(hotelDetailProvider(hotelId));

    return hotelAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: AppLoadingIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (hotel) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // ── SliverAppBar avec image ────────────────────────────────────
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppColors.surface,
              flexibleSpace: FlexibleSpaceBar(
                background: hotel.image != null
                    ? CachedNetworkImage(
                        imageUrl: hotel.image!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: AppColors.shimmerBase),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.shimmerBase,
                          child: const Icon(
                            Icons.hotel,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.shimmerBase,
                        child: const Icon(
                          Icons.hotel,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),

            // ── Contenu ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hotel.nom,
                            style: const TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        RatingStars(rating: hotel.etoiles),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            hotel.adresse,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (hotel.description != null) ...[
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        hotel.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    _InfoRow(
                      icon: Icons.star,
                      label: 'Étoiles',
                      value: '${hotel.etoiles} étoiles',
                    ),
                    _InfoRow(
                      icon: Icons.attach_money,
                      label: 'Prix par nuit',
                      value: CurrencyHelper.format(hotel.prixNuit),
                    ),
                    _InfoRow(
                      icon: Icons.check_circle,
                      label: 'Disponibilité',
                      value: hotel.disponible ? 'Disponible' : 'Indisponible',
                      valueColor: hotel.disponible
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusMd,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Prix par nuit',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            CurrencyHelper.format(hotel.prixNuit),
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
                      reason: 'pour réserver cet hôtel',
                      child: PrimaryButton(
                        label: 'Réserver cet hôtel',
                        icon: Icons.bookmark_add,
                        onPressed: () =>
                            context.push(AppRoutes.createReservation),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
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
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
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
