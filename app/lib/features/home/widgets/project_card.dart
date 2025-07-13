import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/project.dart';

/// Project card widget displaying project information
class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isDark;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.isDark,
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and status
                _buildHeader(),
                
                const SizedBox(height: AppConstants.spacing8),
                
                // Description
                _buildDescription(),
                
                const SizedBox(height: AppConstants.spacing16),
                
                // Progress section
                _buildProgress(),
                
                const SizedBox(height: AppConstants.spacing16),
                
                // Footer with team and date info
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with title and status badge
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            project.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ),
        
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            project.status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getStatusColor(),
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  /// Build description section
  Widget _buildDescription() {
    return Text(
      project.description,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        fontFamily: AppConstants.fontFamily,
      ),
    );
  }

  /// Build progress section
  Widget _buildProgress() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Progress bar
              LinearProgressIndicator(
                value: project.progress,
                backgroundColor: (isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary).withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  project.progress == 1.0 ? AppColors.success : AppColors.primary,
                ),
                minHeight: AppConstants.progressIndicatorHeight,
              ),
            ],
          ),
        ),
        
        const SizedBox(width: AppConstants.spacing16),
        
        // Progress percentage
        Text(
          '${(project.progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }

  /// Build footer section with team and date info
  Widget _buildFooter() {
    return Row(
      children: [
        // Team members info
        Icon(
          Icons.people_outline,
          size: AppConstants.smallIconSize,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        
        const SizedBox(width: AppConstants.spacing8),
        
        Text(
          '${project.teamMembers.length} members',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        
        const Spacer(),
        
        // Due date info
        Icon(
          Icons.calendar_today_outlined,
          size: AppConstants.smallIconSize,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        
        const SizedBox(width: AppConstants.spacing8),
        
        Text(
          _formatDate(project.dueDate),
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }

  /// Get status color based on project status
  Color _getStatusColor() {
    switch (project.status) {
      case ProjectStatus.inProgress:
        return AppColors.primary;
      case ProjectStatus.completed:
        return AppColors.success;
      case ProjectStatus.pending:
        return AppColors.warning;
      case ProjectStatus.cancelled:
        return AppColors.error;
      case ProjectStatus.onHold:
        return AppColors.secondary;
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${difference.abs()} days ago';
    }
  }
}
