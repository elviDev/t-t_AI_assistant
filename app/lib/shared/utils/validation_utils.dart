import '../../core/constants/app_constants.dart';

/// Utility class for form validation
/// Contains all validation logic used throughout the app
class ValidationUtils {
  // Private constructor to prevent instantiation
  ValidationUtils._();

  /// Validates email address format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emailRequiredError;
    }
    
    if (value.length > AppConstants.maxEmailLength) {
      return 'Email is too long';
    }
    
    if (!RegExp(AppConstants.emailPattern).hasMatch(value)) {
      return AppConstants.emailInvalidError;
    }
    
    return null;
  }

  /// Validates password strength and requirements
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.passwordRequiredError;
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return AppConstants.passwordTooShortError;
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password is too long';
    }
    
    return null;
  }

  /// Validates password confirmation matches original password
  static String? validatePasswordConfirmation(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != originalPassword) {
      return AppConstants.passwordMismatchError;
    }
    
    return null;
  }

  /// Validates full name input
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.nameRequiredError;
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return 'Name is too long';
    }
    
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name';
    }
    
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    
    return null;
  }

  /// Validates minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }
}
