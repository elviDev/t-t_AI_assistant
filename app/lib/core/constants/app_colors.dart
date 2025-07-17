import 'package:flutter/material.dart';

/// Application color constants following Material Design 3 principles
/// Contains all color definitions used throughout the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary brand colors - Updated to match Figma design
  static const Color primary = Color(0xFF3933C6);
  static const Color primaryColor = primary; // Alias for compatibility
  static const Color primaryDark = Color(0xFF2A1F99);
  static const Color secondary = Color(0xFFA05FFF);
  static const Color accent = Color(0xFF06B6D4);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color successColor = success; // Alias for compatibility
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningColor = warning; // Alias for compatibility
  static const Color error = Color(0xFFF87171);
  static const Color errorColor = error; // Alias for compatibility
  static const Color info = Color(0xFF3B82F6);
  static const Color secondaryColor = secondary; // Alias for compatibility

  // Light theme colors
  static const Color lightBackground = Color(0xF8F5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightText = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0x9E9E9E9E);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1F1F1F);
  static const Color darkCard = Color(0xFF1F1F1F);
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkText = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Gradient definitions - Updated to match Figma design
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3933C6), Color(0xFFA05FFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0], // Left to right 100%
  );

  // Additional gradient styles for specific use cases
  static const LinearGradient outlinedButtonGradient = LinearGradient(
    colors: [Color(0xFF3933C6), Color(0xFFA05FFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient textGradient = LinearGradient(
    colors: [Color(0xFF3933C6), Color(0xFFA05FFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient inputBorderGradient = LinearGradient(
    colors: [Color(0xFF3933C6), Color(0xFFA05FFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, warning],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
