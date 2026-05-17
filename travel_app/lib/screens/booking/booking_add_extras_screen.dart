import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/data/models/guide_model.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/booking/booking_provider.dart';
import 'package:voyageur/providers/hotel/hotel_provider.dart';
import 'package:voyageur/screens/guides/guides_screen.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/buttons/secondary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class BookingAddExtrasScreen extends ConsumerWidget {
  const BookingAddExtrasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Erreur: réservation non initialisée')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter des services')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personnalisez votre voyage',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Ces services sont optionnels.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Hôtel ────────────────────────────────────────────────────
            _ExtrasCard(
              icon: Icons.hotel,
              title: 'Hôtel',
              subtitle: booking.selectedHotel != null
                  ? booking.selectedHotel!.nom
                  : 'Aucun hôtel sélectionné',
              selected: booking.selectedHotel != null,
              onAdd: () => _showHotelPicker(context, ref),
              onRemove: booking.selectedHotel != null
                  ? () => ref.read(bookingProvider.notifier).setHotel(null)
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Guide ─────────────────────────────────────────────────────
            _ExtrasCard(
              icon: Icons.person_pin,
              title: 'Guide local',
              subtitle: booking.selectedGuide != null
                  ? booking.selectedGuide!.nom
                  : 'Aucun guide sélectionné',
              selected: booking.selectedGuide != null,
              onAdd: () => _showGuidePicker(context, ref),
              onRemove: booking.selectedGuide != null
                  ? () => ref.read(bookingProvider.notifier).setGuide(null)
                  : null,
            ),

            const Spacer(),

            PrimaryButton(
              label: 'Voir le récapitulatif',
              icon: Icons.receipt_long,
              onPressed: () => context.push(AppRoutes.bookingSummary),
            ),
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: 'Passer cette étape',
              onPressed: () => context.push(AppRoutes.bookingSummary),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Future<void> _showHotelPicker(BuildContext context, WidgetRef ref) async {
    final booking = ref.read(bookingProvider);
    if (booking == null) return;

    // Filtrer les hôtels par destination du vol
    ref.read(hotelsProvider.notifier).search(filters: {
      'destination_id': booking.outboundFlight.destinationId,
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
      ),
      builder: (_) => _HotelPickerSheet(
        onSelected: (hotel) {
          ref.read(bookingProvider.notifier).setHotel(hotel);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _showGuidePicker(BuildContext context, WidgetRef ref) async {
    final booking = ref.read(bookingProvider);
    if (booking == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
      ),
      builder: (_) => _GuidePickerSheet(
        destinationId: booking.outboundFlight.destinationId,
        onSelected: (guide) {
          ref.read(bookingProvider.notifier).setGuide(guide);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _ExtrasCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  const _ExtrasCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.shimmerBase,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            child: Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (selected && onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close, color: AppColors.error, size: 20),
            )
          else
            TextButton(
              onPressed: onAdd,
              child: const Text('Ajouter'),
            ),
        ],
      ),
    );
  }
}

// ── Pickers ───────────────────────────────────────────────────────────────────

class _HotelPickerSheet extends ConsumerWidget {
  final ValueChanged<HotelEntity> onSelected;

  const _HotelPickerSheet({required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelsAsync = ref.watch(hotelsProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text('Choisir un hôtel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: hotelsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (e, _) => Center(child: Text('Erreur: $e')),
              data: (hotels) => ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: hotels.length,
                itemBuilder: (_, i) {
                  final h = hotels[i];
                  return ListTile(
                    title: Text(h.nom),
                    subtitle: Text('${h.etoiles}★ • ${h.prixNuit.toStringAsFixed(0)} DA/nuit'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onSelected(h),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidePickerSheet extends ConsumerWidget {
  final int destinationId;
  final ValueChanged<GuideModel> onSelected;

  const _GuidePickerSheet({
    required this.destinationId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(guidesListProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text('Choisir un guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: guidesAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (e, _) => Center(child: Text('Erreur: $e')),
              data: (guides) {
                final filtered = guides.where(
                  (g) => g.destinationId == destinationId && g.disponible,
                ).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Aucun guide disponible pour cette destination'),
                  );
                }

                return ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final g = filtered[i];
                    return ListTile(
                      title: Text(g.nom),
                      subtitle: Text(
                        '${g.experienceAnnees} ans d\'exp. • ${g.tarifJour.toStringAsFixed(0)} DA/jour',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => onSelected(g),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}