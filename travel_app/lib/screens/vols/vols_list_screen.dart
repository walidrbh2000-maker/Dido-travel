import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/vol/vol_provider.dart';
import 'package:voyageur/screens/vols/widgets/vol_filter_sheet.dart';
import 'package:voyageur/shared_widgets/cards/vol_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/errors/error_widget.dart';
import 'package:voyageur/shared_widgets/shimmer/list_shimmer.dart';

class VolsListScreen extends ConsumerWidget {
  const VolsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volsAsync = ref.watch(volsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de recherche'),
        // Bouton retour automatique vers l'écran de recherche
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.borderRadiusLg),
                  ),
                ),
                builder: (_) => VolFilterSheet(
                  onApply: (filters) {
                    ref.read(volsProvider.notifier).search(filters: filters);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: volsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListShimmer(itemCount: 5),
        ),
        error: (e, _) => AppErrorWidget(
          message: 'Erreur lors du chargement des vols',
          onRetry: () => ref.invalidate(volsProvider),
        ),
        data: (vols) {
          if (vols.isEmpty) {
            return const EmptyStateWidget(
              message: 'Aucun vol trouvé',
              icon: Icons.flight_takeoff,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: vols.length,
            itemBuilder: (context, index) {
              return VolCard(
                vol: vols[index],
                // push() → retour vers la liste possible
                onTap: () => context.push(
                  AppRoutes.volDetailPath(vols[index].id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
