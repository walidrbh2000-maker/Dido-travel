import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/shared_widgets/cards/vol_card.dart';
import 'package:voyageur/shared_widgets/shimmer/list_shimmer.dart';

class PopularVols extends StatelessWidget {
  final List<VolEntity> vols;
  final bool isLoading;

  const PopularVols({
    super.key,
    required this.vols,
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
              'Vols pas chers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextButton(
              // go() pour naviguer vers l'onglet Vols
              onPressed: () => context.go(AppRoutes.vols),
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        isLoading
            ? const ListShimmer(itemCount: 3)
            : Column(
                children: vols.take(3).map((vol) {
                  return VolCard(
                    vol: vol,
                    // push() → retour possible vers l'accueil
                    onTap: () => context.push(AppRoutes.volDetailPath(vol.id)),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
