import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/task.dart';

/// Task detail screen for viewing and editing task details
class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task header
                _buildTaskHeader(isDark),
                
                const SizedBox(height: AppConstants.spacing24),
                
                // Task description
                _buildTaskDescription(isDark),
                
                const SizedBox(height: AppConstants.spacing24),
                
                // Task details
                _buildTaskDetails(isDark),
                
                const SizedBox(height: AppConstants.spacing24),
                
                // Task actions
                _buildTaskActions(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
      title: Text(
        'Task Details',
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _editTask,
          icon: Icon(
            Icons.edit_outlined,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        IconButton(
          onPressed: _shareTask,
          icon: Icon(
            Icons.share_outlined,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }

  /// Build task header
  Widget _buildTaskHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          _task.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
            decoration: _task.status == TaskStatus.completed 
                ? TextDecoration.lineThrough 
                : null,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacing16),
        
        // Status and priority chips
        Row(
          children: [
            _buildStatusChip(isDark),
            const SizedBox(width: AppConstants.spacing8),
            _buildPriorityChip(isDark),
          ],
        ),
      ],
    );
  }

  /// Build task description
  Widget _buildTaskDescription(bool isDark) {
    if (_task.description.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacing8),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacing16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Text(
            _task.description,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Build task details
  Widget _buildTaskDetails(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacing16),
        
        _buildDetailItem(
          icon: Icons.person_outline,
          label: 'Assigned to',
          value: _task.assigneeName ?? 'Unassigned',
          isDark: isDark,
        ),
        
        _buildDetailItem(
          icon: Icons.schedule_outlined,
          label: 'Due date',
          value: _task.dueDate != null 
              ? _formatDate(_task.dueDate!)
              : 'No due date',
          isDark: isDark,
        ),
        
        _buildDetailItem(
          icon: Icons.access_time_outlined,
          label: 'Created',
          value: _formatDate(_task.createdAt),
          isDark: isDark,
        ),
        
        if (_task.completedAt != null)
          _buildDetailItem(
            icon: Icons.check_circle_outline,
            label: 'Completed',
            value: _formatDate(_task.completedAt!),
            isDark: isDark,
          ),
      ],
    );
  }

  /// Build detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          
          const SizedBox(width: AppConstants.spacing12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                
                const SizedBox(height: 2),
                
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build task actions
  Widget _buildTaskActions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacing16),
        
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: _task.status == TaskStatus.completed 
                    ? Icons.undo_outlined 
                    : Icons.check_circle_outline,
                label: _task.status == TaskStatus.completed 
                    ? 'Mark Incomplete' 
                    : 'Mark Complete',
                onTap: _toggleTaskCompletion,
                isDark: isDark,
                isPrimary: _task.status != TaskStatus.completed,
              ),
            ),
            
            const SizedBox(width: AppConstants.spacing12),
            
            Expanded(
              child: _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Delete Task',
                onTap: _deleteTask,
                isDark: isDark,
                isDestructive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    if (isDestructive) {
              backgroundColor = AppColors.errorColor.withValues(alpha: 0.1);
      textColor = AppColors.errorColor;
              borderColor = AppColors.errorColor.withValues(alpha: 0.3);
    } else if (isPrimary) {
      backgroundColor = AppColors.primaryColor;
      textColor = Colors.white;
      borderColor = AppColors.primaryColor;
    } else {
      backgroundColor = isDark ? AppColors.darkCard : AppColors.lightCard;
      textColor = isDark ? AppColors.darkText : AppColors.lightText;
      borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    }
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing16,
            horizontal: AppConstants.spacing12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: textColor,
              ),
              
              const SizedBox(width: AppConstants.spacing8),
              
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip(bool isDark) {
    Color statusColor;
    String statusText;
    
    switch (_task.status) {
      case TaskStatus.pending:
        statusColor = AppColors.secondaryColor;
        statusText = 'Pending';
        break;
      case TaskStatus.inProgress:
        statusColor = AppColors.primaryColor;
        statusText = 'In Progress';
        break;
      case TaskStatus.completed:
        statusColor = AppColors.successColor;
        statusText = 'Completed';
        break;
      case TaskStatus.overdue:
        statusColor = AppColors.errorColor;
        statusText = 'Overdue';
        break;
      case TaskStatus.cancelled:
        statusColor = AppColors.secondaryColor;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing12,
        vertical: AppConstants.spacing6,
      ),
      decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: statusColor,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build priority chip
  Widget _buildPriorityChip(bool isDark) {
    Color priorityColor;
    String priorityText;
    
    switch (_task.priority) {
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
        horizontal: AppConstants.spacing12,
        vertical: AppConstants.spacing6,
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
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: priorityColor,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Edit task
  void _editTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit task feature coming soon!'),
      ),
    );
  }

  /// Share task
  void _shareTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share task feature coming soon!'),
      ),
    );
  }

  /// Toggle task completion
  void _toggleTaskCompletion() {
    setState(() {
      if (_task.status == TaskStatus.completed) {
        _task = _task.copyWith(
          status: TaskStatus.inProgress,
          completedAt: null,
        );
      } else {
        _task = _task.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _task.status == TaskStatus.completed 
              ? 'Task marked as completed!' 
              : 'Task marked as incomplete!',
        ),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  /// Delete task
  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted successfully!'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
