import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Custom painter for creating curved background designs
/// Used to add decorative curved shapes to screens
class CurvedBackgroundPainter extends CustomPainter {
  final bool isDark;
  final Color? customColor;
  final double opacity;

  const CurvedBackgroundPainter({
    required this.isDark,
    this.customColor,
    this.opacity = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color = customColor ?? AppColors.secondary;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Create curved shape at top
    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(size.width, 0);
    topPath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.15,
    );
    topPath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      0,
      size.height * 0.25,
    );
    topPath.close();

    canvas.drawPath(topPath, paint);

    // Create curved shape at bottom
    final bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.8,
      size.width * 0.4,
      size.height * 0.85,
    );
    bottomPath.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.9,
      size.width,
      size.height * 0.75,
    );
    bottomPath.lineTo(size.width, size.height);
    bottomPath.close();

    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CurvedBackgroundPainter) {
      return oldDelegate.isDark != isDark ||
          oldDelegate.customColor != customColor ||
          oldDelegate.opacity != opacity;
    }
    return true;
  }
}

/// Widget wrapper for curved background painter
class CurvedBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Color? customColor;
  final double opacity;

  const CurvedBackground({
    super.key,
    required this.child,
    required this.isDark,
    this.customColor,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Curved background
        CustomPaint(
          painter: CurvedBackgroundPainter(
            isDark: isDark,
            customColor: customColor,
            opacity: opacity,
          ),
          size: Size.infinite,
        ),
        // Content
        child,
      ],
    );
  }
}
