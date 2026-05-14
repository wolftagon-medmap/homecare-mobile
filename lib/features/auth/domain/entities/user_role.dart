import 'package:flutter/material.dart';
import 'package:m2health/i18n/translations.g.dart';

enum UserRole {
  patient,
  nurse,
  pharmacist,
  radiologist,
  caregiver,
  physiotherapist,
  pathologist,
  nutritionist,
  psychologist,
  optometrist;

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
      case UserRole.pathologist:
        return 'pathologist';
      case UserRole.nutritionist:
        return 'nutritionist';
      case UserRole.psychologist:
        return 'psychologist';
      case UserRole.optometrist:
        return 'optometrist';
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
      case UserRole.pathologist:
        return t.auth.user_role.pathologist;
      case UserRole.nutritionist:
        return t.auth.user_role.nutritionist;
      case UserRole.psychologist:
        return t.auth.user_role.psychologist;
      case UserRole.optometrist:
        return t.auth.user_role.optometrist;
    }
  }
}

const PROFESSIONAL_ROLES = [
  UserRole.nurse,
  UserRole.pharmacist,
  UserRole.radiologist,
  UserRole.caregiver,
  UserRole.physiotherapist,
  UserRole.pathologist,
  UserRole.nutritionist,
  UserRole.psychologist,
  UserRole.optometrist,
];

const List<UserRole> ALL_USER_ROLES = [
  UserRole.patient,
  ...PROFESSIONAL_ROLES,
];
