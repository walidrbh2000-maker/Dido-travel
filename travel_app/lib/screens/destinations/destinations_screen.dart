import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/destination/destination_provider.dart';
import 'package:voyageur/shared_widgets/cards/destination_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';
import 'package:voyageur/screens/destinations/widgets/destination_filter_bar.dart';

class DestinationsScreen extends ConsumerStatefulWidget {
  const DestinationsScreen({super.key});

  @override
  ConsumerState<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends ConsumerState<DestinationsScreen> {
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinations'),
        // Le bouton retour automatique de Flutter apparaît
        // dès qu'il y a un écran en dessous dans le back stack.
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: DestinationFilterBar(
              selectedCountry: _selectedCountry,
              onCountryChanged: (country) {
                setState(() => _selectedCountry = country);
              },
            ),
          ),
          Expanded(
            child: destinationsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (e, _) => Center(child: Text('Erreur: $e')),
              data: (destinations) {
                if (destinations.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'Aucune destination trouvée',
                    icon: Icons.explore_off,
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final dest = destinations[index];
                    return DestinationCard(
                      destination: dest,
                      // push() → retour vers la liste des destinations
                      onTap: () => context.push(
                        AppRoutes.destinationDetailPath(dest.id),
                      ),
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
