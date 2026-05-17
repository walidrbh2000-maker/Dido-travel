import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/shared_widgets/shimmer/shimmer_wrapper.dart';

class CardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const CardShimmer({
    super.key,
    this.width = 150,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
    );
  }
}
