import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/core/utils/image_mapper.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';

class HotelCard extends StatelessWidget {
  final HotelEntity hotel;
  final VoidCallback? onTap;

  const HotelCard({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Priorité à l'URL fournie par l'API ; fallback déterministe via
    // ImageMapper quand le champ image est vide (cas de la démo).
    final imageUrl =
        (hotel.image != null && hotel.image!.isNotEmpty)
            ? hotel.image!
            : HotelImageMapper.thumbnail(hotel.id, hotel.etoiles);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          color: AppColors.surface,
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Bandeau image ───────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _ImagePlaceholder(),
                    errorWidget: (_, __, ___) => _ImagePlaceholder(),
                  ),
                ),
                // Badge étoiles superposé en haut à droite
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: _StarBadge(stars: hotel.etoiles),
                ),
              ],
            ),

            // ── Infos ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom
                  Text(
                    hotel.nom,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Adresse
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          hotel.adresse,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyHelper.format(hotel.prixNuit),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(
                        ' / nuit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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

// ── Widgets privés ────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 160,
        color: AppColors.shimmerBase,
        child: const Center(
          child: Icon(
            Icons.hotel_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
        ),
      );
}

class _StarBadge extends StatelessWidget {
  final int stars;
  const _StarBadge({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        // Semi-transparent pour ne pas masquer l'image
        color: AppColors.surface.withOpacity(0.90),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: AppColors.secondary,
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}