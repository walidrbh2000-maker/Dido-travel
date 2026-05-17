import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final String? suffix;
  final TextStyle? style;

  const PriceTag({
    super.key,
    required this.price,
    this.suffix,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CurrencyHelper.format(price, symbol: ''),
          style: style ??
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        if (suffix != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text(
              suffix!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
