import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/utils/navigation_utils.dart';
import '../welcome/welcome_screen.dart';

/// Loading screen displayed during app initialization
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToWelcome();
  }

  /// Initialize fade and scale animations
  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  /// Navigate to welcome screen after splash duration
  void _navigateToWelcome() {
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted && context.mounted) {
        NavigationUtils.replaceWithFade(context, const WelcomeScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Icon
                      Container(
                        width: AppConstants.avatarSize,
                        height: AppConstants.avatarSize,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
                          size: AppConstants.largeIconSize,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.spacing32),
                      
                      // App Name
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.spacing8),
                      
                      // Tagline
                      Text(
                        'Your intelligent assistant',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.spacing64),
                      
                      // Loading Indicator
                      SizedBox(
                        width: AppConstants.loadingIndicatorSize,
                        height: AppConstants.loadingIndicatorSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
