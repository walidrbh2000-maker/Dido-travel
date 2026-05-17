import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';

class HotelAmenitiesList extends StatelessWidget {
  final List<String> amenities;

  const HotelAmenitiesList({super.key, required this.amenities});

  static const Map<String, IconData> _amenityIcons = {
    'wifi': Icons.wifi,
    'parking': Icons.local_parking,
    'piscine': Icons.pool,
    'spa': Icons.spa,
    'restaurant': Icons.restaurant,
    'gym': Icons.fitness_center,
    'climatisation': Icons.ac_unit,
    'bar': Icons.local_bar,
    'room_service': Icons.room_service,
    'petit_dejeuner': Icons.free_breakfast,
    'plage': Icons.beach_access,
    'reception_24h': Icons.support_agent,
  };

  IconData _getIcon(String amenity) {
    final key = amenity.toLowerCase().replaceAll(' ', '_');
    return _amenityIcons[key] ?? Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getIcon(amenity), size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                amenity,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
