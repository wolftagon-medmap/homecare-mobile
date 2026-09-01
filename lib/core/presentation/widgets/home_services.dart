import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomeServicesLayout { grid, list }

class HomeService {
  final String id;
  final String iconPath;
  final Color accent;
  final Color tint;
  final String title;
  final String description;
  final String route;
  final bool isNew;

  const HomeService({
    required this.id,
    required this.iconPath,
    required this.accent,
    required this.tint,
    required this.title,
    required this.description,
    required this.route,
    this.isNew = false,
  });
}

List<HomeService> homeServices(BuildContext context, {bool all = false}) {
  final t = context.t.dashboard.home;
  final items = <HomeService>[
    HomeService(
      id: 'pharmacist',
      iconPath: 'assets/icons/ic_svc_pharmacist.svg',
      accent: const Color(0xFF128D8B),
      tint: const Color(0xFFF2F8F4),
      title: t.name_pharmacist,
      description: t.desc_pharmacist,
      route: AppRoutes.pharmaServices,
      isNew: true,
    ),
    HomeService(
      id: 'physiotherapy',
      iconPath: 'assets/icons/ic_svc_physiotherapy.svg',
      accent: const Color(0xFF0A45BB),
      tint: const Color(0xFFF4F8FD),
      title: t.name_physiotherapy,
      description: t.desc_physiotherapy,
      route: AppRoutes.physiotherapy,
    ),
    HomeService(
      id: 'psychologist',
      iconPath: 'assets/icons/ic_svc_psychologist.svg',
      accent: const Color(0xFF40108A),
      tint: const Color(0xFFF7F5FC),
      title: t.name_psychologist,
      description: t.desc_psychologist,
      route: AppRoutes.psychologist,
    ),
    HomeService(
      id: 'dietitian',
      iconPath: 'assets/icons/ic_svc_dietitian.svg',
      accent: const Color(0xFFEA430E),
      tint: const Color(0xFFFEF7F1),
      title: t.name_dietitian,
      description: t.desc_dietitian,
      route: AppRoutes.precisionNutrition,
    ),
    HomeService(
      id: 'optometrist',
      iconPath: 'assets/icons/ic_svc_optometrist.svg',
      accent: const Color(0xFF0E748A),
      tint: const Color(0xFFF4FAFA),
      title: t.name_optometrist,
      description: t.desc_optometrist,
      route: AppRoutes.optometrist,
    ),
    HomeService(
      id: 'nursing',
      iconPath: 'assets/icons/ic_svc_nursing.svg',
      accent: const Color(0xFFC73161),
      tint: const Color(0xFFFDF3F4),
      title: t.name_nursing,
      description: t.desc_nursing,
      route: AppRoutes.nursingServices,
    ),
    HomeService(
      id: 'diabetic_care',
      iconPath: 'assets/icons/ic_svc_diabetic_care.svg',
      accent: const Color(0xFF0833B6),
      tint: const Color(0xFFF4F8FC),
      title: t.name_diabetic_care,
      description: t.desc_diabetic_care,
      route: AppRoutes.diabeticCare,
    ),
    HomeService(
      id: 'home_screening',
      iconPath: 'assets/icons/ic_svc_home_screening.svg',
      accent: const Color(0xFF328E81),
      tint: const Color(0xFFF5FAF5),
      title: t.name_home_screening,
      description: t.desc_home_screening,
      route: AppRoutes.homeHealthScreening,
    ),
  ];

  items.add(HomeService(
    id: 'homecare_elderly',
    iconPath: 'assets/icons/ic_svc_homecare_elderly.svg',
    accent: const Color(0xFFD97706),
    tint: const Color(0xFFFDF7EC),
    title: t.name_homecare_elderly,
    description: t.desc_homecare_elderly,
    route: AppRoutes.homecareForElderly,
  ));

  if (all) {
    items.add(HomeService(
      id: 'second_opinion',
      iconPath: 'assets/icons/ic_svc_second_opinion.svg',
      accent: const Color(0xFF4338CA),
      tint: const Color(0xFFF3F3FD),
      title: t.name_second_opinion,
      description: t.desc_second_opinion,
      route: AppRoutes.secondOpinionMedical,
    ));
  }

  return items;
}

const _navy = Color(0xFF232F55);
const _muted = Color(0xFF6B7280);

class ServiceGridCard extends StatelessWidget {
  final HomeService service;
  const ServiceGridCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(service.route),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
        decoration: BoxDecoration(
          color: service.tint,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 18,
              child: service.isNew
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: service.accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          context.t.dashboard.home.badge_new,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            SvgPicture.asset(service.iconPath, width: 34, height: 34),
            const SizedBox(height: 10),
            Text(
              service.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _navy,
                fontSize: 11.5,
                height: 1.2,
                letterSpacing: -0.1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              service.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _muted,
                fontSize: 9.8,
                height: 1.32,
              ),
            ),
            const Spacer(),
            const SizedBox(height: 8),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: service.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward, size: 14, color: service.accent),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceListCard extends StatelessWidget {
  final HomeService service;
  const ServiceListCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(service.route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDEFF3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: service.tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child:
                    SvgPicture.asset(service.iconPath, width: 30, height: 30),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (service.isNew) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: service.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            context.t.dashboard.home.badge_new,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: service.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward, size: 15, color: service.accent),
            ),
          ],
        ),
      ),
    );
  }
}

/// Home page services block. Renders the 3-across grid or the single-column
/// list; the client can compare both from the toggle in the header.
class HomeServicesSection extends StatefulWidget {
  const HomeServicesSection({super.key});

  static const _prefsKey = 'home_services_layout';

  @override
  State<HomeServicesSection> createState() => _HomeServicesSectionState();
}

class _HomeServicesSectionState extends State<HomeServicesSection> {
  HomeServicesLayout _layout = HomeServicesLayout.grid;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(HomeServicesSection._prefsKey);
    if (saved == HomeServicesLayout.list.name && mounted) {
      setState(() => _layout = HomeServicesLayout.list);
    }
  }

  Future<void> _toggle() async {
    final next = _layout == HomeServicesLayout.grid
        ? HomeServicesLayout.list
        : HomeServicesLayout.grid;
    setState(() => _layout = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(HomeServicesSection._prefsKey, next.name);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.dashboard.home;
    final services = homeServices(context);

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
              color: _navy,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.section_subtitle,
            style: const TextStyle(color: _muted, fontSize: 12.5, height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LayoutToggle(layout: _layout, onTap: _toggle),
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
          if (_layout == HomeServicesLayout.grid)
            _ServiceGrid(services: services)
          else
            Column(
              children: [
                for (final s in services) ...[
                  ServiceListCard(service: s),
                  const SizedBox(height: 10),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

/// Three per row, each row as tall as its tallest card so descriptions are
/// never clipped. A GridView would force one aspect ratio on all of them.
class _ServiceGrid extends StatelessWidget {
  final List<HomeService> services;
  const _ServiceGrid({required this.services});

  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final rows = <List<HomeService>>[];
    for (var i = 0; i < services.length; i += 3) {
      rows.add(services.sublist(i, (i + 3).clamp(0, services.length)));
    }

    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: _gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
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

class _LayoutToggle extends StatelessWidget {
  final HomeServicesLayout layout;
  final VoidCallback onTap;
  const _LayoutToggle({required this.layout, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE3E7EE)),
        ),
        child: Icon(
          layout == HomeServicesLayout.grid
              ? Icons.view_agenda_outlined
              : Icons.grid_view_outlined,
          size: 18,
          color: _muted,
        ),
      ),
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
          border: Border.all(color: const Color(0xFFE3E7EE)),
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
                  color: Color(0xFF0F9AA8),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF0F9AA8)),
          ],
        ),
      ),
    );
  }
}

class AllServicesPage extends StatelessWidget {
  const AllServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = homeServices(context, all: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.t.dashboard.home.all_services_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => ServiceListCard(service: services[i]),
      ),
    );
  }
}
