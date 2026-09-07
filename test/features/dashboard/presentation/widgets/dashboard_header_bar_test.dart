import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/dashboard/presentation/widgets/dashboard_header_bar.dart';

Future<double> _heightAt(WidgetTester tester, double textScaleFactor) async {
  late double height;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScaleFactor)),
      child: Builder(
        builder: (context) {
          height = DashboardHeaderBar.heightOf(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return height;
}

void main() {
  testWidgets('matches the hand-tuned height at the default text scale',
      (tester) async {
    final height = await _heightAt(tester, 1.0);

    expect(height, closeTo(180, 5));
  });

  testWidgets('grows with the text scale', (tester) async {
    final normal = await _heightAt(tester, 1.0);
    final large = await _heightAt(tester, 1.3);

    expect(large, greaterThan(normal));
  });

  testWidgets('stops growing past the clamp so it cannot eat the screen',
      (tester) async {
    final clamped = await _heightAt(tester, 1.3);
    final huge = await _heightAt(tester, 3.0);

    expect(huge, clamped);
  });

  testWidgets('clamps the scaler it hands to its children', (tester) async {
    late TextScaler scaler;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(3.0)),
        child: Builder(
          builder: (context) {
            scaler = DashboardHeaderBar.scalerOf(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(scaler.scale(10), closeTo(13, 0.01));
  });
}
