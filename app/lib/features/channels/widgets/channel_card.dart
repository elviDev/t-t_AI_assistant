// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/channel.dart';

/// Channel card widget displaying channel information
class ChannelCard extends StatelessWidget {
  final Channel channel;
  final bool isDark;
  final VoidCallback? onTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.isDark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacing20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: isDark 
                    ? AppColors.darkTextSecondary.withOpacity(0.1)
                    : AppColors.lightTextSecondary.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                _buildHeader(),
                
                const SizedBox(height: AppConstants.spacing12),
                
                // Description
                _buildDescription(),
                
                const SizedBox(height: AppConstants.spacing16),
                
                // Footer with stats and category
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with channel name and status
  Widget _buildHeader() {
    return Row(
      children: [
        // Channel icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: _getCategoryGradient(),
            borderRadius: BorderRadius.circular(AppConstants.spacing8),
          ),
          child: Icon(
            _getCategoryIcon(),
            color: Colors.white,
            size: 20,
          ),
        ),
        
        const SizedBox(width: AppConstants.spacing12),
        
        // Channel name and privacy indicator
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      channel.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        fontFamily: AppConstants.fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (channel.isPrivate) ...[
                    const SizedBox(width: AppConstants.spacing8),
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: isDark 
                          ? AppColors.darkTextSecondary 
                          : AppColors.lightTextSecondary,
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: AppConstants.spacing4),
              
              // Last activity
              Text(
                _getTimeAgo(channel.lastActivity),
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
        ),
        
        // More options
        IconButton(
          onPressed: () {
            // Show options menu
          },
          icon: Icon(
            Icons.more_vert,
            color: isDark 
                ? AppColors.darkTextSecondary 
                : AppColors.lightTextSecondary,
          ),
          iconSize: 20,
        ),
      ],
    );
  }

  /// Build description section
  Widget _buildDescription() {
    return Text(
      channel.description,
      style: TextStyle(
        fontSize: 14,
        color: isDark 
            ? AppColors.darkTextSecondary 
            : AppColors.lightTextSecondary,
        fontFamily: AppConstants.fontFamily,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build footer with stats and tags
  Widget _buildFooter() {
    return Row(
      children: [
        // Member count
        _buildStatChip(
          icon: Icons.people_outline,
          text: '${channel.memberIds.length}',
        ),
        
        const SizedBox(width: AppConstants.spacing8),
        
        // Message count
        _buildStatChip(
          icon: Icons.chat_bubble_outline,
          text: '${channel.messageCount}',
        ),
        
        const SizedBox(width: AppConstants.spacing8),
        
        // File count
        if (channel.fileCount > 0)
          _buildStatChip(
            icon: Icons.attach_file,
            text: '${channel.fileCount}',
          ),
        
        const Spacer(),
        
        // Category tag
        _buildCategoryTag(),
      ],
    );
  }

  /// Build stat chip
  Widget _buildStatChip({required IconData icon, required String text}) {
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

  /// Build category tag
  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing12,
        vertical: AppConstants.spacing4,
      ),
      decoration: BoxDecoration(
        gradient: _getCategoryGradient(),
        borderRadius: BorderRadius.circular(AppConstants.spacing8),
      ),
      child: Text(
        channel.category,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
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
      default:
        return AppColors.primaryGradient;
    }
  }

  /// Get category-specific icon
  IconData _getCategoryIcon() {
    switch (channel.category.toLowerCase()) {
      case 'development':
        return Icons.code;
      case 'marketing':
        return Icons.campaign;
      case 'design':
        return Icons.palette;
      case 'events':
        return Icons.event;
      case 'finance':
        return Icons.monetization_on;
      case 'meetings':
        return Icons.meeting_room;
      default:
        return Icons.chat;
    }
  }

  /// Get time ago string
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
