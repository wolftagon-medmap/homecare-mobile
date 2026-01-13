import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import 'package:m2health/features/physiotherapy/presentation/bloc/physiotherapy_appointment_flow_bloc.dart';
import 'package:m2health/features/physiotherapy/const.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/physiotherapy_appointment_flow_page.dart';
import 'package:m2health/service_locator.dart';

class NeurologicalPhysiotherapyPage extends StatelessWidget {
  const NeurologicalPhysiotherapyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.physiotherapy_neurological_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
          text: context.l10n.physiotherapy_book_appointment,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => PhysiotherapyAppointmentFlowBloc(
                    createPhysiotherapyAppointment: sl(),
                    type: PhysiotherapyType.neurological,
                  ),
                  child: const PhysiotherapyAppointmentFlowPage(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard();

  static const Color mainColor = Color(0xFFEE222B);

  @override
  Widget build(BuildContext context) {
    final treatmentItems = [
      context.l10n.physiotherapy_neuro_item_1,
      context.l10n.physiotherapy_neuro_item_2,
      context.l10n.physiotherapy_neuro_item_3,
      context.l10n.physiotherapy_neuro_item_4,
    ];

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
              'assets/illustration/physiotherapy_neurological.png',
              width: 140,
              height: 96,
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.physiotherapy_duration_label,
                style: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.physiotherapy_duration_value,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.physiotherapy_treatment_type_label,
                style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final reasonList = [
      context.l10n.physiotherapy_neuro_reason_1,
      context.l10n.physiotherapy_neuro_reason_2,
      context.l10n.physiotherapy_neuro_reason_3,
      context.l10n.physiotherapy_neuro_reason_4,
      context.l10n.physiotherapy_neuro_reason_5,
      context.l10n.physiotherapy_neuro_reason_6,
      context.l10n.physiotherapy_neuro_reason_7,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          context.l10n.physiotherapy_suitable_for_title,
          style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final benefitList = [
      context.l10n.physiotherapy_neuro_benefit_1,
      context.l10n.physiotherapy_neuro_benefit_2,
      context.l10n.physiotherapy_neuro_benefit_3,
      context.l10n.physiotherapy_neuro_benefit_4,
      context.l10n.physiotherapy_neuro_benefit_5,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          context.l10n.physiotherapy_what_you_get_title,
          style: const TextStyle(
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
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
