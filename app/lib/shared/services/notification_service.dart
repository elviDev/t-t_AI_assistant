import 'package:flutter/material.dart';

/// Notification service for handling mentions, task assignments, and other notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = [];
  final List<Function(AppNotification)> _listeners = [];

  /// Add a notification listener
  void addListener(Function(AppNotification) listener) {
    _listeners.add(listener);
  }

  /// Remove a notification listener
  void removeListener(Function(AppNotification) listener) {
    _listeners.remove(listener);
  }

  /// Send a mention notification
  void sendMentionNotification({
    required String mentionedUserId,
    required String mentionedUserName,
    required String senderName,
    required String channelName,
    required String messageContent,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.mention,
      title: 'Mentioned in #$channelName',
      message: '$senderName mentioned you: ${_truncateMessage(messageContent)}',
      timestamp: DateTime.now(),
      channelName: channelName,
      senderName: senderName,
      isRead: false,
    );

    _addNotification(notification);
  }

  /// Send a task assignment notification
  void sendTaskAssignmentNotification({
    required String assignedUserId,
    required String assignedUserName,
    required String assigner,
    required String taskTitle,
    required String channelName,
    DateTime? dueDate,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.taskAssignment,
      title: 'Task Assigned',
      message: '$assigner assigned you "$taskTitle" in #$channelName${dueDate != null ? ' (Due: ${_formatDueDate(dueDate)})' : ''}',
      timestamp: DateTime.now(),
      channelName: channelName,
      senderName: assigner,
      taskTitle: taskTitle,
      dueDate: dueDate,
      isRead: false,
    );

    _addNotification(notification);
  }

  /// Send a reaction notification
  void sendReactionNotification({
    required String userId,
    required String userName,
    required String reactor,
    required String emoji,
    required String channelName,
    required String messageContent,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.reaction,
      title: 'Reaction to your message',
      message: '$reactor reacted $emoji to your message in #$channelName',
      timestamp: DateTime.now(),
      channelName: channelName,
      senderName: reactor,
      isRead: false,
    );

    _addNotification(notification);
  }

  /// Send a channel invitation notification
  void sendChannelInviteNotification({
    required String invitedUserId,
    required String invitedUserName,
    required String inviter,
    required String channelName,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.channelInvite,
      title: 'Channel Invitation',
      message: '$inviter invited you to join #$channelName',
      timestamp: DateTime.now(),
      channelName: channelName,
      senderName: inviter,
      isRead: false,
    );

    _addNotification(notification);
  }

  /// Add notification and notify listeners
  void _addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    
    // Keep only last 50 notifications
    if (_notifications.length > 50) {
      _notifications.removeRange(50, _notifications.length);
    }

    // Notify all listeners
    for (final listener in _listeners) {
      listener(notification);
    }
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// Get all notifications
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  /// Get unread notifications count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
  }

  /// Helper methods
  String _truncateMessage(String message, [int maxLength = 50]) {
    if (message.length <= maxLength) return message;
    return '${message.substring(0, maxLength)}...';
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return 'Soon';
    }
  }
}

/// Notification types
enum NotificationType {
  mention,
  taskAssignment,
  reaction,
  channelInvite,
  general,
}

/// App notification model
class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? channelName;
  final String? senderName;
  final String? taskTitle;
  final DateTime? dueDate;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.channelName,
    this.senderName,
    this.taskTitle,
    this.dueDate,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    String? channelName,
    String? senderName,
    String? taskTitle,
    DateTime? dueDate,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      channelName: channelName ?? this.channelName,
      senderName: senderName ?? this.senderName,
      taskTitle: taskTitle ?? this.taskTitle,
      dueDate: dueDate ?? this.dueDate,
      isRead: isRead ?? this.isRead,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.taskAssignment:
        return Icons.assignment;
      case NotificationType.reaction:
        return Icons.emoji_emotions;
      case NotificationType.channelInvite:
        return Icons.group_add;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.mention:
        return Colors.blue;
      case NotificationType.taskAssignment:
        return Colors.orange;
      case NotificationType.reaction:
        return Colors.pink;
      case NotificationType.channelInvite:
        return Colors.green;
      case NotificationType.general:
        return Colors.grey;
    }
  }
} 