import 'package:flutter/material.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_layout.dart';
import 'package:m2health/features/dashboard/presentation/home_grid_metrics.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid_card.dart';

class ServiceGrid extends StatelessWidget {
  final List<HomeServiceView> services;
  final int columns;

  const ServiceGrid({
    super.key,
    required this.services,
    this.columns = DashboardLayout.minColumns,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = HomeGridMetrics.of(
          DashboardLayout.cardWidthFor(constraints.maxWidth, columns),
          MediaQuery.textScalerOf(context),
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: DashboardLayout.gridGap,
            mainAxisSpacing: DashboardLayout.gridGap,
            mainAxisExtent: metrics.cardHeight,
          ),
          itemBuilder: (_, i) =>
              ServiceGridCard(service: services[i], metrics: metrics),
        );
      },
    );
  }
}
