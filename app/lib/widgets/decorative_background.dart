import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';

class DecorativeBackground extends StatelessWidget {
  final Widget child;
  final bool showTopCircle;
  final bool showBottomCircle;

  const DecorativeBackground({
    Key? key,
    required this.child,
    this.showTopCircle = true,
    this.showBottomCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        children: [
          // Top decorative circle
          if (showTopCircle)
            Positioned(
              top: -AppDimensions.decorativeCircleSize * 0.6,
              left: -AppDimensions.decorativeCircleSize * 0.3,
              child: Container(
                width: AppDimensions.decorativeCircleSize,
                height: AppDimensions.decorativeCircleSize,
                decoration: const BoxDecoration(
                  gradient: AppColors.decorativeGradient,
                  shape: BoxShape.circle,
                ),
              ),
            ),

          // Bottom decorative circle
          if (showBottomCircle)
            Positioned(
              bottom: -AppDimensions.decorativeCircleSizeSmall * 0.5,
              left: -AppDimensions.decorativeCircleSizeSmall * 0.3,
              child: Container(
                width: AppDimensions.decorativeCircleSizeSmall,
                height: AppDimensions.decorativeCircleSizeSmall,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AppColors.decorativeGradient.begin,
                    end: AppColors.decorativeGradient.end,
                    stops: AppColors.decorativeGradient.stops,
                    colors: [
                      AppColors.primaryPurpleLight.withOpacity(0.6),
                      AppColors.primaryPurple.withOpacity(0.4),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

          // Main content
          child,
        ],
      ),
    );
  }
}
