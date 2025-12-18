import 'package:flutter/material.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';

class MusculoskeletalPhysiotherapyPage extends StatelessWidget {
  const MusculoskeletalPhysiotherapyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Musculoskeletal Physiotherapy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: const [
              _FeatureCard(),
              SizedBox(height: 32),
              _ReasonList(),
              SizedBox(height: 32),
              _BenefitList(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: PrimaryButton(
          text: 'Book Appointment',
          onPressed: () {},
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard();

  static const Color mainColor = Color(0xFF10B981);

  static const treatmentItems = [
    'Posture & movement correction',
    'Stretching & strengthening',
    'Exercise therapy',
    'Manual therapy',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: mainColor),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -16,
            right: -16,
            child: Image.asset(
              'assets/illustration/physiotherapy_musculoskeletal.png',
              width: 140,
              height: 96,
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DURATION',
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '45–60 minutes per session',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'TREATMENT TYPE',
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              ...treatmentItems.map(
                (item) => Text(
                  '• $item',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReasonList extends StatelessWidget {
  const _ReasonList();

  static const reasonList = [
    'Overuse tendon injuries',
    'Joint wear and tear (e.g. arthritis)',
    'Muscle strain',
    'Ligament sprain',
    'Joint pain & stiffness',
    'Movement-related pain',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const Text(
          'This Service is suitable for:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...reasonList.map(
          (item) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitList extends StatelessWidget {
  const _BenefitList();

  static const benefitList = [
    'Pain reduction',
    'Improved mobility',
    'Better joint function',
    'Easier daily activities',
    'Faster recovery',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const Text(
          'What you’ll get',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...benefitList.map(
          (item) => Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 20),
              Text(
                item,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
