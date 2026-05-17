import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/data/models/guide_model.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/core/network/api_endpoints.dart';
import 'package:voyageur/screens/guides/widgets/guide_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/errors/error_widget.dart';
import 'package:voyageur/shared_widgets/shimmer/list_shimmer.dart';

final guidesListProvider =
    AsyncNotifierProvider<GuidesListNotifier, List<GuideModel>>(
  GuidesListNotifier.new,
);

class GuidesListNotifier extends AsyncNotifier<List<GuideModel>> {
  @override
  Future<List<GuideModel>> build() async {
    final apiClient = ref.watch(apiClientProvider);
    try {
      final response = await apiClient.get(ApiEndpoints.guides);
      final list = (response.data['data'] ?? response.data) as List;
      return list
          .map((e) => GuideModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final apiClient = ref.read(apiClientProvider);
    try {
      final response = await apiClient.get(ApiEndpoints.guides);
      final list = (response.data['data'] ?? response.data) as List;
      state = AsyncData(
        list
            .map((e) => GuideModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

class GuidesScreen extends ConsumerWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(guidesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Guides locaux')),
      body: guidesAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListShimmer(itemCount: 5),
        ),
        error: (e, _) => AppErrorWidget(
          message: 'Erreur de chargement des guides',
          onRetry: () => ref.invalidate(guidesListProvider),
        ),
        data: (guides) {
          if (guides.isEmpty) {
            return const EmptyStateWidget(
              message: 'Aucun guide disponible',
              icon: Icons.explore,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              return GuideCard(
                id: guide.id,
                nom: guide.nom,
                langues: guide.langues,
                experienceAnnees: guide.experienceAnnees,
                tarifJour: guide.tarifJour,
                image: guide.image,
                // push() → retour vers la liste des guides
                onTap: () => context.push(
                  AppRoutes.guideDetailPath(guide.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
