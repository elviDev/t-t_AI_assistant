import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Reusable custom button widget with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isDark;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final BorderSide? borderSide;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isDark,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = AppConstants.buttonHeight,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = isPrimary 
        ? AppColors.primary 
        : (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    
    final defaultForegroundColor = isPrimary 
        ? Colors.white 
        : (isDark ? AppColors.darkText : AppColors.lightText);

    final defaultBorderSide = !isPrimary ? BorderSide(
      color: (isDark 
          ? AppColors.darkTextSecondary 
          : AppColors.lightTextSecondary).withValues(alpha: 0.3),
      width: 1,
    ) : null;

    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBackgroundColor,
          foregroundColor: foregroundColor ?? defaultForegroundColor,
          elevation: elevation ?? (isPrimary ? 8 : 0),
          shadowColor: isPrimary ? AppColors.primary.withValues(alpha: 0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            side: borderSide ?? defaultBorderSide ?? BorderSide.none,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? defaultForegroundColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppConstants.spacing8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Floating action button with gradient background
class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Gradient gradient;
  final double size;
  final bool isListening;
  final Animation<double>? animation;

  const GradientFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.gradient = AppColors.primaryGradient,
    this.size = AppConstants.floatingButtonSize,
    this.isListening = false,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Icon(
            icon,
            color: Colors.white,
            size: AppConstants.mediumIconSize,
          ),
        ),
      ),
    );

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Transform.scale(
            scale: isListening ? animation!.value : 1.0,
            child: button,
          );
        },
      );
    }

    return button;
  }
}
