import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/nursing/const.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/bloc/nursing_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_appointment_flow_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class NursingService extends StatefulWidget {
  const NursingService({super.key});
  @override
  State<NursingService> createState() => _NursingState();
}

class NursingCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const NursingCard(
      {super.key,
      required this.pharma,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 357,
        height: 243,
        padding: const EdgeInsets.all(16.0),
        color: color, // Set the background color with 10% opacity
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pharma['title']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${pharma['description']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400, // Light font weight
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        context.t.global.book_now,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF35C5CF),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        'assets/icons/ic_play.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: -25,
              right: -20,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0), // Adjust the padding as needed
                  child: Image.asset(
                    pharma['imagePath']!,
                    width: 185,
                    height: 139,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NursingState extends State<NursingService> {
  List<Map<String, String>> _getNursingServices(BuildContext context) {
    return [
      {
        'title': context.t.nursing.services.primary_nursing.title,
        'description': context.t.nursing.services.primary_nursing.description,
        'imagePath': 'assets/icons/ilu_nurse.png',
        'color': '9AE1FF',
        'opacity': '0.3',
      },
      {
        'title': context.t.nursing.services.specialized_nursing.title,
        'description': context.t.nursing.services.specialized_nursing.description,
        'imagePath': 'assets/icons/ilu_nurse_special.png',
        'color': 'B28CFF',
        'opacity': '0.2',
      },
    ];
  }

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
    final services = _getNursingServices(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.nursing.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final tender = services[index];
                  return NursingCard(
                    pharma: tender,
                    onTap: () {
                      switch (index) {
                        case 0:
                          _navigateToType(NurseServiceType.primaryNurse);
                          break;
                        case 1:
                          _navigateToType(NurseServiceType.specializedNurse);
                          break;
                        default:
                          Navigator.pushNamed(context, AppRoutes.home);
                      }
                    },
                    color: Color(int.parse('0xFF${tender['color']}'))
                        .withOpacity(tender['opacity'] != null
                            ? double.parse(tender['opacity']!)
                            : 1.0),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
