import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBackgroundPatternWidget extends StatelessWidget {
  const SplashBackgroundPatternWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return Stack(
      children: [
        // Bubble 1: Top Right (Primary glow)
        Positioned(
          top: -100.h,
          right: -120.w,
          child: Container(
            width: 420.r,
            height: 420.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor.withValues(alpha: isDark ? 0.18 : 0.12),
                  primaryColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: -25,
              end: 25,
              duration: 8.seconds,
              curve: Curves.easeInOut,
            )
            .moveX(
              begin: -15,
              end: 15,
              duration: 7.seconds,
              curve: Curves.easeInOut,
            ),

        // Bubble 2: Bottom Left (Secondary glow)
        Positioned(
          bottom: -120.h,
          left: -100.w,
          child: Container(
            width: 380.r,
            height: 380.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  secondaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  secondaryColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: 20,
              end: -20,
              duration: 9.seconds,
              curve: Curves.easeInOut,
            )
            .moveX(
              begin: 15,
              end: -15,
              duration: 8.seconds,
              curve: Curves.easeInOut,
            ),

        // Bubble 3: Mid Right (Tertiary glow)
        Positioned(
          top: 280.h,
          right: -80.w,
          child: Container(
            width: 250.r,
            height: 250.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  tertiaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  tertiaryColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: -15,
              end: 15,
              duration: 6.seconds,
              curve: Curves.easeInOut,
            )
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.1, 1.1),
              duration: 10.seconds,
              curve: Curves.easeInOut,
            ),

        // Bubble 4: Center Left (Accent glow)
        Positioned(
          top: 150.h,
          left: -50.w,
          child: Container(
            width: 200.r,
            height: 200.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor.withValues(alpha: isDark ? 0.12 : 0.08),
                  primaryColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: 15,
              end: -15,
              duration: 5.seconds,
              curve: Curves.easeInOut,
            )
            .moveX(
              begin: -20,
              end: 20,
              duration: 7.seconds,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}
