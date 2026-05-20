enum NurseServiceType {
  primaryNurse,
  specializedNurse;

  String get label {
    switch (this) {
      case NurseServiceType.primaryNurse:
        return 'Nurse';
      case NurseServiceType.specializedNurse:
        return 'Specialized Nurse';
    }
  }

  @Deprecated('Use category and subcategory instead')
  String get apiValue {
    switch (this) {
      case NurseServiceType.primaryNurse:
        return 'nursing';
      case NurseServiceType.specializedNurse:
        return 'specialized_nursing';
    }
  }

  String get category => 'nursing';

  String? get subCategory {
    switch (this) {
      case NurseServiceType.primaryNurse:
        return 'basic';
      case NurseServiceType.specializedNurse:
        return 'specialized';
    }
  }

  @override
  String toString() => label;
}
