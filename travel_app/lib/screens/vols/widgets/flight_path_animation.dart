import 'package:flutter/material.dart';
import 'package:voyageur/core/constants/app_colors.dart';

class FlightPathAnimation extends StatefulWidget {
  const FlightPathAnimation({super.key});

  @override
  State<FlightPathAnimation> createState() => _FlightPathAnimationState();
}

class _FlightPathAnimationState extends State<FlightPathAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 60),
          painter: _FlightPathPainter(_controller.value),
        );
      },
    );
  }
}

class _FlightPathPainter extends CustomPainter {
  final double progress;

  _FlightPathPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withValues(alpha: 0.2)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    canvas.drawPath(path, paint);

    final planeX = size.width * progress;
    final planePaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(planeX, size.height / 2), 5, planePaint);
  }

  @override
  bool shouldRepaint(covariant _FlightPathPainter oldDelegate) => true;
}
