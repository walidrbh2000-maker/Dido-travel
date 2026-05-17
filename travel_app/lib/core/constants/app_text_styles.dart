import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const String displayFamily = 'PlayfairDisplay';
  static const String headingFamily = 'Montserrat';
  static const String bodyFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: headingFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: headingFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: headingFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFF6B7280),
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: headingFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: Color(0xFF6B7280),
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Color(0xFF6B7280),
  );
}
