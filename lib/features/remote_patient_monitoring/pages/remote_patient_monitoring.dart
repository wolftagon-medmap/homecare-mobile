import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/remote_patient_monitoring/enums/vital_category.dart';
import 'package:m2health/route/app_routes.dart';

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
            const _VitalCard(
              category: VitalCategory.heartPerformance,
              backgroundColor: Color.fromRGBO(154, 225, 255, 0.25),
              foregroundColor: Color(0xFF35C5CF),
            ),
            const _VitalCard(
              category: VitalCategory.bloodOxygen,
              backgroundColor: Color.fromRGBO(178, 140, 255, 0.2),
              foregroundColor: Color(0xFFB393FF),
            ),
            const _VitalCard(
              category: VitalCategory.bloodGlucose,
              backgroundColor: Color.fromRGBO(255, 154, 154, 0.19),
              foregroundColor: Color(0xFFFF9A9A),
            ),
            const _VitalCard(
              category: VitalCategory.bloodPressure,
              backgroundColor: Color.fromRGBO(247, 158, 27, 0.1),
              foregroundColor: Color(0xFFF79E1B),
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
  final VitalCategory category;
  final Color backgroundColor;
  final Color foregroundColor;

  const _VitalCard({
    required this.category,
    required this.backgroundColor,
    required this.foregroundColor,
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
                  child: SvgPicture.asset(category.iconPath),
                ),
                Expanded(
                  child: Text(
                    category.displayName(context),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
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
                      GoRouter.of(context).pushNamed(
                        AppRoutes.monitoringBluetoothSearchDevice,
                        extra: category,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Const.aqua),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      context.l10n.rpm_link_device,
                      style: const TextStyle(color: Const.aqua),
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
                      side: const BorderSide(color: Const.aqua),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      context.l10n.rpm_add_record,
                      style: const TextStyle(color: Const.aqua),
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
