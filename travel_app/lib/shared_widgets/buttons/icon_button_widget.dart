import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = AppSpacing.iconMedium,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.1) ?? AppColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? AppColors.textPrimary, size: size),
      ),
    );
  }
}
