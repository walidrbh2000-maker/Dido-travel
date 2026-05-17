import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/hotel/hotel_search_provider.dart';
import 'package:voyageur/providers/hotel/hotel_provider.dart';
import 'package:voyageur/screens/hotels/widgets/hotel_search_form.dart';

class HotelsSearchScreen extends ConsumerWidget {
  const HotelsSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Rechercher un hôtel',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Trouvez le séjour parfait pour votre voyage',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              HotelSearchForm(
                onSearch: ({
                  destination,
                  dateDebut,
                  dateFin,
                  chambres,
                  guests,
                }) {
                  ref.read(hotelSearchProvider.notifier).state =
                      HotelSearchParams(
                    destination: destination,
                    dateDebut: dateDebut,
                    dateFin: dateFin,
                    chambres: chambres,
                    guests: guests,
                  );
                  ref.read(hotelsProvider.notifier).search(
                        filters:
                            ref.read(hotelSearchProvider).toQueryParams(),
                      );
                  // push() → l'utilisateur peut revenir à la recherche
                  context.push(AppRoutes.hotelList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
