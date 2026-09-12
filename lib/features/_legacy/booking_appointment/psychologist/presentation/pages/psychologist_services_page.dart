import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/etc/pricing/presentation/widgets/starting_from_price.dart';
import 'package:m2health/route/app_routes.dart';

class PsychologistServicesPage extends StatelessWidget {
  const PsychologistServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Psychologist',
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
                priceTag: const StartingFromPrice(category: 'psychology'),
                title: 'Psychology Consultation',
                description:
                    'Talk to a licensed psychologist about stress, anxiety, '
                    'relationships, and your overall mental well-being. Book a '
                    'private one-on-one session at a time that suits you.',
                imagePath: 'assets/icons/ic_psychologist.png',
                imageHeight: 100,
                imageWidth: 100,
                backgroundColor: const Color(0xFFB28CFF).withValues(alpha: 0.2),
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.psychologistBooking);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
