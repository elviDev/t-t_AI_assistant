/// Application-wide constants
/// Contains all constant values used throughout the app
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'T&T AI Assistant';
  static const String appDescription = 'Your intelligent project companion';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 1500); // Reduced for better UX
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 600);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  static const Duration pulseAnimationDuration = Duration(seconds: 2);

  // UI Constants
  static const double borderRadius = 16.0;
  static const double largeBorderRadius = 24.0;
  static const double smallBorderRadius = 8.0;

  // Spacing
  static const double spacing8 = 8.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Button Dimensions
  static const double buttonHeight = 56.0;
  static const double iconButtonSize = 40.0;
  static const double floatingButtonSize = 56.0;

  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 50.0;
  static const double extraLargeIconSize = 60.0;

  // Container Sizes
  static const double avatarSize = 100.0;
  static const double loadingIndicatorSize = 40.0;
  static const double progressIndicatorHeight = 4.0;

  // Font Weights
  static const String fontFamily = 'Inter';

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Error Messages
  static const String emailRequiredError = 'Please enter your email';
  static const String emailInvalidError = 'Please enter a valid email';
  static const String passwordRequiredError = 'Please enter your password';
  static const String passwordTooShortError = 'Password must be at least 6 characters';
  static const String passwordMismatchError = 'Passwords do not match';
  static const String nameRequiredError = 'Please enter your full name';

  // Success Messages
  static const String signInSuccessMessage = 'Welcome back!';
  static const String signUpSuccessMessage = 'Account created successfully!';

  // Loading Messages
  static const String loadingMessage = 'Loading...';
  static const String processingMessage = 'Processing your request...';

  // Voice Recording
  static const Duration voiceRecordingDuration = Duration(seconds: 3);
  static const Duration commandProcessingDuration = Duration(seconds: 2);
}
