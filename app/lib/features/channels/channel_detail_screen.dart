import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/channel.dart';
import '../../models/message.dart';
import '../../shared/services/notification_service.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

/// Channel detail screen for messaging and collaboration
class ChannelDetailScreen extends StatefulWidget {
  final Channel channel;

  const ChannelDetailScreen({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<Message> _messages = [];
  bool _isLoading = false;

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
    _initializeMessages();
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: _buildMessagesList(isDark),
            ),
            
            // Message input
            MessageInput(
              controller: _messageController,
              isDark: isDark,
              onSendMessage: _sendMessage,
              onAttachFile: _attachFile,
              onSendVoiceMessage: _sendVoiceMessage,
            ),
          ],
        ),
      ),
    );
  }

  /// Build simple, modern app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1C1C1C) : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : const Color(0xFF2F2F2F),
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          // Channel avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.channel.name.isNotEmpty 
                    ? widget.channel.name[0].toUpperCase() 
                    : '#',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.channel.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2F2F2F),
                    fontFamily: AppConstants.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${widget.channel.memberIds.length} members',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.videocam,
            color: isDark ? Colors.white70 : Colors.grey[700],
            size: 22,
          ),
          onPressed: _startVideoCall,
        ),
        IconButton(
          icon: Icon(
            Icons.call,
            color: isDark ? Colors.white70 : Colors.grey[700],
            size: 20,
          ),
          onPressed: _startAudioCall,
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDark ? Colors.white70 : Colors.grey[700],
            size: 20,
          ),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'members',
              child: Text('View Members'),
            ),
            const PopupMenuItem(
              value: 'files',
              child: Text('Files & Media'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Channel Settings'),
            ),
            const PopupMenuItem(
              value: 'leave',
              child: Text('Leave Channel'),
            ),
          ],
        ),
      ],
    );
  }

  /// Build messages list
  Widget _buildMessagesList(bool isDark) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: isDark ? Colors.white24 : Colors.grey[400],
            ),
            const SizedBox(height: AppConstants.spacing16),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : Colors.grey[600],
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            const SizedBox(height: AppConstants.spacing8),
            Text(
              'Start the conversation',
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

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == 'current_user'; // Mock current user
        
        return MessageBubble(
          message: message,
          isMe: isMe,
          isDark: isDark,
          onReact: (reaction) => _reactToMessage(message.id, reaction, message),
          onReply: () => _replyToMessage(message),
          onEdit: isMe ? () => _editMessage(message) : null,
          onDelete: isMe ? () => _deleteMessage(message.id) : null,
        );
      },
    );
  }

  /// Initialize sample messages with mentions
  void _initializeMessages() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading messages
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages = [
          Message(
            id: '1',
            senderId: 'user1',
            senderName: 'Alice Johnson',
            content: 'Hey everyone! Welcome to the ${widget.channel.name} channel. @Bob Smith let\'s brainstorm some ideas for our upcoming project.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: MessageType.text,
          ),
          Message(
            id: '2',
            senderId: 'current_user',
            senderName: 'You',
            content: 'Great! I have some initial thoughts about the user interface design. Should we start with wireframes?',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
            type: MessageType.text,
          ),
          Message(
            id: '3',
            senderId: 'user2',
            senderName: 'Bob Smith',
            content: 'That sounds like a good plan @Alice Johnson. I can work on the technical architecture while you handle the UI design.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
            type: MessageType.text,
          ),
        ];
        _isLoading = false;
      });
    });
  }

  /// Send a text message with mention detection
  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      senderName: 'You',
      content: content.trim(),
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    _scrollToBottom();

    // Check for mentions in the message and send notifications
    _checkForMentionsAndNotify(content);
    
    // Check for task assignments (demo feature)
    _checkForTaskAssignments(content);
  }

  /// Check for mentions in message and send notifications
  void _checkForMentionsAndNotify(String content) {
    final RegExp mentionRegex = RegExp(r'@(\w+(?:\s+\w+)*)');
    final matches = mentionRegex.allMatches(content);
    
    for (final match in matches) {
      final mentionedName = match.group(1);
      if (mentionedName != null && mentionedName != 'You') {
        // Send mention notification
        _notificationService.sendMentionNotification(
          mentionedUserId: 'user_${mentionedName.hashCode}',
          mentionedUserName: mentionedName,
          senderName: 'You',
          channelName: widget.channel.name,
          messageContent: content,
        );
      }
    }
  }

  /// Check for task assignments and send notifications (demo)
  void _checkForTaskAssignments(String content) {
    // Simple task assignment pattern: "assign @UserName: TaskDescription"
    final RegExp taskAssignRegex = RegExp(r'assign\s+@(\w+(?:\s+\w+)*)\s*:\s*(.+)', caseSensitive: false);
    final match = taskAssignRegex.firstMatch(content);
    
    if (match != null) {
      final assignedUserName = match.group(1);
      final taskDescription = match.group(2);
      
      if (assignedUserName != null && taskDescription != null) {
        // Send task assignment notification
        _notificationService.sendTaskAssignmentNotification(
          assignedUserId: 'user_${assignedUserName.hashCode}',
          assignedUserName: assignedUserName,
          assigner: 'You',
          taskTitle: taskDescription.trim(),
          channelName: widget.channel.name,
          dueDate: DateTime.now().add(const Duration(days: 3)), // Demo due date
        );
        
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Task assigned to $assignedUserName: ${taskDescription.trim()}'),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  /// Send a voice message
  void _sendVoiceMessage() {
    // Implementation for voice message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice message feature coming soon!')),
    );
  }

  /// Attach a file
  void _attachFile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentOptions(),
    );
  }

  /// Build attachment options
  Widget _buildAttachmentOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2F2F2F) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.largeBorderRadius),
          topRight: Radius.circular(AppConstants.largeBorderRadius),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.spacing24),
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
          const SizedBox(height: AppConstants.spacing24),
          
          // Title
          Text(
            'Attach File',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2F2F2F),
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          
          // Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {},
                isDark: isDark,
              ),
              _buildAttachmentOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {},
                isDark: isDark,
              ),
              _buildAttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'File',
                onTap: () {},
                isDark: isDark,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacing24),
        ],
      ),
    );
  }

  /// Build attachment option
  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.spacing16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : const Color(0xFF2F2F2F),
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  /// React to message with notification
  void _reactToMessage(String messageId, String reaction, Message message) {
    // Find the message and add reaction (simplified for demo)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added reaction: $reaction'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Send reaction notification if it's not your own message
    if (message.senderId != 'current_user') {
      _notificationService.sendReactionNotification(
        userId: message.senderId,
        userName: message.senderName,
        reactor: 'You',
        emoji: reaction,
        channelName: widget.channel.name,
        messageContent: message.content,
      );
    }
  }

  /// Reply to message
  void _replyToMessage(Message message) {
    // Implementation for message replies
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reply feature coming soon!')),
    );
  }

  /// Edit message
  void _editMessage(Message message) {
    // Implementation for message editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit feature coming soon!')),
    );
  }

  /// Delete message
  void _deleteMessage(String messageId) {
    setState(() {
      _messages.removeWhere((message) => message.id == messageId);
    });
  }

  /// Start video call
  void _startVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video call feature coming soon!')),
    );
  }

  /// Start audio call
  void _startAudioCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio call feature coming soon!')),
    );
  }

  /// Handle menu actions
  void _handleMenuAction(String action) {
    switch (action) {
      case 'members':
        // Show members
        break;
      case 'files':
        // Show files and media
        break;
      case 'settings':
        // Show channel settings
        break;
      case 'leave':
        // Leave channel
        break;
    }
  }

  /// Scroll to bottom of messages
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.animationDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }
}
