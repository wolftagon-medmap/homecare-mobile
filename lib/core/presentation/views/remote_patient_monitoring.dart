import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(color: Colors.grey),
            _buildVitalCard(
              context,
              'assets/icons/ic_heart.png',
              context.l10n.rpm_heart_performance,
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
            _buildVitalCard(
              context,
              'assets/icons/ic_oxygen.png',
              context.l10n.rpm_blood_oxygen,
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
            _buildVitalCard(
              context,
              'assets/icons/ic_blood.png',
              context.l10n.rpm_blood_glucose,
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
            _buildVitalCard(
              context,
              'assets/icons/ic_bloodpressure.png',
              context.l10n.rpm_blood_pressure,
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          width: double.infinity,
          color: Const.tosca,
          child: Center(
            child: TextButton(
              onPressed: () {
                // Handle add new vital
              },
              child: Text(
                context.l10n.rpm_add_new_vital,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalCard(BuildContext context, String iconPath, String title,
      Color backgroundColor) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 89,
                  height: 80,
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
