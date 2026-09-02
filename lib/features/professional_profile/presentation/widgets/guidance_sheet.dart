import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// Screen guidance lives one tap away rather than as a paragraph above the
/// controls. Disclaimers stay on the screen itself -- hiding one defeats it.
class GuidanceAction extends StatelessWidget {
  const GuidanceAction({
    super.key,
    required this.title,
    required this.points,
  });

  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline, size: 22),
      color: Const.contentTextColor,
      tooltip: 'About this screen',
      onPressed: () => showGuidanceSheet(context, title: title, points: points),
    );
  }
}

Future<void> showGuidanceSheet(
  BuildContext context, {
  required String title,
  required List<String> points,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ProText.sectionTitle),
            const SizedBox(height: 12),
            for (final point in points) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6, right: 10),
                    child: Icon(Icons.circle, size: 5, color: Const.aqua),
                  ),
                  Expanded(child: Text(point, style: ProText.caption)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    ),
  );
}
