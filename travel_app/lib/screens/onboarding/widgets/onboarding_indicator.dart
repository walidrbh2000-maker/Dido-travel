import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';

/// Custom page indicator — replaces smooth_page_indicator to avoid
/// the `translateByDouble` incompatibility with newer vector_math.
class OnboardingIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const OnboardingIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        double currentPage = 0;
        if (controller.hasClients && controller.page != null) {
          currentPage = controller.page!;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            final double distance = (currentPage - index).abs();
            final double width = distance < 1
                ? 8.0 + (1 - distance) * (24.0 - 8.0)
                : 8.0;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: width,
              height: 8,
              decoration: BoxDecoration(
                color: distance < 0.5
                    ? AppColors.primary
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
