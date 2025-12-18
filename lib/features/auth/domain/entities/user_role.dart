enum UserRole {
  patient,
  nurse,
  pharmacist,
  radiologist,
  caregiver,
  physiotherapist;

  String get value {
    switch (this) {
      case UserRole.patient:
        return 'patient';
      case UserRole.nurse:
        return 'nurse';
      case UserRole.pharmacist:
        return 'pharmacist';
      case UserRole.radiologist:
        return 'radiologist';
      case UserRole.caregiver:
        return 'caregiver';
      case UserRole.physiotherapist:
        return 'physiotherapist';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.nurse:
        return 'Nurse';
      case UserRole.pharmacist:
        return 'Pharmacist';
      case UserRole.radiologist:
        return 'Radiologist';
      case UserRole.caregiver:
        return 'Caregiver/Helper';
      case UserRole.physiotherapist:
        return 'Physiotherapist';
    }
  }
}
