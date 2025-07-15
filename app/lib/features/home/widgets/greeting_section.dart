import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF3933C6), Color(0xFFA05FFF)],
          ).createShader(bounds),
          child: const Text(
            'Hello Javier!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Shader mask overrides this
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Give any command from creating a\ndocument to scheduling a\nmeeting.',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
