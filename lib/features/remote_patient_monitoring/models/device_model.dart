import 'package:m2health/features/remote_patient_monitoring/enums/vital_category.dart';

class Device {
  final String name;
  final String imageUrl;
  final String description;
  final List<VitalCategory> supportedVitals;
  final String brandDisplayName;
  final String brandCode;

  const Device({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.supportedVitals,
    required this.brandDisplayName,
    required this.brandCode,
  });
}