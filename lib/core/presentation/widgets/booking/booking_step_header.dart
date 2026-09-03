import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// Title and optional subtitle above a guided booking step. The flow branches,
/// so it carries no step counter — progress is drawn by the flow itself.
class BookingStepHeader extends StatelessWidget {
  const BookingStepHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 10),
  });

  final String title;
  final String? subtitle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ProText.pageTitle.copyWith(color: Const.primaryTextColor),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: ProText.caption.copyWith(height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
