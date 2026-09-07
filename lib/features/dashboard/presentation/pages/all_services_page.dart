import 'package:flutter/material.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_layout.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_list_card.dart';
import 'package:m2health/i18n/translations.g.dart';

class AllServicesPage extends StatelessWidget {
  const AllServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = homeServiceViews(context, all: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.t.dashboard.home.all_services_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: DashboardLayout.maxContentWidth),
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, 40 + MediaQuery.viewPaddingOf(context).bottom),
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => ServiceListCard(service: services[i]),
          ),
        ),
      ),
    );
  }
}
