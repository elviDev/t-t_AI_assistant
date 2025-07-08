import 'package:flutter/material.dart';
import 'app_colors.dart';

class CurvedBackgroundPainter extends CustomPainter {
  final bool isDark;

  CurvedBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppColors.secondary : AppColors.secondary)
          .withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.15,
    );
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      0,
      size.height * 0.25,
    );
    path.close();
    canvas.drawPath(path, paint);

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
