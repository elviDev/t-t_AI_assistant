import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Quick action card widget for home screen actions
class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool isFullWidth;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimationDuration,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: (isDark 
                ? AppColors.darkTextSecondary 
                : AppColors.lightTextSecondary).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: isFullWidth 
              ? MainAxisAlignment.center 
              : MainAxisAlignment.start,
          children: [
            // Action icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppConstants.mediumIconSize,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Action title
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
