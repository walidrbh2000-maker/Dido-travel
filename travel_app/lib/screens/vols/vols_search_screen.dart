import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/vol/vol_provider.dart';
import 'package:voyageur/providers/vol/vol_search_provider.dart';
import 'package:voyageur/screens/vols/widgets/vol_search_form.dart';

class VolsSearchScreen extends ConsumerWidget {
  const VolsSearchScreen({super.key});

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
                'Rechercher un vol',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Trouvez le meilleur vol pour votre prochaine aventure',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              VolSearchForm(
                onSearch: ({destination, dateDepart, passagers}) {
                  ref.read(volSearchProvider.notifier).state = VolSearchParams(
                    destination: destination,
                    dateDepart: dateDepart,
                    passagers: passagers,
                  );
                  ref.read(volsProvider.notifier).search(
                        filters:
                            ref.read(volSearchProvider).toQueryParams(),
                      );
                  // push() → l'utilisateur peut revenir à la recherche
                  context.push(AppRoutes.volList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
