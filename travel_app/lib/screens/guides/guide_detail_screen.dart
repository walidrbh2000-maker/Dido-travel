import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/network/api_endpoints.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/data/models/guide_model.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';
import 'package:voyageur/shared_widgets/misc/guest_barrier.dart';

final guideDetailProvider =
    FutureProvider.family<GuideModel, int>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get(ApiEndpoints.guideDetail(id));
  return GuideModel.fromJson(
    (response.data['data'] ?? response.data) as Map<String, dynamic>,
  );
});

class GuideDetailScreen extends ConsumerWidget {
  final int guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAsync = ref.watch(guideDetailProvider(guideId));

    return guideAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: AppLoadingIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (guide) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // ── SliverAppBar ──────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.shimmerBase,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 4,
                            ),
                          ),
                          child: guide.image != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: guide.image!,
                                    fit: BoxFit.cover,
                                    width: 96,
                                    height: 96,
                                    errorWidget: (_, __, ___) => const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Corps ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 52),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      children: [
                        Text(
                          guide.nom,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "${guide.experienceAnnees} ans d'expérience",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          alignment: WrapAlignment.center,
                          children: guide.langues
                              .map((l) => _LanguageChip(label: l))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'À propos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          guide.description ??
                              'Aucune description disponible.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
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
                                'Tarif journalier',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                CurrencyHelper.format(guide.tarifJour),
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

                        // ── Booking button — blocked for guests ─────────────
                        if (guide.disponible)
                          GuestBarrier(
                            reason: 'pour réserver ce guide',
                            child: PrimaryButton(
                              label: 'Réserver ce guide',
                              icon: Icons.bookmark_add,
                              onPressed: () =>
                                  context.push(AppRoutes.createReservation),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusMd,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_busy,
                                    color: AppColors.error),
                                SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Guide non disponible',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  const _LanguageChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
