import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Utility class for applying gradients to widgets
class GradientUtils {
  GradientUtils._();

  /// Creates a gradient text widget
  static Widget gradientText(
    String text, {
    TextStyle? style,
    LinearGradient? gradient,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => (gradient ?? AppColors.textGradient)
          .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }

  /// Creates a gradient border for containers
  static Widget gradientBorder({
    required Widget child,
    double borderWidth = 1.0,
    double borderRadius = 8.0,
    LinearGradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? AppColors.inputBorderGradient,
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          color: Colors.transparent,
        ),
        child: child,
      ),
    );
  }

  /// Creates a gradient outlined button
  static Widget gradientOutlinedButton({
    required String text,
    required VoidCallback onPressed,
    double borderWidth = 2.0,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    LinearGradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? AppColors.outlinedButtonGradient,
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          color: Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius - borderWidth),
            onTap: onPressed,
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Center(
                child: Text(
                  text,
                  style: textStyle ?? const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a gradient input field
  static Widget gradientInputField({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    Widget? prefixIcon,
    double borderWidth = 1.0,
    double borderRadius = 8.0,
    LinearGradient? gradient,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? AppColors.inputBorderGradient,
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a gradient filled button
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    LinearGradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? AppColors.primaryGradient,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Center(
              child: Text(
                text,
                style: textStyle ?? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
