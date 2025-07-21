// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/message.dart';

/// Message bubble widget for displaying chat messages
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isDark;
  final Function(String)? onReact;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isDark = false,
    this.onReact,
    this.onReply,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _buildAvatar(),
            const SizedBox(width: AppConstants.spacing12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                _buildMessageContent(),
                if (message.reactions.isNotEmpty) 
                  _buildReactions(),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: AppConstants.spacing12),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  /// Build user avatar
  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: _getUserGradient(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          message.senderName.isNotEmpty 
              ? message.senderName[0].toUpperCase() 
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Build message content
  Widget _buildMessageContent() {
    return GestureDetector(
      onLongPress: _showMessageOptions,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          gradient: isMe 
              ? AppColors.primaryGradient 
              : null,
          color: isMe 
              ? null 
              : isDark 
                  ? AppColors.darkSurface 
                  : AppColors.lightSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppConstants.borderRadius),
            topRight: const Radius.circular(AppConstants.borderRadius),
            bottomLeft: Radius.circular(isMe ? AppConstants.borderRadius : 4),
            bottomRight: Radius.circular(isMe ? 4 : AppConstants.borderRadius),
          ),
          border: !isMe ? Border.all(
            color: isDark 
                ? AppColors.darkTextSecondary.withOpacity(0.1)
                : AppColors.lightTextSecondary.withOpacity(0.1),
          ) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender name (for others' messages)
            if (!isMe) ...[
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getUserColor(),
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              const SizedBox(height: AppConstants.spacing4),
            ],
            
            // Message content
            _buildMessageText(),
            
            const SizedBox(height: AppConstants.spacing8),
            
            // Timestamp and edit indicator
            _buildMessageFooter(),
          ],
        ),
      ),
    );
  }

  /// Build message text content
  Widget _buildMessageText() {
    return Text(
      message.content,
      style: TextStyle(
        fontSize: 15,
        color: isMe 
            ? Colors.white 
            : isDark 
                ? AppColors.darkText 
                : AppColors.lightText,
        fontFamily: AppConstants.fontFamily,
        height: 1.4,
      ),
    );
  }

  /// Build message footer with timestamp
  Widget _buildMessageFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.timestamp),
          style: TextStyle(
            fontSize: 11,
            color: isMe 
                ? Colors.white.withOpacity(0.8) 
                : isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        if (message.isEdited) ...[
          const SizedBox(width: AppConstants.spacing4),
          Text(
            '(edited)',
            style: TextStyle(
              fontSize: 11,
              color: isMe 
                  ? Colors.white.withOpacity(0.6) 
                  : isDark 
                      ? AppColors.darkTextSecondary 
                      : AppColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ],
    );
  }

  /// Build reactions
  Widget _buildReactions() {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.spacing8),
      child: Wrap(
        spacing: AppConstants.spacing4,
        children: message.reactions.map((reaction) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing8,
              vertical: AppConstants.spacing4,
            ),
            decoration: BoxDecoration(
              color: isDark 
                  ? AppColors.darkBackground 
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(AppConstants.spacing12),
              border: Border.all(
                color: isDark 
                    ? AppColors.darkTextSecondary.withOpacity(0.2)
                    : AppColors.lightTextSecondary.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reaction.emoji,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: AppConstants.spacing4),
                Text(
                  '${reaction.userIds.length}',
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
        }).toList(),
      ),
    );
  }

  /// Show message options
  void _showMessageOptions() {
    // Implementation would show a modal with options
    // For now, we'll just trigger the callbacks directly
  }

  /// Get user-specific gradient
  LinearGradient _getUserGradient() {
    final gradients = [
      AppColors.primaryGradient,
      const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
      const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
      const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFF7C3AED)]),
      const LinearGradient(colors: [Color(0xFFF87171), Color(0xFFEF4444)]),
    ];
    
    final index = message.senderId.hashCode % gradients.length;
    return gradients[index.abs()];
  }

  /// Get user-specific color
  Color _getUserColor() {
    final colors = [
      AppColors.primary,
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFA855F7),
      const Color(0xFFF87171),
    ];
    
    final index = message.senderId.hashCode % colors.length;
    return colors[index.abs()];
  }

  /// Format timestamp
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
