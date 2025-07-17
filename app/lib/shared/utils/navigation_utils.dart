import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Utility class for navigation operations
/// Provides reusable navigation methods with consistent animations
class NavigationUtils {
  // Private constructor to prevent instantiation
  NavigationUtils._();

  /// Navigate to a new screen with fade transition
  static void navigateWithFade(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppConstants.mediumAnimationDuration,
      ),
    );
  }

  /// Navigate to a new screen with slide transition
  static void navigateWithSlide(BuildContext context, Widget destination, {
    SlideDirection direction = SlideDirection.fromRight,
  }) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.fromRight:
        beginOffset = const Offset(1.0, 0.0);
        break;
      case SlideDirection.fromLeft:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.fromTop:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.fromBottom:
        beginOffset = const Offset(0.0, 1.0);
        break;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: AppConstants.longAnimationDuration,
      ),
    );
  }

  /// Replace current screen with fade transition
  static void replaceWithFade(BuildContext context, Widget destination) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppConstants.mediumAnimationDuration,
      ),
    );
  }

  /// Replace current screen with slide transition
  static void replaceWithSlide(BuildContext context, Widget destination, {
    SlideDirection direction = SlideDirection.fromRight,
  }) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.fromRight:
        beginOffset = const Offset(1.0, 0.0);
        break;
      case SlideDirection.fromLeft:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.fromTop:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.fromBottom:
        beginOffset = const Offset(0.0, 1.0);
        break;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: AppConstants.longAnimationDuration,
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Navigate back to previous screen
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Enum for slide direction
enum SlideDirection {
  fromRight,
  fromLeft,
  fromTop,
  fromBottom,
}
