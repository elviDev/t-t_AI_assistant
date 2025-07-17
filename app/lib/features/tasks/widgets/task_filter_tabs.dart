import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/task.dart';

/// Task filter tabs widget for filtering tasks by status
class TaskFilterTabs extends StatelessWidget {
  final TaskStatus? selectedStatus;
  final Function(TaskStatus?) onStatusChanged;
  final bool isDark;
  final Map<TaskStatus?, int> taskCounts;

  const TaskFilterTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.isDark,
    this.taskCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterTab(
            label: 'All',
            status: null,
            count: taskCounts[null] ?? 0,
          ),
          const SizedBox(width: AppConstants.spacing12),
          _buildFilterTab(
            label: 'Pending',
            status: TaskStatus.pending,
            count: taskCounts[TaskStatus.pending] ?? 0,
          ),
          const SizedBox(width: AppConstants.spacing12),
          _buildFilterTab(
            label: 'In Progress',
            status: TaskStatus.inProgress,
            count: taskCounts[TaskStatus.inProgress] ?? 0,
          ),
          const SizedBox(width: AppConstants.spacing12),
          _buildFilterTab(
            label: 'Completed',
            status: TaskStatus.completed,
            count: taskCounts[TaskStatus.completed] ?? 0,
          ),
          const SizedBox(width: AppConstants.spacing12),
          _buildFilterTab(
            label: 'Overdue',
            status: TaskStatus.overdue,
            count: taskCounts[TaskStatus.overdue] ?? 0,
          ),
        ],
      ),
    );
  }

  /// Build individual filter tab
  Widget _buildFilterTab({
    required String label,
    required TaskStatus? status,
    required int count,
  }) {
    final isSelected = selectedStatus == status;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onStatusChanged(status),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing20,
            vertical: AppConstants.spacing12,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primaryColor 
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primaryColor 
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected 
                      ? Colors.white 
                      : (isDark ? AppColors.darkText : AppColors.lightText),
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: AppConstants.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.spacing12),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected 
                          ? Colors.white 
                          : AppColors.primaryColor,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
