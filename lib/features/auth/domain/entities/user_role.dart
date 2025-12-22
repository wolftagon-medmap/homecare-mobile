import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

enum UserRole {
  patient,
  nurse,
  pharmacist,
  radiologist,
  caregiver;

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
    }
  }

  String getDisplayName(BuildContext context) {
    switch (this) {
      case UserRole.patient:
        return context.l10n.auth_role_patient;
      case UserRole.nurse:
        return context.l10n.auth_role_nurse;
      case UserRole.pharmacist:
        return context.l10n.auth_role_pharmacist;
      case UserRole.radiologist:
        return context.l10n.auth_role_radiologist;
      case UserRole.caregiver:
        return context.l10n.auth_role_caregiver;
    }
  }
}
