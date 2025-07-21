// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Channel category filter widget
class ChannelCategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isDark;

  const ChannelCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Development',
      'Marketing',
      'Design',
      'Events',
      'Finance',
      'Meetings',
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return Container(
            margin: EdgeInsets.only(
              right: index < categories.length - 1 ? AppConstants.spacing12 : 0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onCategorySelected(category),
                borderRadius: BorderRadius.circular(AppConstants.spacing20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing20,
                    vertical: AppConstants.spacing8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? _getCategoryGradient(category) : null,
                    color: isSelected 
                        ? null 
                        : isDark 
                            ? AppColors.darkSurface 
                            : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppConstants.spacing20),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.transparent
                          : isDark 
                              ? AppColors.darkTextSecondary.withOpacity(0.2)
                              : AppColors.lightTextSecondary.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected 
                            ? Colors.white
                            : isDark 
                                ? AppColors.darkText 
                                : AppColors.lightText,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Get category-specific gradient
  LinearGradient _getCategoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'development':
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        );
      case 'marketing':
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        );
      case 'design':
        return const LinearGradient(
          colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
        );
      case 'events':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        );
      case 'finance':
        return const LinearGradient(
          colors: [Color(0xFFF87171), Color(0xFFEF4444)],
        );
      case 'meetings':
        return const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
        );
      default:
        return AppColors.primaryGradient;
    }
  }
}
