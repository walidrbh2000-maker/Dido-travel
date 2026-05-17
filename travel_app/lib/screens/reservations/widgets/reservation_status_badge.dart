import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class ReservationStatusBadge extends StatelessWidget {
  final String statut;
  final double size;

  const ReservationStatusBadge({
    super.key,
    required this.statut,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = _getData(statut);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, IconData) _getData(String statut) {
    switch (statut) {
      case 'en_attente':
        return (AppColors.secondary, 'En attente', Icons.schedule);
      case 'confirmee':
        return (AppColors.accent, 'Confirm\u00e9e', Icons.check_circle_outline);
      case 'payee':
        return (AppColors.success, 'Pay\u00e9e', Icons.paid);
      case 'annulee':
        return (AppColors.error, 'Annul\u00e9e', Icons.cancel_outlined);
      default:
        return (AppColors.textSecondary, statut, Icons.help_outline);
    }
  }
}
