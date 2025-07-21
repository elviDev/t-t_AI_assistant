// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/channel.dart';

/// Channel header widget showing channel information
class ChannelHeader extends StatelessWidget {
  final Channel channel;
  final bool isDark;

  const ChannelHeader({
    super.key,
    required this.channel,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark 
                ? AppColors.darkTextSecondary.withOpacity(0.1)
                : AppColors.lightTextSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Channel description
          Text(
            channel.description,
            style: TextStyle(
              fontSize: 14,
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacing12),
          
          // Channel stats and info
          Row(
            children: [
              // Category tag
              _buildCategoryTag(),
              
              const SizedBox(width: AppConstants.spacing12),
              
              // Member count
              _buildInfoChip(
                icon: Icons.people_outline,
                text: '${channel.memberIds.length} members',
              ),
              
              const SizedBox(width: AppConstants.spacing12),
              
              // Privacy indicator
              if (channel.isPrivate)
                _buildInfoChip(
                  icon: Icons.lock_outline,
                  text: 'Private',
                ),
            ],
          ),
          
          // Tags
          if (channel.tags.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacing12),
            _buildTags(),
          ],
        ],
      ),
    );
  }

  /// Build category tag
  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing12,
        vertical: AppConstants.spacing4,
      ),
      decoration: BoxDecoration(
        gradient: _getCategoryGradient(),
        borderRadius: BorderRadius.circular(AppConstants.spacing12),
      ),
      child: Text(
        channel.category,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build info chip
  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing8,
        vertical: AppConstants.spacing4,
      ),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.darkBackground 
            : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppConstants.spacing8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark 
                ? AppColors.darkTextSecondary 
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(width: AppConstants.spacing4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  /// Build tags
  Widget _buildTags() {
    return Wrap(
      spacing: AppConstants.spacing8,
      runSpacing: AppConstants.spacing4,
      children: channel.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing8,
            vertical: AppConstants.spacing4,
          ),
          decoration: BoxDecoration(
            color: isDark 
                ? AppColors.darkBackground 
                : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(AppConstants.spacing8),
            border: Border.all(
              color: isDark 
                  ? AppColors.darkTextSecondary.withOpacity(0.2)
                  : AppColors.lightTextSecondary.withOpacity(0.2),
            ),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 11,
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Get category-specific gradient
  LinearGradient _getCategoryGradient() {
    switch (channel.category.toLowerCase()) {
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
