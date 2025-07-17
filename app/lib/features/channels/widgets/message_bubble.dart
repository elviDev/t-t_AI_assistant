import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/message.dart';

/// Simple and modern message bubble widget with reactions and mentions
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
      padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _buildSimpleAvatar(),
            const SizedBox(width: AppConstants.spacing8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe) _buildSenderName(),
                _buildMessageBubble(context),
                if (message.reactions.isNotEmpty) 
                  _buildReactions(context),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: AppConstants.spacing8),
            _buildSimpleAvatar(),
          ],
        ],
      ),
    );
  }

  /// Build simple, clean avatar
  Widget _buildSimpleAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _getUserColor(),
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
            fontSize: 12,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ),
    );
  }

  /// Build simple sender name
  Widget _buildSenderName() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppConstants.spacing4,
        left: 2,
      ),
      child: Text(
        message.senderName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _getUserColor(),
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Build clean, modern message bubble with reactions
  Widget _buildMessageBubble(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showReactionPicker(context),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing16,
          vertical: AppConstants.spacing12,
        ),
        decoration: BoxDecoration(
          color: isMe 
              ? AppColors.primaryColor
              : isDark 
                  ? const Color(0xFF2F2F2F)
                  : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMessageText(),
            const SizedBox(height: AppConstants.spacing6),
            _buildMessageInfo(),
          ],
        ),
      ),
    );
  }

  /// Build clean message text with mention highlighting
  Widget _buildMessageText() {
    return RichText(
      text: _buildTextWithMentions(),
    );
  }

  /// Build text with highlighted mentions
  TextSpan _buildTextWithMentions() {
    final text = message.content;
    final List<TextSpan> spans = [];
    final RegExp mentionRegex = RegExp(r'@(\w+(?:\s+\w+)*)');
    
    int lastIndex = 0;
    
    for (final match in mentionRegex.allMatches(text)) {
      // Add text before mention
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: _getDefaultTextStyle(),
        ));
      }
      
      // Add highlighted mention
      spans.add(TextSpan(
        text: match.group(0),
        style: _getMentionTextStyle(),
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: _getDefaultTextStyle(),
      ));
    }
    
    return TextSpan(children: spans);
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyle(
      fontSize: 15,
      color: isMe 
          ? Colors.white
          : isDark 
              ? Colors.white
              : const Color(0xFF2F2F2F),
      fontFamily: AppConstants.fontFamily,
      height: 1.3,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _getMentionTextStyle() {
    return TextStyle(
      fontSize: 15,
      color: isMe 
          ? Colors.white
          : AppColors.primaryColor,
      fontFamily: AppConstants.fontFamily,
      height: 1.3,
      fontWeight: FontWeight.w600,
      backgroundColor: isMe 
          ? Colors.white.withValues(alpha: 0.2)
          : AppColors.primaryColor.withValues(alpha: 0.1),
    );
  }

  /// Build simple message info
  Widget _buildMessageInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (message.isEdited) ...[
          Text(
            'edited',
            style: TextStyle(
              fontSize: 10,
              color: isMe 
                  ? Colors.white.withValues(alpha: 0.7)
                  : isDark 
                      ? Colors.white54
                      : Colors.grey[600],
              fontStyle: FontStyle.italic,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(width: AppConstants.spacing4),
        ],
        Text(
          _formatTime(message.timestamp),
          style: TextStyle(
            fontSize: 10,
            color: isMe 
                ? Colors.white.withValues(alpha: 0.7)
                : isDark 
                    ? Colors.white54
                    : Colors.grey[600],
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: AppConstants.spacing4),
          Icon(
            Icons.done_all,
            size: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ],
      ],
    );
  }

  /// Build simple reactions with tap to add/remove
  Widget _buildReactions(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppConstants.spacing6,
        left: isMe ? 0 : 2,
        right: isMe ? 2 : 0,
      ),
      child: Wrap(
        spacing: AppConstants.spacing4,
        children: [
          ...message.reactions.map((reaction) => _buildReactionChip(context, reaction)),
          _buildAddReactionButton(context),
        ],
      ),
    );
  }

  Widget _buildReactionChip(BuildContext context, dynamic reaction) {
    return GestureDetector(
      onTap: () => _toggleReaction(context, reaction.emoji),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF3F3F3F)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reaction.emoji,
              style: const TextStyle(fontSize: 12),
            ),
            if (reaction.userIds.length > 1) ...[
              const SizedBox(width: 2),
              Text(
                '${reaction.userIds.length}',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark 
                      ? Colors.white70
                      : Colors.grey[700],
                  fontFamily: AppConstants.fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddReactionButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReactionPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF3F3F3F)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Icon(
          Icons.add_reaction_outlined,
          size: 14,
          color: isDark 
              ? Colors.white54
              : Colors.grey[600],
        ),
      ),
    );
  }

  /// Show reaction picker dialog
  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReactionPickerSheet(context),
    );
  }

  Widget _buildReactionPickerSheet(BuildContext context) {
    const commonReactions = [
      '👍', '❤️', '😂', '😮', '😢', '😡',
      '🔥', '👏', '🎉', '💯', '👀', '🚀'
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2F2F2F) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            'Add Reaction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF2F2F2F),
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          
          // Quick reactions
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: commonReactions.length,
            itemBuilder: (context, index) {
              final emoji = commonReactions[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _addReaction(emoji);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Message actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               _buildActionButton(
                 context: context,
                 icon: Icons.reply,
                 label: 'Reply',
                 onTap: () {
                   Navigator.pop(context);
                   onReply?.call();
                 },
               ),
                             if (isMe) _buildActionButton(
                 context: context,
                 icon: Icons.edit,
                 label: 'Edit',
                 onTap: () {
                   Navigator.pop(context);
                   onEdit?.call();
                 },
               ),
                             if (isMe) _buildActionButton(
                 context: context,
                 icon: Icons.delete,
                 label: 'Delete',
                 onTap: () {
                   Navigator.pop(context);
                   onDelete?.call();
                 },
               ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3F3F3F) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white70 : Colors.grey[700],
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.grey[600],
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  void _addReaction(String emoji) {
    onReact?.call(emoji);
  }

  void _toggleReaction(BuildContext context, String emoji) {
    // Show snackbar for demo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Toggled reaction: $emoji'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
    onReact?.call(emoji);
  }

  /// Get simple user color
  Color _getUserColor() {
    final colors = [
      AppColors.primaryColor,
      const Color(0xFF34C759),
      const Color(0xFFFF9500),
      const Color(0xFF5856D6),
      const Color(0xFFFF3B30),
      const Color(0xFF007AFF),
      const Color(0xFF32D74B),
      const Color(0xFFFFCC00),
    ];
    
    final index = message.senderId.hashCode % colors.length;
    return colors[index.abs()];
  }

  /// Show message options
  void _showMessageOptions() {
    // Implementation would show a modal with options
  }

  /// Format timestamp
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
