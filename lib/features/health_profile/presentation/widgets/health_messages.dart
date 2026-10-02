import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/i18n/translations.g.dart';

String healthFailureReason(BuildContext context, Failure? failure) {
  final t = context.t.healthProfile.reason;
  return switch (failure) {
    NetworkFailure() => t.network,
    NotFoundFailure() => t.not_found,
    BadRequestFailure() => t.invalid,
    _ => t.server,
  };
}

class HealthLoadingMessage extends StatelessWidget {
  const HealthLoadingMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Const.healthAction),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 14, color: Const.healthMutedText),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthErrorMessage extends StatelessWidget {
  const HealthErrorMessage({
    super.key,
    required this.title,
    required this.reason,
    required this.onRetry,
  });

  final String title;
  final String reason;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, textAlign: TextAlign.center, style: ProText.bodyStrong),
            const SizedBox(height: 8),
            Text(
              reason,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 14, color: Const.healthMutedText),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: Const.healthAction,
                side: const BorderSide(color: Const.healthAction),
                minimumSize: const Size(120, 48),
              ),
              child: Text(context.t.healthProfile.retry),
            ),
          ],
        ),
      ),
    );
  }
}
