import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

enum VitalCategory {
  heartPerformance(
    iconPath: "assets/icons/ic_heart.svg",
    serviceUuidStrings: [
      '180D', // Heart Rate
    ],
  ),
  bloodOxygen(
    iconPath: "assets/icons/ic_oxygen.svg",
    serviceUuidStrings: [
      '1822', // Pulse Oximeter
    ],
  ),
  bloodGlucose(
    iconPath: "assets/icons/ic_blood.svg",
    serviceUuidStrings: [
      '1808', // Glucose
    ],
  ),
  bloodPressure(
    iconPath: "assets/icons/ic_bloodpressure.svg",
    serviceUuidStrings: [
      '1810', // Blood Pressure
    ],
  );

  final List<String> serviceUuidStrings;
  final String iconPath;

  const VitalCategory({
    required this.serviceUuidStrings,
    required this.iconPath,
  });

  List<Guid> get serviceUuids =>
      serviceUuidStrings.map((s) => Guid(s)).toList();

  String displayName(BuildContext context) {
    switch (this) {
      case heartPerformance:
        return context.l10n.rpm_heart_performance;
      case bloodOxygen:
        return context.l10n.rpm_blood_oxygen;
      case bloodGlucose:
        return context.l10n.rpm_blood_glucose;
      case bloodPressure:
        return context.l10n.rpm_blood_pressure;
    }
  }
}
