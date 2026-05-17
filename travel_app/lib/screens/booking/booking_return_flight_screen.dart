import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/providers/booking/booking_provider.dart';
import 'package:voyageur/providers/vol/vol_provider.dart';
import 'package:voyageur/shared_widgets/cards/vol_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/errors/error_widget.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class BookingReturnFlightScreen extends ConsumerWidget {
  const BookingReturnFlightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    if (booking == null) {
      return const Scaffold(
        body: Center(child: Text('Erreur: réservation non initialisée')),
      );
    }

    final volsAsync = ref.watch(volsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Vol Retour')),
      body: Column(
        children: [
          // Bandeau récap du vol aller
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            color: AppColors.primary.withOpacity(0.07),
            child: Row(
              children: [
                const Icon(Icons.flight_takeoff,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Aller : ${booking.outboundFlight.compagnie} '
                    '${booking.outboundFlight.numeroVol} → '
                    '${booking.outboundFlight.destinationName ?? ''}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Choisissez votre vol retour',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          Expanded(
            child: volsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (e, _) => AppErrorWidget(
                message: 'Erreur de chargement des vols',
                onRetry: () => ref.invalidate(volsProvider),
              ),
              data: (vols) {
                // Exclure le vol aller de la liste retour
                final returnVols = vols
                    .where((v) => v.id != booking.outboundFlight.id)
                    .toList();

                if (returnVols.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'Aucun vol retour disponible',
                    icon: Icons.flight_land,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  itemCount: returnVols.length,
                  itemBuilder: (context, index) {
                    final vol = returnVols[index];
                    final isSelected =
                        booking.returnFlight?.id == vol.id;

                    return Stack(
                      children: [
                        VolCard(
                          vol: vol,
                          onTap: () => _selectReturnFlight(
                            context,
                            ref,
                            vol,
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                      ],
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

  void _selectReturnFlight(
    BuildContext context,
    WidgetRef ref,
    VolEntity vol,
  ) {
    ref.read(bookingProvider.notifier).setReturnFlight(vol);
    context.push(AppRoutes.bookingPassengers);
  }
}