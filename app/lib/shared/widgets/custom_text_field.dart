import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Reusable custom text field widget with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final bool isDark;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isDark,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        const SizedBox(height: AppConstants.spacing8),
        
        // Text Field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(
                color: (isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary).withValues(alpha: 0.3),
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            counterText: '', // Hide character counter
          ),
        ),
      ],
    );
  }
}
