import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class VoiceWaveAnimation extends StatelessWidget {
  final double amplitude;
  final bool isAnimating;
  final Color? color;

  const VoiceWaveAnimation({
    super.key,
    required this.amplitude,
    required this.isAnimating,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(15, (index) {
        // Create variations in height for each bar to look like a wave
        final variation = (index % 5) * 0.1;
        double height;
        if (isAnimating) {
          height = 4.0 + (amplitude * 30.0 * (0.5 + variation));
        } else {
          height = 4.0;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 3,
          height: height.clamp(4.0, 40.0),
          decoration: BoxDecoration(
            color: isAnimating ? (color ?? Const.aqua) : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
