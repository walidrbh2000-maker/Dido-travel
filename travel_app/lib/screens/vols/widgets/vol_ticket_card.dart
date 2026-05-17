import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';

class VolTicketCard extends StatelessWidget {
  final VolEntity vol;
  final VoidCallback? onTap;

  const VolTicketCard({super.key, required this.vol, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vol.compagnie, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                    ),
                    child: Text(vol.classeLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(child: Column(children: [
                    Text(vol.dateDepart.toLocal().toString().substring(11, 16), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Text(vol.destinationName ?? '---', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                  ])),
                  const Expanded(child: Row(children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.flight, color: AppColors.primary, size: 18)),
                    Expanded(child: Divider(thickness: 1)),
                  ])),
                  Expanded(child: Column(children: [
                    Text(vol.dateArrivee.toLocal().toString().substring(11, 16), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Text(vol.destinationCountry ?? '---', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                  ])),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${vol.placesDisponibles} places', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text(CurrencyHelper.format(vol.prix), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
