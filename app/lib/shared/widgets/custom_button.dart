import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/gradient_utils.dart';

/// Reusable custom button widget with consistent styling
/// Primary buttons automatically use gradient background
/// Secondary buttons automatically use gradient borders
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isDark;
  final IconData? icon;
  final String? svgAsset;
  final String? imageAsset;
  final Widget? customIcon;
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
    this.svgAsset,
    this.imageAsset,
    this.customIcon,
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
        ? Colors.transparent // Use transparent for gradient background
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
      child: isPrimary
          ? _buildGradientButton(defaultForegroundColor)
          : GradientUtils.gradientBorder(
              borderRadius: AppConstants.borderRadius,
              child: _buildButton(defaultBackgroundColor, defaultForegroundColor, defaultBorderSide),
            ),
    );
  }

  Widget _buildButton(Color defaultBackgroundColor, Color defaultForegroundColor, BorderSide? defaultBorderSide) {
    return ElevatedButton(
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
                  _buildIcon(color: foregroundColor ?? defaultForegroundColor),
                  if (icon != null || svgAsset != null || imageAsset != null || customIcon != null) const SizedBox(width: AppConstants.spacing8),
                  !isPrimary
                      ? GradientUtils.gradientText(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        )
                      : Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                ],
              ),
    );
  }

  Widget _buildGradientButton(Color defaultForegroundColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? defaultForegroundColor,
          elevation: 0, // Remove elevation since we have custom shadow
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
                  _buildIcon(color: foregroundColor ?? defaultForegroundColor),
                  if (icon != null || svgAsset != null || imageAsset != null || customIcon != null) const SizedBox(width: AppConstants.spacing8),
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

  /// Helper method to render either SVG, Icon, or custom widget
  Widget _buildIcon({Color? color}) {
    if (customIcon != null) {
      return customIcon!;
    } else if (imageAsset != null) {
      return Image.asset(
        imageAsset!,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
      );
    } else if (svgAsset != null) {
      try {
        return SvgPicture.asset(
          svgAsset!,
          width: 20,
          height: 20,
          colorFilter: svgAsset!.contains('google') 
              ? null 
              : (color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null),
          placeholderBuilder: (context) {
            debugPrint('SVG failed to load: $svgAsset');
            return Icon(
              Icons.error,
              size: 20,
              color: Colors.red,
            );
          },
        );
      } catch (e) {
        debugPrint('Error loading SVG: $e');
        return Icon(
          Icons.warning,
          size: 20,
          color: Colors.orange,
        );
      }
    } else if (icon != null) {
      return Icon(
        icon,
        size: 20,
        color: color,
      );
    }
    return const SizedBox.shrink();
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
