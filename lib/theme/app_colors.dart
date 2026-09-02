import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF8FAF7);
  static const darkBackground = Color(0xFF101715);
  static const darkSurface = Color(0xFF18211E);
  static const darkSoftSurface = Color(0xFF202B27);
  static const darkBorder = Color(0xFF31413B);
  static const darkMutedText = Color(0xFFADB9B4);
  static const surface = Colors.white;
  static const text = Color(0xFF15211E);
  static const mutedText = Color(0xFF64736E);
  static const portalGreen = Color(0xFF45D66B);
  static const successGreen = Color(0xFF43A047);
  static const deadRed = Color(0xFFE53935);
  static const unknownGray = Color(0xFF9EA7A2);
  static const darkButton = Color(0xFF071414);
  static const border = Color(0xFFE0E8E3);
}

extension AppThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get mutedText => isDark ? AppColors.darkMutedText : AppColors.mutedText;
}
