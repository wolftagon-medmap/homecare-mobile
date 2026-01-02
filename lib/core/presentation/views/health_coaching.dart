import 'package:flutter/material.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';

class HealthCoaching extends StatefulWidget {
  const HealthCoaching({super.key});

  @override
  State<HealthCoaching> createState() => _HealthCoachingState();
}

class _HealthCoachingState extends State<HealthCoaching> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health Coaching",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: ListView(
          children: [
            ServiceSelectionCard(
              title: 'Weight Management',
              description:
                  'Personalized plans and support to achieve and maintain a healthy weight.',
              imagePath: 'assets/images/illu_weight.png',
              backgroundColor: const Color(0xFF9AE1FF).withValues(alpha: 0.33),
              onTap: () {},
            ),
            ServiceSelectionCard(
              title: 'Diabetes Management',
              description:
                  'Guidance and strategies to effectively manage diabetes and maintain optimal health.',
              imagePath: 'assets/images/ilu_diabetes.png',
              backgroundColor: const Color(0xFFB28CFF).withValues(alpha: 0.2),
              onTap: () {},
            ),
            ServiceSelectionCard(
              title: 'High Blood Pressure Management',
              description:
                  'Customized coaching to control and reduce high blood pressure.',
              imagePath: 'assets/images/ilu_blood.png',
              backgroundColor: const Color(0xFFFF9A9A).withValues(alpha: 0.19),
              onTap: () {},
            ),
            ServiceSelectionCard(
              title: 'High Cholestrol Management',
              description:
                  'Tailored programs to lower cholesterol levels and improve heart health.',
              imagePath: 'assets/images/ilu_colestrol.png',
              backgroundColor: const Color(0xFFEDE6FC).withValues(alpha: 0.33),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
