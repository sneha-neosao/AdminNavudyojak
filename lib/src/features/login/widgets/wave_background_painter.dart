import 'package:flutter/material.dart';

// Custom Painter for Top Background Wave Design
class WaveBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  WaveBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Top Background Wave Gradient
    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [
          primaryColor.withValues(alpha: isDark ? 0.35 : 0.20),
          secondaryColor.withValues(alpha: isDark ? 0.20 : 0.10),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.45));

    final path1 = Path();
    // Starts on the left side
    path1.lineTo(0, size.height * 0.22);

    // Smooth bezier curve flowing across to the right side end
    path1.cubicTo(
      size.width * 0.35,
      size.height * 0.38,
      size.width * 0.65,
      size.height * 0.18,
      size.width,
      size.height * 0.35,
    );

    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant WaveBackgroundPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.isDark != isDark;
  }
}
