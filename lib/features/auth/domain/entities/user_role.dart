import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/i18n/translations.g.dart';

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

  String getDisplayName(BuildContext context) {
    switch (this) {
      case UserRole.patient:
        return t.auth.user_role.patient;
      case UserRole.nurse:
        return t.auth.user_role.nurse;
      case UserRole.pharmacist:
        return t.auth.user_role.pharmacist;
      case UserRole.radiologist:
        return t.auth.user_role.radiologist;
      case UserRole.caregiver:
        return t.auth.user_role.caregiver;
      case UserRole.physiotherapist:
        return t.auth.user_role.physiotherapist;
    }
  }
}
