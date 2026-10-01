import 'package:flutter/widgets.dart';

/// Honors the system text size up to [max], so a dense layout stays legible
/// for low-vision users without breaking apart at the largest settings.
class TextScaleCap extends StatelessWidget {
  static const defaultMax = 1.3;

  final double max;
  final Widget child;

  const TextScaleCap({super.key, this.max = defaultMax, required this.child});

  static TextScaler scalerOf(BuildContext context, {double max = defaultMax}) =>
      MediaQuery.textScalerOf(context).clamp(maxScaleFactor: max);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: scalerOf(context, max: max),
      ),
      child: child,
    );
  }
}
