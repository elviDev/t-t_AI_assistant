import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../widgets/curved_background_painter.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            painter: CurvedBackgroundPainter(isDark: isDark),
            size: Size.infinite,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'T&T AI Voice Command',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome.',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'I\'m your smart assistant,',
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    'here to help you work faster,',
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    'think clearer,',
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    'and stay in flow.',
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const Spacer(),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        _buildGradientButton(
                          'Sign In',
                          () => _navigateToSignIn(context),
                          gradient: null,
                          isDark: isDark,
                          borderOnly: true,
                        ),
                        const SizedBox(height: 16),
                        _buildGradientButton(
                          'Sign Up with Google',
                          () => _signUpWithGoogle(context),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3933C6), Color(0xFFA05FFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          isDark: isDark,
                          imageAsset: 'assets/google_logo.png',
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () => _navigateToSignUp(context),
                          child: Text(
                            'Create account',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(
    String text,
    VoidCallback onPressed, {
    required Gradient? gradient,
    required bool isDark,
    bool borderOnly = false,
    String? imageAsset,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: gradient,
          color: gradient == null ? (isDark ? AppColors.darkSurface : AppColors.lightSurface) : null,
          border: borderOnly
              ? Border.all(
                  color: isDark ? Colors.white54 : Colors.deepPurple,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null) ...[
              Image.asset(
                imageAsset,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                color: gradient != null ? Colors.white : (isDark ? Colors.white : Colors.deepPurple),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void _signUpWithGoogle(BuildContext context) {
    _showLoadingAndNavigate(context);
  }

  void _showLoadingAndNavigate(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }
}
