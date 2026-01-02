import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/features/booking_appointment/nursing/const.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/bloc/nursing_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_appointment_flow_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

class NursingService extends StatefulWidget {
  const NursingService({super.key});
  @override
  State<NursingService> createState() => _NursingState();
}

class _NursingState extends State<NursingService> {
  void _navigateToType(NurseServiceType serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => NursingAppointmentFlowBloc(
            createNursingAppointment: sl(),
            serviceType: serviceType,
          ),
          child: const NursingAppointmentFlowPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.nursing.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: ListView(
          children: [
            ServiceSelectionCard(
              title: context.t.nursing.services.primary_nursing.title,
              description:
                  context.t.nursing.services.primary_nursing.description,
              imagePath: 'assets/icons/ilu_nurse.png',
              backgroundColor: const Color(0xFF9AE1FF).withValues(alpha: 0.33),
              onTap: () {
                _navigateToType(NurseServiceType.primaryNurse);
              },
            ),
            ServiceSelectionCard(
              title: context.t.nursing.services.specialized_nursing.title,
              description:
                  context.t.nursing.services.specialized_nursing.description,
              imagePath: 'assets/icons/ilu_nurse_special.png',
              backgroundColor: const Color(0xFFB28CFF).withValues(alpha: 0.2),
              onTap: () {
                _navigateToType(NurseServiceType.specializedNurse);
              },
            ),
          ],
        ),
      ),
    );
  }
}
