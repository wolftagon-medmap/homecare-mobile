import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/pricing/presentation/widgets/starting_from_price.dart';
import 'package:m2health/route/app_routes.dart';

class OptometristServicesPage extends StatelessWidget {
  const OptometristServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Optometrist',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceSelectionCard(
                priceTag: const StartingFromPrice(category: 'optometry'),
                title: 'Eye Care Consultation',
                description:
                    'Have your vision and eye health checked by a qualified '
                    'optometrist. Book a consultation for eye exams, vision '
                    'correction advice, and personalized eye care.',
                imagePath: 'assets/icons/ic_optometrist.png',
                backgroundColor:
                    const Color(0xFF9AE1FF).withValues(alpha: 0.33),
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.optometristBooking);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
