import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/presentation/bloc/home_services_cubit.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_list_card.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

/// The home page services block. Renders the grid or the single-column list;
/// the client can compare both from the toggle in the section header.
class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.dashboard.home;
    final services = homeServiceViews(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.section_title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DashboardPalette.navy,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.section_subtitle,
            style: const TextStyle(
              color: DashboardPalette.muted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const _LayoutToggle(),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _ViewAllButton(label: t.view_all),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<HomeServicesCubit, HomeServicesState>(
            builder: (context, state) {
              if (state.layout == HomeServicesLayout.grid) {
                return ServiceGrid(services: services);
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
        return GestureDetector(
          onTap: () => context.read<HomeServicesCubit>().toggle(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: DashboardPalette.hairline),
            ),
            child: Icon(
              state.layout == HomeServicesLayout.grid
                  ? Icons.view_agenda_outlined
                  : Icons.grid_view_outlined,
              size: 18,
              color: DashboardPalette.muted,
            ),
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
    return GestureDetector(
      onTap: () => context.push(AppRoutes.allServices),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: DashboardPalette.hairline),
        ),
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
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 16, color: DashboardPalette.link),
          ],
        ),
      ),
    );
  }
}
