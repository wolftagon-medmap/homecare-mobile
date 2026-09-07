import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/presentation/bloc/home_services_cubit.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_layout.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_list_card.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.dashboard.home;
    final services = homeServiceViews(context);

    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: DashboardLayout.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 26, 16, 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = DashboardLayout.columnsFor(
                  constraints.maxWidth, services.length);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.section_title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DashboardPalette.navy,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.section_subtitle,
                              style: const TextStyle(
                                color: DashboardPalette.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 12),
                      const _LayoutToggle(),
                      const SizedBox(width: 4),
                      _ViewAllButton(label: t.view_all),
                      // Expanded(
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: _ViewAllButton(label: t.view_all),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<HomeServicesCubit, HomeServicesState>(
                    builder: (context, state) {
                      if (state.layout == HomeServicesLayout.grid) {
                        return ServiceGrid(
                          services: services,
                          columns: columns,
                        );
                      }
                      return Column(
                        children: [
                          for (final service in services) ...[
                            ServiceListCard(service: service),
                            const SizedBox(height: 10),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LayoutToggle extends StatelessWidget {
  const _LayoutToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeServicesCubit, HomeServicesState>(
      builder: (context, state) {
        final isGrid = state.layout == HomeServicesLayout.grid;
        return _ChipButton(
          semanticsLabel: isGrid ? 'Show as list' : 'Show as grid',
          onTap: () => context.read<HomeServicesCubit>().toggle(),
          child: Icon(
            isGrid ? Icons.view_agenda_outlined : Icons.grid_view_outlined,
            size: 18,
            color: DashboardPalette.muted,
          ),
        );
      },
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final String label;

  const _ViewAllButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return _ChipButton(
      semanticsLabel: label,
      onTap: () => context.push(AppRoutes.allServices),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: DashboardPalette.link,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.chevron_right,
              size: 16, color: DashboardPalette.link),
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final Widget child;
  final String semanticsLabel;
  final VoidCallback onTap;

  const _ChipButton({
    required this.child,
    required this.semanticsLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        shape: const StadiumBorder(
          side: BorderSide(color: DashboardPalette.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: DashboardLayout.minTapTarget,
              minWidth: DashboardLayout.minTapTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(widthFactor: 1, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
