import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/destination/destination_provider.dart';
import 'package:voyageur/screens/destinations/widgets/destination_info_card.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class DestinationDetailScreen extends ConsumerWidget {
  final int destinationId;

  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationAsync = ref.watch(destinationDetailProvider(destinationId));

    return destinationAsync.when(
      loading: () => const Scaffold(
        body: Center(child: AppLoadingIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (destination) => Scaffold(
        // AppBar avec bouton retour automatique (back stack conservé
        // grâce à context.push dans les écrans appelants)
        appBar: AppBar(
          title: Text(destination.name),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leading est fourni automatiquement par Flutter lorsque
          // la route a été empilée avec context.push()
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (destination.image != null)
                Image.network(
                  destination.image!,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 280,
                    color: AppColors.shimmerBase,
                    child: const Icon(
                      Icons.image,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 280,
                  color: AppColors.shimmerBase,
                  child: const Icon(
                    Icons.place,
                    size: 64,
                    color: AppColors.accent,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DestinationInfoCard(
                      name: destination.name,
                      country: destination.country,
                      description: destination.description,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: 'Explorer les vols',
                      icon: Icons.flight,
                      // push() → l'utilisateur peut revenir au détail
                      onPressed: () => context.push(AppRoutes.vols),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
