import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Notification widget that displays floating notifications
class NotificationWidget extends StatefulWidget {
  final Widget child;

  const NotificationWidget({
    super.key,
    required this.child,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with TickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  AppNotification? _currentNotification;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _notificationService.addListener(_onNotificationReceived);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationReceived);
    _animationController.dispose();
    super.dispose();
  }

  void _onNotificationReceived(AppNotification notification) {
    setState(() {
      _currentNotification = notification;
    });
    
    _animationController.forward().then((_) {
      // Auto-hide after 4 seconds
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted && _currentNotification?.id == notification.id) {
          _hideNotification();
        }
      });
    });
  }

  void _hideNotification() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentNotification = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          if (_currentNotification != null)
            _buildNotificationBanner(),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner() {
    final notification = _currentNotification!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: _buildNotificationCard(notification, isDark),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification, bool isDark) {
    return GestureDetector(
      onTap: () {
        _hideNotification();
        _notificationService.markAsRead(notification.id);
        // Navigate to the relevant screen
        _navigateToNotificationSource(notification);
      },
      onVerticalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy < -500) {
          _hideNotification();
        }
      },
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF2F2F2F) : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Notification icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: notification.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.color,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2F2F2F),
                        fontFamily: AppConstants.fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontFamily: AppConstants.fontFamily,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Close button
              GestureDetector(
                onTap: _hideNotification,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNotificationSource(AppNotification notification) {
    switch (notification.type) {
      case NotificationType.mention:
      case NotificationType.reaction:
        if (notification.channelName != null) {
          // Navigate to channel
          // Navigator.pushNamed(context, '/channel', arguments: notification.channelName);
        }
        break;
      case NotificationType.taskAssignment:
        if (notification.taskTitle != null) {
          // Navigate to task
          // Navigator.pushNamed(context, '/task', arguments: notification.taskTitle);
        }
        break;
      case NotificationType.channelInvite:
        // Navigate to channel invitation
        break;
      case NotificationType.general:
        // Navigate to notifications list
        break;
    }
  }
}

/// Notification badge widget for showing unread count
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final bool showBadge;
  final int? count;

  const NotificationBadge({
    super.key,
    required this.child,
    this.showBadge = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showBadge && (count == null || count! > 0))
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: count != null
                  ? Text(
                      count! > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}

/// Notification list screen
class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService().notifications;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF2F2F2F),
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              NotificationService().clearAll();
              Navigator.pop(context);
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationTile(notification, isDark);
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : Colors.grey[600],
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey[500],
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(AppNotification notification, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead 
            ? Colors.transparent 
            : (isDark ? const Color(0xFF2F2F2F) : const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: notification.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification.icon,
            color: notification.color,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF2F2F2F),
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.grey[500],
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ],
        ),
        onTap: () {
          NotificationService().markAsRead(notification.id);
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 