import 'package:flutter/material.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid_card.dart';

/// Rows of equal-width cards, each row as tall as its tallest card so the
/// descriptions are never clipped. A GridView would force one aspect ratio on
/// every cell and truncate the longer descriptors.
class ServiceGrid extends StatelessWidget {
  final List<HomeServiceView> services;
  final int columns;

  const ServiceGrid({
    super.key,
    required this.services,
    this.columns = 3,
  });

  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final rows = <List<HomeServiceView>>[];
    for (var i = 0; i < services.length; i += columns) {
      rows.add(services.sublist(i, (i + columns).clamp(0, services.length)));
    }

    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: _gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < columns; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
                  // Empty slots keep a short last row's cards the same width
                  // as every other row's.
                  Expanded(
                    child: i < rows[r].length
                        ? ServiceGridCard(service: rows[r][i])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
