import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
