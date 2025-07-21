import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/voice_provider.dart';

/// Voice prompt widget for voice command input with real speech-to-text
class VoicePromptWidget extends StatefulWidget {
  final Function(String)? onPromptSubmitted;
  final Function()? onVoicePressed;
  final bool isListening;

  const VoicePromptWidget({
    super.key,
    this.onPromptSubmitted,
    this.onVoicePressed,
    this.isListening = false,
  });

  @override
  State<VoicePromptWidget> createState() => _VoicePromptWidgetState();
}

class _VoicePromptWidgetState extends State<VoicePromptWidget>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late VoiceProvider _voiceProvider;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: AppConstants.pulseAnimationDuration,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Initialize voice provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _voiceProvider = Provider.of<VoiceProvider>(context, listen: false);
      _voiceProvider.initializeVoice();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VoicePromptWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, child) {
        final isActuallyListening = voiceProvider.isListening;
        
        // Sync animation with actual listening state
        if (isActuallyListening && !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        } else if (!isActuallyListening && _pulseController.isAnimating) {
          _pulseController.stop();
        }
        
        return Container(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        fontFamily: AppConstants.fontFamily,
                      ),
                      decoration: InputDecoration(
                        hintText: isActuallyListening 
                            ? 'Listening...' 
                            : 'Enter a command or tap mic',
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
                          widget.onPromptSubmitted?.call(text.trim());
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.spacing16),
                  
                  // Voice button
                  GestureDetector(
                    onTap: () => _handleVoicePressed(voiceProvider),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isActuallyListening ? _pulseAnimation.value : 1.0,
                          child: Container(
                            width: AppConstants.floatingButtonSize,
                            height: AppConstants.floatingButtonSize,
                            decoration: BoxDecoration(
                              gradient: isActuallyListening 
                                  ? AppColors.errorGradient 
                                  : AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: isActuallyListening 
                                      ? AppColors.errorColor.withValues(alpha: 0.3)
                                      : AppColors.primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              isActuallyListening ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: AppConstants.mediumIconSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              // Voice feedback area
              if (isActuallyListening || voiceProvider.lastWords.isNotEmpty)
                _buildVoiceFeedback(voiceProvider, isDark),
            ],
          ),
        );
      },
    );
  }

  /// Build voice feedback display
  Widget _buildVoiceFeedback(VoiceProvider voiceProvider, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.spacing12),
      padding: const EdgeInsets.all(AppConstants.spacing12),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.darkBackground.withValues(alpha: 0.5)
            : AppColors.lightBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.spacing8),
        border: Border.all(
          color: voiceProvider.isListening 
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status
          Row(
            children: [
              Icon(
                voiceProvider.isListening ? Icons.mic : Icons.mic_off,
                size: 16,
                color: voiceProvider.isListening 
                    ? AppColors.primary 
                    : isDark 
                        ? AppColors.darkTextSecondary 
                        : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: AppConstants.spacing8),
              Text(
                voiceProvider.isListening 
                    ? 'Listening...' 
                    : 'Speech detected',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: voiceProvider.isListening 
                      ? AppColors.primary 
                      : isDark 
                          ? AppColors.darkTextSecondary 
                          : AppColors.lightTextSecondary,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              const Spacer(),
              if (voiceProvider.confidence > 0)
                Text(
                  '${(voiceProvider.confidence * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark 
                        ? AppColors.darkTextSecondary 
                        : AppColors.lightTextSecondary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
            ],
          ),
          
          // Transcribed text
          if (voiceProvider.lastWords.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacing8),
            Text(
              voiceProvider.lastWords,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            
            // Action button for detected text
            if (!voiceProvider.isListening && voiceProvider.lastWords.isNotEmpty) ...[
              const SizedBox(height: AppConstants.spacing8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _controller.text = voiceProvider.lastWords;
                      widget.onPromptSubmitted?.call(voiceProvider.lastWords);
                      voiceProvider.reset();
                    },
                    icon: const Icon(Icons.send, size: 16),
                    label: const Text('Use this text'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacing8),
                  TextButton.icon(
                    onPressed: () => voiceProvider.reset(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark 
                          ? AppColors.darkTextSecondary 
                          : AppColors.lightTextSecondary,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  /// Handle voice button press
  Future<void> _handleVoicePressed(VoiceProvider voiceProvider) async {
    if (voiceProvider.isListening) {
      // Stop listening
      await voiceProvider.stopListening();
    } else {
      // Start listening
      await voiceProvider.startListening(
        onResult: (result) {
          // Update UI when speech is recognized
          setState(() {});
        },
        timeout: const Duration(seconds: 30),
      );
    }
    
    // Call the optional callback
    widget.onVoicePressed?.call();
  }
}
