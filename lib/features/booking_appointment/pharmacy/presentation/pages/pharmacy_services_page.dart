import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/health_coaching.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/smoking_cessation/presentation/bloc/smoking_cessation_flow_cubit.dart';
import 'package:m2health/features/smoking_cessation/presentation/pages/smoking_cessation_flow_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class PharmacyServicesPage extends StatelessWidget {
  const PharmacyServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.pharmacy.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceSelectionCard(
                title: context.t.pharmacy.services.review_and_counseling.title,
                description: context
                    .t.pharmacy.services.review_and_counseling.description,
                imagePath: 'assets/icons/ilu_pharmacist.png',
                backgroundColor: const Color(0xFFF79E1B).withValues(alpha: 0.1),
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.chatPharmaAI);
                },
              ),
              ServiceSelectionCard(
                title: context.t.pharmacy.services.health_coaching.title,
                description:
                    context.t.pharmacy.services.health_coaching.description,
                imagePath: 'assets/icons/ilu_coach.png',
                backgroundColor:
                    const Color(0xFF9AE1FF).withValues(alpha: 0.33),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthCoaching(),
                    ),
                  );
                },
              ),
              ServiceSelectionCard(
                title: context.t.pharmacy.services.smoking_cessation.title,
                description:
                    context.t.pharmacy.services.smoking_cessation.description,
                imagePath: 'assets/icons/ilu_lung.png',
                backgroundColor:
                    const Color(0xFFFF9A9A).withValues(alpha: 0.19),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SmokingCessationFlowCubit(
                          createPharmacyAppointment: sl(),
                        ),
                        child: const SmokingCessationFlowPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
