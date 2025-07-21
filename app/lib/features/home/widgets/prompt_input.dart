// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Message input widget for typing and sending messages
class PromptInput extends StatefulWidget {
  const PromptInput({super.key});

  @override
  State<PromptInput> createState() => _PromptInputState();
}

class _PromptInputState extends State<PromptInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isRecording = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
  }

  void _clearRecording() {
    setState(() => _isRecording = false);
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      print('Sending: ${_controller.text}');
      _controller.clear();
      setState(() {});
    }
  }

  void _attachFile() {
    // Handle file attachment
    print('File attachment pressed');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark 
                ? AppColors.darkTextSecondary.withOpacity(0.1)
                : AppColors.lightTextSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Attach file button
          IconButton(
            onPressed: _attachFile,
            icon: Icon(
              Icons.attach_file,
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
            ),
          ),
          
          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: isDark 
                    ? AppColors.darkBackground 
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                border: Border.all(
                  color: isDark 
                      ? AppColors.darkTextSecondary.withOpacity(0.2)
                      : AppColors.lightTextSecondary.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                style: TextStyle(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontFamily: AppConstants.fontFamily,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: isDark 
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
                    _sendMessage();
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(width: AppConstants.spacing8),
          
          // Send button or voice button
          AnimatedSwitcher(
            duration: AppConstants.shortAnimationDuration,
            child: _isRecording ? _buildRecordingControls() : 
                   _hasText ? _buildSendButton() : _buildVoiceButton(),
          ),
        ],
      ),
    );
  }

  /// Build recording controls
  Widget _buildRecordingControls() {
    return Row(
      key: const ValueKey('recording'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.pause, color: Colors.red),
            onPressed: _toggleRecording,
            iconSize: 20,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: _clearRecording,
            iconSize: 20,
          ),
        ),
      ],
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
          onTap: _sendMessage,
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
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleRecording,
          borderRadius: BorderRadius.circular(AppConstants.floatingButtonSize / 2),
          child: const Icon(
            Icons.mic,
            color: Colors.white,
            size: AppConstants.mediumIconSize,
          ),
        ),
      ),
    );
  }
}
