import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/curved_background.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/utils/navigation_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../home/home_screen.dart';
import 'sign_in_screen.dart';

/// Sign up screen for user registration
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers and keys
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize animations for the sign up screen
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          const SizedBox(height: 20),
          
          // Full Name Field
          CustomTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hintText: 'Enter your full name',
            keyboardType: TextInputType.name,
            validator: ValidationUtils.validateFullName,
            isDark: isDark,
            textInputAction: TextInputAction.next,
            useGradientBorder: true,
          ),
          
          const SizedBox(height: AppConstants.spacing24),
          
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
            textInputAction: TextInputAction.next,
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
          
          const SizedBox(height: AppConstants.spacing24),
          
          // Confirm Password Field
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hintText: 'Confirm your password',
            obscureText: _obscureConfirmPassword,
            validator: (value) => ValidationUtils.validatePasswordConfirmation(
              value,
              _passwordController.text,
            ),
            isDark: isDark,
            textInputAction: TextInputAction.done,
            useGradientBorder: true,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          // Terms and Conditions
          _buildTermsAndConditions(isDark),
        ],
      ),
    );
  }

  /// Build terms and conditions section
  Widget _buildTermsAndConditions(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontFamily: AppConstants.fontFamily,
          ),
          children: [
            const TextSpan(text: 'By signing up, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
          // Register Button
          CustomButton(
            text: 'Create Account',
            onPressed: _isLoading ? null : _signUp,
            isPrimary: true,
            isDark: isDark,
            isLoading: _isLoading,
          ),
          
          const SizedBox(height: AppConstants.spacing24),
          
          // Sign In Link
          GestureDetector(
            onTap: () => _navigateToSignIn(context),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontFamily: AppConstants.fontFamily,
                ),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign In',
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

  /// Handle sign up process
  Future<void> _signUp() async {
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
              content: Text(AppConstants.signUpSuccessMessage),
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
              content: Text('Sign up failed: ${e.toString()}'),
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

  /// Navigate to sign in screen
  void _navigateToSignIn(BuildContext context) {
    NavigationUtils.replaceWithSlide(context, const SignInScreen());
  }
}
