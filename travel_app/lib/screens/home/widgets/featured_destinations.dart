import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/data/models/destination_model.dart';
import 'package:voyageur/shared_widgets/cards/destination_card.dart';
import 'package:voyageur/shared_widgets/shimmer/card_shimmer.dart';

class FeaturedDestinations extends StatelessWidget {
  final List<DestinationModel> destinations;
  final bool isLoading;

  const FeaturedDestinations({
    super.key,
    required this.destinations,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Destinations populaires',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextButton(
              // push() → conserve le back stack, le bouton retour apparaît
              onPressed: () => context.push(AppRoutes.destinations),
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: isLoading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (_, __) => const CardShimmer(),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final dest = destinations[index];
                    return DestinationCard(
                      destination: dest,
                      // push() conserve le back stack → le bouton retour
                      // ramène à l'accueil au lieu de fermer l'app.
                      onTap: () => context.push(
                        AppRoutes.destinationDetailPath(dest.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
