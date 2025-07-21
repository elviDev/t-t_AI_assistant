import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/channel.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import 'widgets/enhanced_message_bubble.dart';
import 'widgets/enhanced_message_input.dart';
import 'widgets/channel_templates.dart';

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
  List<User> _channelMembers = [];
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Enhanced channel header with theme and back button
            EnhancedChannelHeader(
              channel: widget.channel,
              isDark: isDark,
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            
            // Messages list
            Expanded(
              child: _buildMessagesList(isDark),
            ),
            
            // Enhanced message input with mentions and AI handling
            EnhancedMessageInput(
              controller: _messageController,
              isDark: isDark,
              onSendMessage: _sendMessage,
              onSendAIPrompt: _handleAIPrompt,
              onAttachFile: _attachFile,
              onSendVoiceMessage: _sendVoiceMessage,
              channelMembers: _channelMembers,
              placeholder: ChannelTemplates.getPlaceholderText(widget.channel.category),
            ),
          ],
        ),
      ),
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
        
        return EnhancedMessageBubble(
          message: message,
          isMe: isMe,
          isDark: isDark,
          onReact: (reaction) => _reactToMessage(message.id, reaction),
          onReply: () => _replyToMessage(message),
          onEdit: isMe ? () => _editMessage(message) : null,
          onDelete: isMe ? () => _deleteMessage(message.id) : null,
          onMentionTap: _handleMentionTap,
          channelMembers: _channelMembers,
          channelCategory: widget.channel.category,
        );
      },
    );
  }

  /// Initialize sample messages and channel members
  void _initializeMessages() {
    setState(() {
      _isLoading = true;
    });

    // Initialize channel members
    _channelMembers = [
      User(
        id: 'user1',
        name: 'Carlos Morales',
        email: 'carlos@example.com',
        avatar: '',
        title: 'Frontend Developer',
        isOnline: true,
      ),
      User(
        id: 'user2',
        name: 'Ana Rodriguez',
        email: 'ana@example.com',
        avatar: '',
        title: 'UX Designer',
        isOnline: true,
      ),
      User(
        id: 'user3',
        name: 'Pedro Sánchez',
        email: 'pedro@example.com',
        avatar: '',
        title: 'Marketing Manager',
        isOnline: false,
      ),
      User(
        id: 'user4',
        name: 'María González',
        email: 'maria@example.com',
        avatar: '',
        title: 'Project Manager',
        isOnline: true,
      ),
      User(
        id: 'user5',
        name: 'Laura Jiménez',
        email: 'laura@example.com',
        avatar: '',
        title: 'HR Manager',
        isOnline: false,
      ),
    ];

    // Simulate loading messages
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        // Use template messages based on channel category
        _messages = ChannelTemplates.getTemplateMessages(widget.channel.category);
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.spacing12),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(AppConstants.spacing12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isDark ? AppColors.darkText : AppColors.lightText,
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
      ),
    );
  }

  /// Handle AI prompt submission
  void _handleAIPrompt(String prompt) {
    // Generate AI response and add to messages
    final aiResponse = _generateAIResponse(prompt);
    
    final aiMessage = Message(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'ai_assistant',
      senderName: 'AI Assistant',
      content: aiResponse,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
    
    setState(() {
      _messages.add(aiMessage);
    });
    
    _scrollToBottom();
  }

  /// Generate AI response based on prompt and channel context
  String _generateAIResponse(String prompt) {
    final category = widget.channel.category.toLowerCase();
    
    // Context-aware responses based on channel category
    switch (category) {
      case 'development':
        return _getDevAIResponse(prompt);
      case 'marketing':
        return _getMarketingAIResponse(prompt);
      case 'events':
        return _getEventsAIResponse(prompt);
      case 'finance':
        return _getFinanceAIResponse(prompt);
      default:
        return _getGeneralAIResponse(prompt);
    }
  }

  /// Development-specific AI responses
  String _getDevAIResponse(String prompt) {
    final responses = [
      '🚀 Para "$prompt", te sugiero revisar nuestra arquitectura actual y considerar implementar un patrón de design apropiado.',
      '💻 Basándome en "$prompt", recomiendo hacer code review del módulo relacionado y verificar las pruebas unitarias.',
      '⚡ Sobre "$prompt": podríamos optimizar el performance implementando lazy loading o memoization.',
      '🔧 Para resolver "$prompt", te ayudo con algunos snippets de código y mejores prácticas.',
      '📱 Considerando "$prompt", asegurémonos de que sea responsive y siga las guías de Material Design.',
    ];
    return responses[prompt.hashCode % responses.length];
  }

  /// Marketing-specific AI responses
  String _getMarketingAIResponse(String prompt) {
    final responses = [
      '📊 Respecto a "$prompt", analicemos las métricas actuales y definamos KPIs específicos para medir el éxito.',
      '🎯 Para "$prompt", sugiero segmentar la audiencia y crear contenido personalizado para cada grupo.',
      '📈 Sobre "$prompt": podríamos implementar A/B testing para optimizar la conversión.',
      '🎨 Considerando "$prompt", necesitamos crear creatividades que resuenen con nuestra brand voice.',
      '💡 Para "$prompt", analicemos la competencia y identifiquemos oportunidades de diferenciación.',
    ];
    return responses[prompt.hashCode % responses.length];
  }

  /// Events-specific AI responses
  String _getEventsAIResponse(String prompt) {
    final responses = [
      '🎉 Para "$prompt", coordinemos el calendario del equipo y definamos la logística necesaria.',
      '🌟 Sobre "$prompt": creemos una experiencia memorable que fortalezca los vínculos del equipo.',
      '🎪 Considerando "$prompt", podríamos organizar actividades que fomenten la colaboración y creatividad.',
      '🍕 Para "$prompt", planifiquemos la comida, el lugar y las actividades de forma inclusiva.',
      '📅 Respecto a "$prompt", asegurémonos de tener un plan B y comunicar todos los detalles al equipo.',
    ];
    return responses[prompt.hashCode % responses.length];
  }

  /// Finance-specific AI responses
  String _getFinanceAIResponse(String prompt) {
    final responses = [
      '💰 Sobre "$prompt", revisemos el presupuesto actual y analicemos el ROI de nuestras inversiones.',
      '📊 Para "$prompt", necesitamos datos más granulares para tomar decisiones financieras informadas.',
      '💎 Considerando "$prompt", evaluemos el costo-beneficio y el impacto en nuestros márgenes.',
      '📈 Respecto a "$prompt", analicemos las tendencias y proyecciones para el próximo trimestre.',
      '🎯 Para "$prompt", definamos métricas financieras claras y estabelezcan metas alcanzables.',
    ];
    return responses[prompt.hashCode % responses.length];
  }

  /// General AI responses
  String _getGeneralAIResponse(String prompt) {
    final responses = [
      '🤖 Entiendo tu consulta sobre "$prompt". Te ayudo a encontrar la mejor solución.',
      '💡 Basándome en "$prompt", aquí tienes algunas sugerencias y próximos pasos.',
      '🎯 Para resolver "$prompt", recomiendo coordinar con el equipo y revisar los recursos disponibles.',
      '📋 Sobre "$prompt": creemos un plan de acción con objetivos claros y timelines definidos.',
      '✨ Considerando "$prompt", exploremos diferentes enfoques y elijamos el más eficiente.',
    ];
    return responses[prompt.hashCode % responses.length];
  }



  /// React to message with enhanced logic
  void _reactToMessage(String messageId, String reaction) {
    setState(() {
      final messageIndex = _messages.indexWhere((m) => m.id == messageId);
      if (messageIndex != -1) {
        final message = _messages[messageIndex];
        final reactions = List<MessageReaction>.from(message.reactions);
        
        // Find existing reaction
        final existingReactionIndex = reactions.indexWhere((r) => r.emoji == reaction);
        
        if (existingReactionIndex != -1) {
          // Reaction exists, toggle user's reaction
          final existingReaction = reactions[existingReactionIndex];
          final userIds = List<String>.from(existingReaction.userIds);
          
          if (userIds.contains('current_user')) {
            // Remove user's reaction
            userIds.remove('current_user');
            if (userIds.isEmpty) {
              // Remove reaction completely if no users left
              reactions.removeAt(existingReactionIndex);
            } else {
              reactions[existingReactionIndex] = MessageReaction(
                emoji: reaction,
                userIds: userIds,
              );
            }
          } else {
            // Add user's reaction
            userIds.add('current_user');
            reactions[existingReactionIndex] = MessageReaction(
              emoji: reaction,
              userIds: userIds,
            );
          }
        } else {
          // New reaction
          reactions.add(MessageReaction(
            emoji: reaction,
            userIds: ['current_user'],
          ));
        }
        
        // Update message with new reactions
        _messages[messageIndex] = message.copyWith(reactions: reactions);
      }
    });
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



  /// Handle mention tap
  void _handleMentionTap(String username) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perfil de $username'),
        duration: const Duration(seconds: 2),
      ),
    );
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
