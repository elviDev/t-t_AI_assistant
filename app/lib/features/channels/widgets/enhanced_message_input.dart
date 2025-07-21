// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/user.dart';
import '../../../providers/voice_provider.dart';

/// Enhanced message input widget with mention support and Slack-like features
class EnhancedMessageInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;
  final Function(String) onSendMessage;
  final Function(String)? onSendAIPrompt;
  final VoidCallback? onAttachFile;
  final VoidCallback? onSendVoiceMessage;
  final List<User> channelMembers;
  final String? placeholder;

  const EnhancedMessageInput({
    super.key,
    required this.controller,
    required this.isDark,
    required this.onSendMessage,
    this.onSendAIPrompt,
    this.onAttachFile,
    this.onSendVoiceMessage,
    this.channelMembers = const [],
    this.placeholder,
  });

  @override
  State<EnhancedMessageInput> createState() => _EnhancedMessageInputState();
}

class _EnhancedMessageInputState extends State<EnhancedMessageInput>
    with TickerProviderStateMixin {
  bool _hasText = false;
  bool _isAIMode = false;
  bool _showMentionSuggestions = false;
  List<User> _mentionSuggestions = [];
  String _currentMentionQuery = '';
  int _mentionStartIndex = -1;
  late AnimationController _suggestionsController;
  late AnimationController _aiModeController;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _suggestionsController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _aiModeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _suggestionsController.dispose();
    _aiModeController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }

    _handleMentionDetection();
  }

  void _handleMentionDetection() {
    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;
    
    if (cursorPosition < 0) return;

    // Find if we're typing a mention
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');
    
    if (lastAtIndex != -1) {
      final afterAt = beforeCursor.substring(lastAtIndex + 1);
      
      // Check if there's no space after @
      if (!afterAt.contains(' ') && !afterAt.contains('\n')) {
        _mentionStartIndex = lastAtIndex;
        _currentMentionQuery = afterAt.toLowerCase();
        _updateMentionSuggestions();
        
        if (!_showMentionSuggestions) {
          _showMentionSuggestions = true;
          _showSuggestionsOverlay();
        }
        return;
      }
    }
    
    // Hide suggestions if not typing a mention
    if (_showMentionSuggestions) {
      _hideMentionSuggestions();
    }
  }

  void _updateMentionSuggestions() {
    final suggestions = widget.channelMembers
        .where((user) => user.name.toLowerCase().contains(_currentMentionQuery))
        .take(5)
        .toList();
    
    setState(() {
      _mentionSuggestions = suggestions;
    });
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -200),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppConstants.spacing12),
            color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: AnimatedBuilder(
              animation: _suggestionsController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _suggestionsController.value,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                                         decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(AppConstants.spacing12),
                       border: Border.all(
                         color: widget.isDark 
                             ? Colors.white.withValues(alpha: 0.1)
                             : Colors.black.withValues(alpha: 0.08),
                       ),
                     ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.spacing8),
                      shrinkWrap: true,
                      itemCount: _mentionSuggestions.length,
                      itemBuilder: (context, index) {
                        final user = _mentionSuggestions[index];
                        return _buildMentionSuggestionTile(user);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
    _suggestionsController.forward();
  }

  Widget _buildMentionSuggestionTile(User user) {
    return InkWell(
      onTap: () => _selectMention(user),
      borderRadius: BorderRadius.circular(AppConstants.spacing8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing12,
          vertical: AppConstants.spacing8,
        ),
        child: Row(
          children: [
            // User avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: _getUserGradient(user.id),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacing12),
            
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                  if (user.title != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.title!,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDark 
                            ? AppColors.darkTextSecondary 
                            : AppColors.lightTextSecondary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Online status
            if (user.isOnline)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _selectMention(User user) {
    final text = widget.controller.text;
    final newText = text.substring(0, _mentionStartIndex) + 
                   '@${user.name} ' + 
                   text.substring(widget.controller.selection.baseOffset);
    
    final newCursorPosition = _mentionStartIndex + user.name.length + 2;
    
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
    
    _hideMentionSuggestions();
  }

  void _hideMentionSuggestions() {
    if (_showMentionSuggestions) {
      setState(() {
        _showMentionSuggestions = false;
      });
      _suggestionsController.reverse().then((_) {
        _removeOverlay();
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: _isAIMode 
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : widget.isDark 
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08),
            ),
          ),
        ),
        child: Column(
          children: [
            // AI Mode indicator
            if (_isAIMode)
              Container(
                margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacing12,
                  vertical: AppConstants.spacing6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.spacing16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppConstants.spacing6),
                    Text(
                      'AI Assistant Mode',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Additional actions
                _buildActionButton(
                  icon: Icons.attach_file_rounded,
                  onTap: widget.onAttachFile,
                  tooltip: 'Adjuntar archivo',
                ),
                
                const SizedBox(width: AppConstants.spacing8),
                
                _buildActionButton(
                  icon: Icons.emoji_emotions_outlined,
                  onTap: _showEmojiPicker,
                  tooltip: 'Añadir emoji',
                ),
                
                const SizedBox(width: AppConstants.spacing8),
                
                // AI Mode toggle
                if (widget.onSendAIPrompt != null)
                  _buildActionButton(
                    icon: _isAIMode ? Icons.psychology : Icons.psychology_outlined,
                    onTap: _toggleAIMode,
                    tooltip: _isAIMode ? 'Desactivar modo AI' : 'Activar modo AI',
                    isActive: _isAIMode,
                  ),
                
                const SizedBox(width: AppConstants.spacing12),
                
                // Text input
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    decoration: BoxDecoration(
                      color: _isAIMode
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : widget.isDark 
                              ? AppColors.darkBackground 
                              : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(AppConstants.spacing20),
                      border: Border.all(
                        color: _isAIMode
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : widget.isDark 
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                        fontFamily: AppConstants.fontFamily,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: _isAIMode 
                            ? 'Pregunta al AI Assistant...' 
                            : widget.placeholder ?? 'Escribe un mensaje...',
                        hintStyle: TextStyle(
                          color: widget.isDark 
                              ? AppColors.darkTextSecondary 
                              : AppColors.lightTextSecondary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacing16,
                          vertical: AppConstants.spacing12,
                        ),
                      ),
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          _handleSubmit(text);
                        }
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: AppConstants.spacing12),
                
                // Send button or voice button
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _hasText 
                      ? _buildSendButton()
                      : _buildVoiceButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle AI mode
  void _toggleAIMode() {
    setState(() {
      _isAIMode = !_isAIMode;
    });
    
    if (_isAIMode) {
      _aiModeController.forward();
    } else {
      _aiModeController.reverse();
    }
  }

  /// Handle submit (either regular message or AI prompt)
  void _handleSubmit(String text) {
    if (_isAIMode && widget.onSendAIPrompt != null) {
      widget.onSendAIPrompt!(text);
    } else {
      widget.onSendMessage(text);
    }
    _hideMentionSuggestions();
  }

  /// Build action button
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.spacing8),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacing8),
          decoration: isActive ? BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.spacing8),
          ) : null,
          child: Icon(
            icon,
            size: 22,
            color: isActive 
                ? AppColors.primary
                : widget.isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  /// Build send button
  Widget _buildSendButton() {
    return Container(
      key: const ValueKey('send'),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: _isAIMode 
            ? LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
              )
            : AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.controller.text.trim().isNotEmpty) {
              _handleSubmit(widget.controller.text);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Icon(
            _isAIMode ? Icons.psychology : Icons.send_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Build voice button with speech-to-text integration
  Widget _buildVoiceButton() {
    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, child) {
        final isListening = voiceProvider.isListening;
        
        return Container(
          key: const ValueKey('voice'),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isListening
                ? AppColors.primary.withValues(alpha: 0.15)
                : widget.isDark 
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.1)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: isListening ? Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleVoiceInput(voiceProvider),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isListening ? Icons.stop_rounded : Icons.mic_rounded,
                  key: ValueKey(isListening),
                  color: isListening
                      ? AppColors.primary
                      : widget.isDark 
                          ? AppColors.darkTextSecondary 
                          : AppColors.lightTextSecondary,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show emoji picker
  void _showEmojiPicker() {
    // Implementation for emoji picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selector de emojis próximamente!')),
    );
  }

  /// Handle voice input with speech-to-text
  Future<void> _handleVoiceInput(VoiceProvider voiceProvider) async {
    if (voiceProvider.isListening) {
      // Stop listening
      await voiceProvider.stopListening();
    } else {
      // Start listening
      await voiceProvider.startListening(
        onResult: (result) {
          // Update the text field with the speech result
          if (result.isNotEmpty) {
            widget.controller.text = result;
            _hasText = true;
            setState(() {});
          }
        },
        timeout: const Duration(seconds: 30),
      );
    }
    
    // Call the optional callback
    widget.onSendVoiceMessage?.call();
  }

  /// Get user-specific gradient
  LinearGradient _getUserGradient(String userId) {
    final gradients = [
      AppColors.primaryGradient,
      const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
      const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
      const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFF7C3AED)]),
      const LinearGradient(colors: [Color(0xFFF87171), Color(0xFFEF4444)]),
    ];
    
    final index = userId.hashCode % gradients.length;
    return gradients[index.abs()];
  }
} 