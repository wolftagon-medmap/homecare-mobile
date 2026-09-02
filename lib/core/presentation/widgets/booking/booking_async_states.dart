import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

/// Centred spinner for a step that is still loading its options.
class BookingLoadingState extends StatelessWidget {
  const BookingLoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Const.aqua),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Const.contentTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Nothing to show — no professionals at this location, no add-ons for this
/// service, an empty thread list.
class BookingEmptyState extends StatelessWidget {
  const BookingEmptyState({
    super.key,
    this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String? title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return _CentredMessage(
      icon: icon,
      iconColor: Const.placeholderTextColor,
      title: title ?? context.t.sharedBooking.empty_title,
      message: message,
      action: action,
    );
  }
}

/// A failed load, with the retry the caller supplies.
class BookingErrorState extends StatelessWidget {
  const BookingErrorState({
    super.key,
    this.title,
    this.message,
    this.onRetry,
  });

  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _CentredMessage(
      icon: Icons.error_outline,
      iconColor: const Color(0xFFD64545),
      title: title ?? context.t.sharedBooking.error_title,
      message: message,
      action: onRetry == null
          ? null
          : OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Const.aqua),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.t.sharedBooking.retry,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Const.aqua,
                ),
              ),
            ),
    );
  }
}

class _CentredMessage extends StatelessWidget {
  const _CentredMessage({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: iconColor),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Const.primaryTextColor,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Const.contentTextColor,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
