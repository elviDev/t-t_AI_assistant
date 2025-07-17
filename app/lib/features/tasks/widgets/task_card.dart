import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/task.dart';

/// Task card widget for displaying task information
class TaskCard extends StatelessWidget {
  final Task task;
  final bool isDark;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.isDark,
    this.onTap,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with title and priority
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontFamily: AppConstants.fontFamily,
                          decoration: task.status == TaskStatus.completed 
                              ? TextDecoration.lineThrough 
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    _buildPriorityChip(),
                  ],
                ),
                
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacing8),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontFamily: AppConstants.fontFamily,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: AppConstants.spacing16),
                
                // Status and due date row
                Row(
                  children: [
                    _buildStatusChip(),
                    const Spacer(),
                    if (task.dueDate != null) _buildDueDate(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build priority chip
  Widget _buildPriorityChip() {
    Color priorityColor;
    String priorityText;
    
    switch (task.priority) {
      case TaskPriority.urgent:
        priorityColor = AppColors.errorColor;
        priorityText = 'Urgent';
        break;
      case TaskPriority.high:
        priorityColor = AppColors.errorColor;
        priorityText = 'High';
        break;
      case TaskPriority.medium:
        priorityColor = AppColors.warningColor;
        priorityText = 'Medium';
        break;
      case TaskPriority.low:
        priorityColor = AppColors.successColor;
        priorityText = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing8,
        vertical: AppConstants.spacing4,
      ),
      decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
                              color: priorityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        priorityText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: priorityColor,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip() {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (task.status) {
      case TaskStatus.pending:
        statusColor = AppColors.secondaryColor;
        statusIcon = Icons.schedule_outlined;
        statusText = 'Pending';
        break;
      case TaskStatus.inProgress:
        statusColor = AppColors.primaryColor;
        statusIcon = Icons.play_circle_outline;
        statusText = 'In Progress';
        break;
      case TaskStatus.completed:
        statusColor = AppColors.successColor;
        statusIcon = Icons.check_circle_outline;
        statusText = 'Completed';
        break;
      case TaskStatus.overdue:
        statusColor = AppColors.errorColor;
        statusIcon = Icons.warning_outlined;
        statusText = 'Overdue';
        break;
      case TaskStatus.cancelled:
        statusColor = AppColors.secondaryColor;
        statusIcon = Icons.cancel_outlined;
        statusText = 'Cancelled';
        break;
    }

    return InkWell(
      onTap: onStatusChanged,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing8,
          vertical: AppConstants.spacing4,
        ),
        decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              statusIcon,
              size: 14,
              color: statusColor,
            ),
            const SizedBox(width: AppConstants.spacing4),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build due date
  Widget _buildDueDate() {
    if (task.dueDate == null) return const SizedBox();
    
    final now = DateTime.now();
    final difference = task.dueDate!.difference(now);
    final isOverdue = difference.isNegative;
    
    String dateText;
    Color dateColor;
    
    if (isOverdue) {
      dateText = 'Overdue';
      dateColor = AppColors.errorColor;
    } else if (difference.inDays == 0) {
      dateText = 'Today';
      dateColor = AppColors.warningColor;
    } else if (difference.inDays == 1) {
      dateText = 'Tomorrow';
      dateColor = AppColors.warningColor;
    } else if (difference.inDays <= 7) {
      dateText = '${difference.inDays} days';
      dateColor = AppColors.warningColor;
    } else {
      dateText = '${difference.inDays} days';
      dateColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule_outlined,
          size: 14,
          color: dateColor,
        ),
        const SizedBox(width: AppConstants.spacing4),
        Text(
          dateText,
          style: TextStyle(
            fontSize: 12,
            color: dateColor,
            fontWeight: isOverdue || difference.inDays <= 1 ? FontWeight.w600 : FontWeight.normal,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }
}
