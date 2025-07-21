import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/message.dart';
import '../../../models/user.dart';

/// Enhanced message bubble widget with Slack-like features
class EnhancedMessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;
  final bool isDark;
  final Function(String)? onReact;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onMentionTap;
  final List<User> channelMembers;
  final String? channelCategory;

  const EnhancedMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isDark = false,
    this.onReact,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onMentionTap,
    this.channelMembers = const [],
    this.channelCategory,
  });

  @override
  State<EnhancedMessageBubble> createState() => _EnhancedMessageBubbleState();
}

class _EnhancedMessageBubbleState extends State<EnhancedMessageBubble>
    with TickerProviderStateMixin {
  bool _showReactionPicker = false;
  late AnimationController _reactionController;

  @override
  void initState() {
    super.initState();
    _reactionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _reactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message content with hover effects
          MouseRegion(
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: GestureDetector(
              onLongPress: _showMessageOptions,
              child: Row(
                mainAxisAlignment: widget.isMe 
                    ? MainAxisAlignment.end 
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isMe) ...[
                    _buildAvatar(),
                    const SizedBox(width: AppConstants.spacing12),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: widget.isMe 
                          ? CrossAxisAlignment.end 
                          : CrossAxisAlignment.start,
                      children: [
                        _buildMessageContent(),
                      ],
                    ),
                  ),
                  if (widget.isMe) ...[
                    const SizedBox(width: AppConstants.spacing12),
                    _buildAvatar(),
                  ],
                ],
              ),
            ),
          ),
          
          // Reactions with improved design
          if (widget.message.reactions.isNotEmpty) 
            _buildEnhancedReactions(),
            
          // Quick reaction picker
          if (_showReactionPicker)
            _buildReactionPicker(),
        ],
      ),
    );
  }

  /// Build enhanced user avatar
  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: _getUserGradient(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.message.senderName.isNotEmpty 
              ? widget.message.senderName[0].toUpperCase() 
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Build enhanced message content
  Widget _buildMessageContent() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        gradient: widget.isMe ? AppColors.primaryGradient : null,
        color: widget.isMe 
            ? null 
            : widget.isDark 
                ? AppColors.darkSurface 
                : AppColors.lightSurface,
        borderRadius: _getMessageBorderRadius(),
        border: !widget.isMe ? Border.all(
          color: widget.isDark 
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.08),
          width: 1,
        ) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender name and timestamp
          if (!widget.isMe) ...[
            Row(
              children: [
                Text(
                  widget.message.senderName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getUserColor(),
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                const SizedBox(width: AppConstants.spacing8),
                Text(
                  _formatTime(widget.message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: widget.isDark 
                        ? AppColors.darkTextSecondary 
                        : AppColors.lightTextSecondary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacing6),
          ],
          
          // Message content with mentions
          _buildMessageTextWithMentions(),
          
          // Actions bar (reply, reactions)
          const SizedBox(height: AppConstants.spacing8),
          _buildMessageActions(),
        ],
      ),
    );
  }

  /// Build message text with clickable mentions
  Widget _buildMessageTextWithMentions() {
    final text = widget.message.content;
    final mentionRegex = RegExp(r'@(\w+)');
    final matches = mentionRegex.allMatches(text);
    
    if (matches.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: widget.isMe 
              ? Colors.white 
              : widget.isDark 
                  ? AppColors.darkText 
                  : AppColors.lightText,
          fontFamily: AppConstants.fontFamily,
          height: 1.4,
        ),
      );
    }

    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add text before mention
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            fontSize: 15,
            color: widget.isMe 
                ? Colors.white 
                : widget.isDark 
                    ? AppColors.darkText 
                    : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
            height: 1.4,
          ),
        ));
      }

      // Add mention with styling
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          fontSize: 15,
          color: widget.isMe ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
          height: 1.4,
          decoration: TextDecoration.none,
          backgroundColor: widget.isMe 
              ? Colors.white.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.1),
        ),
        recognizer: widget.onMentionTap != null
            ? (TapGestureRecognizer()
                ..onTap = () => widget.onMentionTap!(match.group(1)!))
            : null,
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          fontSize: 15,
          color: widget.isMe 
              ? Colors.white 
              : widget.isDark 
                  ? AppColors.darkText 
                  : AppColors.lightText,
          fontFamily: AppConstants.fontFamily,
          height: 1.4,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  /// Build message actions
  Widget _buildMessageActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timestamp for own messages
        if (widget.isMe) ...[
          Text(
            _formatTime(widget.message.timestamp),
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          if (widget.message.isEdited) ...[
            const SizedBox(width: AppConstants.spacing4),
            Text(
              '(editado)',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ],
        ],
        
        const Spacer(),
        
        // Quick actions
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickActionButton(
              icon: Icons.add_reaction_outlined,
              onTap: _toggleReactionPicker,
              tooltip: 'Añadir reacción',
            ),
            const SizedBox(width: AppConstants.spacing4),
            _buildQuickActionButton(
              icon: Icons.reply_outlined,
              onTap: widget.onReply,
              tooltip: 'Responder',
            ),
            if (widget.isMe) ...[
              const SizedBox(width: AppConstants.spacing4),
              _buildQuickActionButton(
                icon: Icons.more_horiz,
                onTap: _showMessageOptions,
                tooltip: 'Más opciones',
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Build quick action button
  Widget _buildQuickActionButton({
    required IconData icon,
    required VoidCallback? onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.spacing4),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing4),
          child: Icon(
            icon,
            size: 16,
            color: widget.isMe 
                ? Colors.white.withValues(alpha: 0.8) 
                : widget.isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  /// Build enhanced reactions with hover effects
  Widget _buildEnhancedReactions() {
    return Container(
      margin: EdgeInsets.only(
        top: AppConstants.spacing8,
        left: widget.isMe ? 0 : 48,
      ),
      child: Wrap(
        spacing: AppConstants.spacing6,
        runSpacing: AppConstants.spacing4,
        children: widget.message.reactions.map((reaction) {
          final hasUserReacted = reaction.userIds.contains('current_user');
          
          return GestureDetector(
            onTap: () => widget.onReact?.call(reaction.emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing8,
                vertical: AppConstants.spacing4,
              ),
              decoration: BoxDecoration(
                color: hasUserReacted
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : widget.isDark 
                        ? AppColors.darkBackground 
                        : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(AppConstants.spacing12),
                border: Border.all(
                  color: hasUserReacted
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : widget.isDark 
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.08),
                  width: hasUserReacted ? 1.5 : 1,
                ),
                boxShadow: hasUserReacted ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    reaction.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: AppConstants.spacing4),
                  Text(
                    '${reaction.userIds.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: hasUserReacted ? FontWeight.w600 : FontWeight.normal,
                      color: hasUserReacted
                          ? AppColors.primary
                          : widget.isDark 
                              ? AppColors.darkTextSecondary 
                              : AppColors.lightTextSecondary,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build reaction picker
  Widget _buildReactionPicker() {
    final commonReactions = ['👍', '❤️', '😂', '😮', '😢', '😡', '🎉', '👏'];
    
    return AnimatedBuilder(
      animation: _reactionController,
      builder: (context, child) {
        return Transform.scale(
          scale: _reactionController.value,
          child: Container(
            margin: EdgeInsets.only(
              top: AppConstants.spacing8,
              left: widget.isMe ? 0 : 48,
            ),
            padding: const EdgeInsets.all(AppConstants.spacing8),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(_shouldUseSpecialStyling() ? 16 : AppConstants.spacing16),
              border: Border.all(
                color: widget.isDark 
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: commonReactions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    widget.onReact?.call(emoji);
                    _toggleReactionPicker();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.all(AppConstants.spacing8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.spacing8),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// Toggle reaction picker
  void _toggleReactionPicker() {
    setState(() {
      _showReactionPicker = !_showReactionPicker;
    });
    
    if (_showReactionPicker) {
      _reactionController.forward();
    } else {
      _reactionController.reverse();
    }
  }

  /// Show message options
  void _showMessageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppConstants.spacing16),
            topRight: Radius.circular(AppConstants.spacing16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionTile(
              icon: Icons.reply,
              title: 'Responder',
              onTap: () {
                Navigator.pop(context);
                widget.onReply?.call();
              },
            ),
            _buildOptionTile(
              icon: Icons.add_reaction_outlined,
              title: 'Añadir reacción',
              onTap: () {
                Navigator.pop(context);
                _toggleReactionPicker();
              },
            ),
            if (widget.isMe) ...[
              _buildOptionTile(
                icon: Icons.edit,
                title: 'Editar mensaje',
                onTap: () {
                  Navigator.pop(context);
                  widget.onEdit?.call();
                },
              ),
              _buildOptionTile(
                icon: Icons.delete,
                title: 'Eliminar mensaje',
                onTap: () {
                  Navigator.pop(context);
                  widget.onDelete?.call();
                },
                isDestructive: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build option tile for bottom sheet
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive 
            ? Colors.red 
            : widget.isDark 
                ? AppColors.darkText 
                : AppColors.lightText,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive 
              ? Colors.red 
              : widget.isDark 
                  ? AppColors.darkText 
                  : AppColors.lightText,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
      onTap: onTap,
    );
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
    
    final index = widget.message.senderId.hashCode % gradients.length;
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
    
    final index = widget.message.senderId.hashCode % colors.length;
    return colors[index.abs()];
  }

  /// Check if channel should use special styling (16px border radius)
  bool _shouldUseSpecialStyling() {
    final specialCategories = ['development', 'marketing', 'events', 'finance'];
    return widget.channelCategory != null && 
        specialCategories.contains(widget.channelCategory!.toLowerCase());
  }

  /// Get message border radius based on channel category
  BorderRadius _getMessageBorderRadius() {
    if (_shouldUseSpecialStyling()) {
      // Use 16px border radius for special categories
      return BorderRadius.circular(16);
    } else {
      // Use default chat bubble style
      return BorderRadius.only(
        topLeft: const Radius.circular(AppConstants.spacing16),
        topRight: const Radius.circular(AppConstants.spacing16),
        bottomLeft: Radius.circular(widget.isMe ? AppConstants.spacing16 : AppConstants.spacing4),
        bottomRight: Radius.circular(widget.isMe ? AppConstants.spacing4 : AppConstants.spacing16),
      );
    }
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