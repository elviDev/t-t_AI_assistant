import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Centralized theme configuration for the application
/// Provides consistent styling across all screens and components
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.lightSurface,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.lightText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily,
        ),
        iconTheme: IconThemeData(color: AppColors.lightText),
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.lightBackground,

      // Text Theme
      textTheme: _buildTextTheme(AppColors.lightText),

      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(true),
      outlinedButtonTheme: _buildOutlinedButtonTheme(true),
      textButtonTheme: _buildTextButtonTheme(true),

      // Input Decoration Theme
      inputDecorationTheme: _buildInputDecorationTheme(true),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),

      // Font Family
      fontFamily: AppConstants.fontFamily,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.darkSurface,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily,
        ),
        iconTheme: IconThemeData(color: AppColors.darkText),
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.darkBackground,

      // Text Theme
      textTheme: _buildTextTheme(AppColors.darkText),

      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(false),
      outlinedButtonTheme: _buildOutlinedButtonTheme(false),
      textButtonTheme: _buildTextButtonTheme(false),

      // Input Decoration Theme
      inputDecorationTheme: _buildInputDecorationTheme(false),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),

      // Font Family
      fontFamily: AppConstants.fontFamily,
    );
  }

  /// Build text theme with consistent styling
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
        fontFamily: AppConstants.fontFamily,
      ),
    );
  }

  /// Build elevated button theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(bool isLight) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build outlined button theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(bool isLight) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: isLight ? AppColors.lightSurface : AppColors.darkSurface,
        foregroundColor: isLight ? AppColors.lightText : AppColors.darkText,
        elevation: 0,
        side: BorderSide(
          color: (isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary)
              .withValues(alpha: 0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build text button theme
  static TextButtonThemeData _buildTextButtonTheme(bool isLight) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme(bool isLight) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? Colors.grey[100] : AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: BorderSide(
          color: (isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isLight ? AppColors.lightText : AppColors.darkText,
        fontFamily: AppConstants.fontFamily,
      ),
    );
  }
}
