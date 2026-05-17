import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class ReservationTimeline extends StatelessWidget {
  final String statut;

  const ReservationTimeline({super.key, required this.statut});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineStep(label: 'Cr\u00e9\u00e9e', isCompleted: true, isActive: statut == 'en_attente'),
      _TimelineStep(label: 'Confirm\u00e9e', isCompleted: statut == 'confirmee' || statut == 'payee', isActive: statut == 'confirmee'),
      _TimelineStep(label: 'Pay\u00e9e', isCompleted: statut == 'payee', isActive: statut == 'payee'),
      _TimelineStep(label: 'Termin\u00e9e', isCompleted: false, isActive: false, isCancelled: statut == 'annulee'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suivi de la r\u00e9servation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildStep(step)),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: step.isCompleted && steps[index + 1].isCompleted
                              ? AppColors.primary
                              : AppColors.shimmerBase,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(_TimelineStep step) {
    if (step.isCancelled) {
      return Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 16, color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Annul\u00e9e',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.error),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: step.isCompleted
                ? AppColors.primary
                : step.isActive
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.shimmerBase,
            shape: BoxShape.circle,
          ),
          child: step.isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : step.isActive
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          step.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: step.isActive ? FontWeight.w600 : FontWeight.w400,
            color: step.isCompleted || step.isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TimelineStep {
  final String label;
  final bool isCompleted;
  final bool isActive;
  final bool isCancelled;

  const _TimelineStep({
    required this.label,
    this.isCompleted = false,
    this.isActive = false,
    this.isCancelled = false,
  });
}
