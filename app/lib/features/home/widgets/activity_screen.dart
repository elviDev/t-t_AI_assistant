// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Activity screen widget for displaying notifications and activity feed
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample activity data
  final List<ActivityItem> _activities = [
    ActivityItem(
      id: '1',
      type: ActivityType.channelCreated,
      title: 'New channel created',
      description: 'Development Team channel was created by John Doe',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
    ActivityItem(
      id: '2',
      type: ActivityType.taskAssigned,
      title: 'Task assigned to you',
      description: 'Complete user authentication module - Due tomorrow',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    ActivityItem(
      id: '3',
      type: ActivityType.messageReceived,
      title: 'New message in Marketing',
      description: 'Sarah: The campaign assets are ready for review',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    ActivityItem(
      id: '4',
      type: ActivityType.projectUpdated,
      title: 'Project progress updated',
      description: 'Mobile App Development is now 75% complete',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    ActivityItem(
      id: '5',
      type: ActivityType.meetingScheduled,
      title: 'Meeting scheduled',
      description: 'Weekly standup meeting - Tomorrow at 10:00 AM',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
          child: Column(
            children: [
              // Filter tabs
              _buildFilterTabs(isDark),
              
              // Activity list
              Expanded(
                child: _buildActivityList(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    final unreadCount = _activities.where((activity) => !activity.isRead).length;
    
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'Activity',
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: AppConstants.spacing8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing8,
                vertical: AppConstants.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (unreadCount > 0)
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ),
        const SizedBox(width: AppConstants.spacing8),
      ],
    );
  }

  /// Build filter tabs
  Widget _buildFilterTabs(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
      child: Row(
        children: [
          _buildFilterChip('All', true, isDark),
          const SizedBox(width: AppConstants.spacing8),
          _buildFilterChip('Unread', false, isDark),
          const SizedBox(width: AppConstants.spacing8),
          _buildFilterChip('Today', false, isDark),
        ],
      ),
    );
  }

  /// Build filter chip
  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing8,
      ),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppColors.primaryColor 
            : (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: isSelected 
              ? AppColors.primaryColor 
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected 
              ? Colors.white 
              : (isDark ? AppColors.darkText : AppColors.lightText),
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build activity list
  Widget _buildActivityList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      itemCount: _activities.length,
      itemBuilder: (context, index) {
        final activity = _activities[index];
        return _buildActivityItem(activity, isDark);
      },
    );
  }

  /// Build activity item
  Widget _buildActivityItem(ActivityItem activity, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: activity.isRead 
              ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
              : AppColors.primaryColor.withOpacity(0.3),
          width: activity.isRead ? 1 : 2,
        ),
      ),
      child: Row(
        children: [
          // Activity icon
          Container(
            width: AppConstants.iconButtonSize,
            height: AppConstants.iconButtonSize,
            decoration: BoxDecoration(
              color: _getActivityColor(activity.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Icon(
              _getActivityIcon(activity.type),
              color: _getActivityColor(activity.type),
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppConstants.spacing12),
          
          // Activity content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: activity.isRead ? FontWeight.w500 : FontWeight.w600,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                    ),
                    if (!activity.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.spacing4),
                
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppConstants.spacing8),
                
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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

  /// Get activity icon
  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.channelCreated:
        return Icons.add_circle_outline;
      case ActivityType.taskAssigned:
        return Icons.task_alt_outlined;
      case ActivityType.messageReceived:
        return Icons.message_outlined;
      case ActivityType.projectUpdated:
        return Icons.trending_up_outlined;
      case ActivityType.meetingScheduled:
        return Icons.event_outlined;
    }
  }

  /// Get activity color
  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.channelCreated:
        return AppColors.primaryColor;
      case ActivityType.taskAssigned:
        return AppColors.warningColor;
      case ActivityType.messageReceived:
        return AppColors.successColor;
      case ActivityType.projectUpdated:
        return AppColors.primaryColor;
      case ActivityType.meetingScheduled:
        return AppColors.secondaryColor;
    }
  }

  /// Format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Mark all activities as read
  void _markAllAsRead() {
    setState(() {
      for (var activity in _activities) {
        activity.isRead = true;
      }
    });
  }
}

/// Activity item model
class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isRead;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isRead,
  });
}

/// Activity type enum
enum ActivityType {
  channelCreated,
  taskAssigned,
  messageReceived,
  projectUpdated,
  meetingScheduled,
}
