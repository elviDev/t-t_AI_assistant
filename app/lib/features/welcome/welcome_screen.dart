import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/curved_background.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/utils/navigation_utils.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../home/home_screen.dart';

/// Welcome screen that introduces the app and provides authentication options
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize slide animations for the welcome screen
  void _initializeAnimations() {
    _controller = AnimationController(
      duration: AppConstants.longAnimationDuration,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        body: CurvedBackground(
          isDark: isDark,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacing24),
              child: Column(
                children: [
                  const Spacer(),
                  
                  // App Icon and Branding
                  _buildAppBranding(isDark),
                  
                  const SizedBox(height: AppConstants.spacing32),
                  
                  // Welcome Text
                  _buildWelcomeText(isDark),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  _buildActionButtons(isDark),
                  
                  const SizedBox(height: AppConstants.spacing32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build app branding section with icon and title
  Widget _buildAppBranding(bool isDark) {
    return Column(
      children: [
        // AI Icon
        Container(
          width: AppConstants.avatarSize,
          height: AppConstants.avatarSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(99, 102, 241, 0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: AppConstants.largeIconSize,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacing24),
        
        // App Title
        Text(
          'T&T AI Voice Command',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }

  /// Build welcome text section
  Widget _buildWelcomeText(bool isDark) {
    return Column(
      children: [
        Text(
          'Welcome.',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacing16),
        
        // Welcome message lines
        ..._buildWelcomeMessages(isDark),
      ],
    );
  }

  /// Build welcome message lines
  List<Widget> _buildWelcomeMessages(bool isDark) {
    final messages = [
      'I\'m your smart assistant,',
      'here to help you work faster,',
      'think clearer,',
      'and stay in flow.',
    ];

    return messages
        .map((message) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ))
        .toList();
  }

  /// Build action buttons section
  Widget _buildActionButtons(bool isDark) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          // Sign In Button
          CustomButton(
            text: 'Sign In',
            onPressed: () => _navigateToSignIn(context),
            isPrimary: true,
            isDark: isDark,
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          // Sign In with Google Button
          CustomButton(
            text: 'Sign In with Google',
            onPressed: () => _signInWithGoogle(context),
            isPrimary: false,
            isDark: isDark,
            icon: Icons.g_mobiledata,
          ),
          
          const SizedBox(height: AppConstants.spacing24),
          
          // Sign Up Link
          GestureDetector(
            onTap: () => _navigateToSignUp(context),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontFamily: AppConstants.fontFamily,
                ),
                children: [
                  const TextSpan(text: 'Don\'t have an account? '),
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to sign in screen
  void _navigateToSignIn(BuildContext context) {
    NavigationUtils.navigateWithSlide(context, const SignInScreen());
  }

  /// Navigate to sign up screen
  void _navigateToSignUp(BuildContext context) {
    NavigationUtils.navigateWithSlide(context, const SignUpScreen());
  }

  /// Simulate Google sign-in process
  void _signInWithGoogle(BuildContext context) {
    _showLoadingAndNavigate(context);
  }

  /// Show loading dialog and navigate to home screen
  void _showLoadingAndNavigate(BuildContext context) {
    NavigationUtils.showLoadingDialog(context);
    
    Future.delayed(AppConstants.commandProcessingDuration, () {
      if (mounted && context.mounted) {
        NavigationUtils.hideLoadingDialog(context);
        NavigationUtils.replaceWithFade(context, const HomeScreen());
      }
    });
  }
}
