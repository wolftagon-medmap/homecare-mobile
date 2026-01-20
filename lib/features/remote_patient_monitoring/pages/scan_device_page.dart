import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/buttons/button_size.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/core/presentation/widgets/buttons/secondary_button.dart';

class ScanDevicePage extends StatelessWidget {
  const ScanDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monitor My Vitals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          _RippleAnimation(),
          SizedBox(height: 48),
          Text(
            'Scanning...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500, // Poppins Medium
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Searching for available devices',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFA3A3A3),
            ),
          ),
          Spacer(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                size: ButtonSize.small,
                text: "Add Manually",
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SecondaryButton(
                size: ButtonSize.small,
                text: "Scan Code",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RippleAnimation extends StatefulWidget {
  const _RippleAnimation();

  @override
  State<_RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<_RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 283,
      height: 283,
      child: CustomPaint(
        painter: _RipplePainter(_controller),
        child: Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.monitor_heart_outlined,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> animation;

  _RipplePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Const.aqua;

    // Draw 3 expanding rings
    for (int i = 0; i < 3; i++) {
      // Stagger the animations
      final progress = (animation.value + (i / 3)) % 1.0;
      // Opacity fades out as it expands
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      // Radius expands from a base size to max size
      // Base size should be larger than the white circle (approx 45 radius)
      final radius = 45.0 + (maxRadius - 45.0) * progress;

      paint.color = Const.aqua.withOpacity(opacity * 0.5); // Adjust max opacity
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
