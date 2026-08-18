import 'package:m2health/features/professional_profile/domain/entities/emergency_contact.dart';

class EmergencyContactModel extends EmergencyContact {
  const EmergencyContactModel({
    super.name,
    super.relationship,
    super.phone,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  /// Rides on `PUT /professionals/my-profile`, which is why the keys are
  /// prefixed rather than nested.
  Map<String, dynamic> toJson() => {
        'emergency_contact_name': name,
        'emergency_contact_relationship': relationship,
        'emergency_contact_phone': phone,
      };
}
