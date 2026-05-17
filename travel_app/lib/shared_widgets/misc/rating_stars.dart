import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: size,
          color: index < rating
              ? (activeColor ?? AppColors.secondary)
              : (inactiveColor ?? AppColors.textSecondary),
        );
      }),
    );
  }
}
