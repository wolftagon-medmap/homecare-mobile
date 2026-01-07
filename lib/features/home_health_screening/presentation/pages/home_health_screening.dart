import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/home_health_screening_flow_bloc.dart';
import 'package:m2health/features/home_health_screening/presentation/pages/home_health_screening_flow_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class HomeHealth extends StatefulWidget {
  const HomeHealth({super.key});

  @override
  State<HomeHealth> createState() => _HomeHealthState();
}

class _HomeHealthState extends State<HomeHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.home_health_screening_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: ListView(
          children: [
            ServiceSelectionCard(
              title: context.l10n.home_health_at_home_diagnostic,
              description: context.l10n.home_health_at_home_diagnostic_desc,
              imagePath: 'assets/images/ilu_diagnostic.png',
              backgroundColor: const Color(0xFF9AE1FF).withValues(alpha: 0.33),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => HomeHealthScreeningFlowBloc(
                          createScreeningAppointment: sl()),
                      child: const HomeHealthScreeningFlowPage(),
                    ),
                  ),
                );
              },
            ),
            ServiceSelectionCard(
              title: context.l10n.home_health_point_of_care,
              description: context.l10n.home_health_point_of_care_desc,
              imagePath: 'assets/images/ilu_pointofcare.png',
              backgroundColor: const Color(0xFFB28CFF).withValues(alpha: 0.2),
              onTap: () {
                GoRouter.of(context).go(AppRoutes.medicalStore);
              },
            ),
          ],
        ),
      ),
    );
  }
}
