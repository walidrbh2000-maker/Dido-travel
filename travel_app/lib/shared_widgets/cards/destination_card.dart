import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/data/models/destination_model.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback? onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.borderRadiusLg),
              ),
              child: destination.image != null
                  ? CachedNetworkImage(
                      imageUrl: destination.image!,
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 150,
                        height: 100,
                        color: AppColors.shimmerBase,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 150,
                        height: 100,
                        color: AppColors.shimmerBase,
                        child: const Icon(Icons.image, color: AppColors.textSecondary),
                      ),
                    )
                  : Container(
                      width: 150,
                      height: 100,
                      color: AppColors.shimmerBase,
                      child: const Icon(Icons.place, color: AppColors.accent, size: 32),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    destination.country,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
