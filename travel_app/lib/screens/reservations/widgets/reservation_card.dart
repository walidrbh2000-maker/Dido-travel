import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/domain/entities/reservation_entity.dart';

class ReservationCard extends StatelessWidget {
  final ReservationEntity reservation;
  final VoidCallback? onTap;

  const ReservationCard({super.key, required this.reservation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reservation.reference,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _StatusChip(statut: reservation.statut),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${_formatDate(reservation.dateDebut)} - ${_formatDate(reservation.dateFin)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.people, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${reservation.nombrePersonnes} personne(s)',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const Spacer(),
                Text(
                  CurrencyHelper.format(reservation.prixTotal),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String statut;

  const _StatusChip({required this.statut});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getStatusData(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  (Color, String) _getStatusData(String statut) {
    switch (statut) {
      case 'en_attente':
        return (AppColors.secondary, 'En attente');
      case 'confirmee':
        return (AppColors.accent, 'Confirm\u00e9e');
      case 'payee':
        return (AppColors.success, 'Pay\u00e9e');
      case 'annulee':
        return (AppColors.error, 'Annul\u00e9e');
      default:
        return (AppColors.textSecondary, statut);
    }
  }
}
