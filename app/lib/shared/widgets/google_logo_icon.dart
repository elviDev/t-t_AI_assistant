import 'package:flutter/material.dart';

/// Custom Google logo widget using Flutter's built-in widgets
/// This creates a colorful "G" icon that resembles the Google logo
class GoogleLogoIcon extends StatelessWidget {
  final double size;
  
  const GoogleLogoIcon({
    super.key,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.1),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4285F4), // Google Blue
            Color(0xFF34A853), // Google Green
            Color(0xFFFBBC05), // Google Yellow
            Color(0xFFEA4335), // Google Red
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
