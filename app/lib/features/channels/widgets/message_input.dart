import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Message input widget for typing and sending messages
class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;
  final Function(String) onSendMessage;
  final VoidCallback? onAttachFile;
  final VoidCallback? onSendVoiceMessage;

  const MessageInput({
    super.key,
    required this.controller,
    required this.isDark,
    required this.onSendMessage,
    this.onAttachFile,
    this.onSendVoiceMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: widget.isDark 
                ? AppColors.darkTextSecondary.withOpacity(0.1)
                : AppColors.lightTextSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Attach file button
          IconButton(
            onPressed: widget.onAttachFile,
            icon: Icon(
              Icons.attach_file,
              color: widget.isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
            ),
          ),
          
          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: widget.isDark 
                    ? AppColors.darkBackground 
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                border: Border.all(
                  color: widget.isDark 
                      ? AppColors.darkTextSecondary.withOpacity(0.2)
                      : AppColors.lightTextSecondary.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: widget.controller,
                maxLines: null,
                style: TextStyle(
                  color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                  fontFamily: AppConstants.fontFamily,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
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
                    widget.onSendMessage(text);
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(width: AppConstants.spacing8),
          
          // Send button or voice button
          AnimatedSwitcher(
            duration: AppConstants.shortAnimationDuration,
            child: _hasText 
                ? _buildSendButton()
                : _buildVoiceButton(),
          ),
        ],
      ),
    );
  }

  /// Build send button
  Widget _buildSendButton() {
    return Container(
      key: const ValueKey('send'),
      width: AppConstants.floatingButtonSize,
      height: AppConstants.floatingButtonSize,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.controller.text.trim().isNotEmpty) {
              widget.onSendMessage(widget.controller.text);
            }
          },
          borderRadius: BorderRadius.circular(AppConstants.floatingButtonSize / 2),
          child: const Icon(
            Icons.send_rounded,
            color: Colors.white,
            size: AppConstants.mediumIconSize,
          ),
        ),
      ),
    );
  }

  /// Build voice button
  Widget _buildVoiceButton() {
    return Container(
      key: const ValueKey('voice'),
      width: AppConstants.floatingButtonSize,
      height: AppConstants.floatingButtonSize,
      decoration: BoxDecoration(
        color: widget.isDark 
            ? AppColors.darkBackground 
            : AppColors.lightBackground,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.isDark 
              ? AppColors.darkTextSecondary.withOpacity(0.2)
              : AppColors.lightTextSecondary.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onSendVoiceMessage,
          borderRadius: BorderRadius.circular(AppConstants.floatingButtonSize / 2),
          child: Icon(
            Icons.mic,
            color: widget.isDark 
                ? AppColors.darkTextSecondary 
                : AppColors.lightTextSecondary,
            size: AppConstants.mediumIconSize,
          ),
        ),
      ),
    );
  }
}
