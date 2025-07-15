import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/channel.dart';
import '../../models/message.dart';
import '../../shared/widgets/voice_prompt_widget.dart';
import 'widgets/message_bubble.dart';
import 'widgets/channel_header.dart';
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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<Message> _messages = [];
  bool _isLoading = false;
  bool _isVoiceRecording = false;

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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Channel header with info
            ChannelHeader(
              channel: widget.channel,
              isDark: isDark,
            ),
            
            // Messages list
            Expanded(
              child: _buildMessagesList(isDark),
            ),
            
            // Voice prompt for AI assistance
            Container(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              child: VoicePromptWidget(
                onPromptSubmitted: _handleAIPrompt,
                onVoicePressed: _toggleVoiceRecording,
                isListening: _isVoiceRecording,
              ),
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

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.channel.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          Text(
            '${widget.channel.memberIds.length} members',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.video_call_rounded,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: _startVideoCall,
        ),
        IconButton(
          icon: Icon(
            Icons.call_rounded,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: _startAudioCall,
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDark ? AppColors.darkText : AppColors.lightText,
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
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            const SizedBox(height: AppConstants.spacing16),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            const SizedBox(height: AppConstants.spacing8),
            Text(
              'Start the conversation by sending a message',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontFamily: AppConstants.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.spacing16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == 'current_user'; // Mock current user
        
        return MessageBubble(
          message: message,
          isMe: isMe,
          isDark: isDark,
          onReact: (reaction) => _reactToMessage(message.id, reaction),
          onReply: () => _replyToMessage(message),
          onEdit: isMe ? () => _editMessage(message) : null,
          onDelete: isMe ? () => _deleteMessage(message.id) : null,
        );
      },
    );
  }

  /// Initialize sample messages
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
            content: 'Hey everyone! Welcome to the ${widget.channel.name} channel. Let\'s brainstorm some ideas for our upcoming project.',
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
            content: 'That sounds like a good plan. I can work on the technical architecture while you handle the UI design.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
            type: MessageType.text,
          ),
        ];
        _isLoading = false;
      });
    });
  }

  /// Send a text message
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
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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
              color: isDark ? AppColors.darkText : AppColors.lightText,
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
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle AI prompt
  void _handleAIPrompt(String prompt) {
    // Simulate AI processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI is processing: "$prompt"'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  /// Toggle voice recording
  void _toggleVoiceRecording() {
    setState(() {
      _isVoiceRecording = !_isVoiceRecording;
    });
    
    if (_isVoiceRecording) {
      // Start voice recording
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isVoiceRecording) {
          _toggleVoiceRecording();
          _handleAIPrompt('Create a task for mobile app development');
        }
      });
    }
  }

  /// React to message
  void _reactToMessage(String messageId, String reaction) {
    // Implementation for message reactions
  }

  /// Reply to message
  void _replyToMessage(Message message) {
    // Implementation for message replies
  }

  /// Edit message
  void _editMessage(Message message) {
    // Implementation for message editing
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
