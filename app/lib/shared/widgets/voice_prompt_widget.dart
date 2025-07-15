import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Voice prompt widget for voice command input
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
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
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
                hintText: widget.isListening 
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
            onTap: widget.onVoicePressed,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isListening ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: AppConstants.floatingButtonSize,
                    height: AppConstants.floatingButtonSize,
                    decoration: BoxDecoration(
                      gradient: widget.isListening 
                          ? AppColors.errorGradient 
                          : AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.isListening 
                              ? AppColors.errorColor.withOpacity(0.3)
                              : AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isListening ? Icons.stop : Icons.mic,
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
    );
  }
}
