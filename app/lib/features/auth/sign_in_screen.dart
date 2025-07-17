import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/curved_background.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/utils/navigation_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../home/home_screen.dart';
import 'sign_up_screen.dart';

/// Sign in screen for user authentication
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers and keys
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize animations for the sign in screen
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: CurvedBackground(
          isDark: isDark,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacing24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form Fields
                      _buildFormFields(isDark),
                      
                      const SizedBox(height: AppConstants.spacing32),
                      
                      // Action Buttons
                      _buildActionButtons(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// Build form fields section
  Widget _buildFormFields(bool isDark) {
    return FadeTransition(
      opacity: _animationController,
      child: Column(
        children: [
          // Email Field
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: ValidationUtils.validateEmail,
            isDark: isDark,
            textInputAction: TextInputAction.next,
            useGradientBorder: true,
          ),
          
          const SizedBox(height: AppConstants.spacing24),
          
          // Password Field
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            obscureText: _obscurePassword,
            validator: ValidationUtils.validatePassword,
            isDark: isDark,
            textInputAction: TextInputAction.done,
            useGradientBorder: true,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons section
  Widget _buildActionButtons(bool isDark) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      )),
      child: Column(
        children: [
          // Sign In Button
          CustomButton(
            text: 'Sign In',
            onPressed: _isLoading ? null : _signIn,
            isPrimary: true,
            isDark: isDark,
            isLoading: _isLoading,
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

  /// Handle sign in process
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Simulate API call
        await Future.delayed(AppConstants.commandProcessingDuration);
        
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppConstants.signInSuccessMessage),
              backgroundColor: AppColors.success,
            ),
          );
          
          // Navigate to home screen
          NavigationUtils.replaceWithFade(context, const HomeScreen());
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign in failed: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  /// Handle forgot password action
  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password feature coming soon!'),
      ),
    );
  }

  /// Navigate to sign up screen
  void _navigateToSignUp(BuildContext context) {
    NavigationUtils.replaceWithSlide(context, const SignUpScreen());
  }
}
