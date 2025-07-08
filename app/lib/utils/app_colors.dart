import 'package:flutter/material.dart';

class AppColors {
  // Primary purple gradient colors
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryPurpleLight = Color(0xFF9B8CE8);
  static const Color primaryPurpleDark = Color(0xFF5A4FCF);

  // Background colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textHint = Color(0xFFA0AEC0);

  // Input field colors
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputFocus = Color(0xFF6C5CE7);
  static const Color inputFill = Color(0xFFF7FAFC);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryPurpleLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFE2E1FF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient decorativeGradient = LinearGradient(
    colors: [Color(0xFFB19CD9), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
