import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';

class RemotePatientMonitoring extends StatelessWidget {
  const RemotePatientMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate =
        DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString())
            .format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.rpm_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(color: Colors.grey.shade200),
            _VitalCard(
              icon: SvgPicture.asset('assets/icons/ic_heart.svg'),
              title: context.l10n.rpm_heart_performance,
              backgroundColor: const Color.fromRGBO(154, 225, 255, 0.25),
              textColor: const Color(0xFF35C5CF),
            ),
            _VitalCard(
              icon: SvgPicture.asset('assets/icons/ic_oxygen.svg'),
              title: context.l10n.rpm_blood_oxygen,
              backgroundColor: const Color.fromRGBO(178, 140, 255, 0.2),
              textColor: const Color(0xFFB393FF),
            ),
            _VitalCard(
              icon: SvgPicture.asset('assets/icons/ic_blood.svg'),
              title: context.l10n.rpm_blood_glucose,
              backgroundColor: const Color.fromRGBO(255, 154, 154, 0.19),
              textColor: const Color(0xFFFF9A9A),
            ),
            _VitalCard(
              icon: SvgPicture.asset('assets/icons/ic_bloodpressure.svg'),
              title: context.l10n.rpm_blood_pressure,
              backgroundColor: const Color.fromRGBO(247, 158, 27, 0.1),
              textColor: const Color(0xFFF79E1B),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: PrimaryButton(
          text: context.l10n.rpm_add_new_vital,
          onPressed: () {
            // Handle add new vital
          },
        ),
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  const _VitalCard({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: icon,
                ),
                const Spacer(),
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle link device
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Const.tosca),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      context.l10n.rpm_link_device,
                      style: const TextStyle(color: Const.tosca),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle add record
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Const.tosca),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      context.l10n.rpm_add_record,
                      style: const TextStyle(color: Const.tosca),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
