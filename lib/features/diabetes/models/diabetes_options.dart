import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

// Helper to find enum by value
T? _fromValue<T>(List<T> values, String? value, String Function(T) valueGetter) {
  if (value == null) return null;
  try {
    return values.firstWhere((e) => valueGetter(e) == value);
  } catch (_) {
    return null;
  }
}

enum DiabetesTypeOption {
  type1('Type 1'),
  type2('Type 2'),
  gestational('Gestational'),
  other('Other');

  final String value;
  const DiabetesTypeOption(this.value);

  String label(BuildContext context) {
    switch (this) {
      case DiabetesTypeOption.type1:
        return context.l10n.diabetes_type_1;
      case DiabetesTypeOption.type2:
        return context.l10n.diabetes_type_2;
      case DiabetesTypeOption.gestational:
        return context.l10n.diabetes_type_gestational;
      case DiabetesTypeOption.other:
        return context.l10n.common_other;
    }
  }

  static DiabetesTypeOption? fromValue(String? value) {
    // If value is not one of the predefined ones, it's treated as 'Other' logic in UI,
    // but strictly for the enum mapping, we only map exact matches.
    // However, the UI logic for 'Other' usually checks if it's NOT one of the others.
    return _fromValue(DiabetesTypeOption.values, value, (e) => e.value);
  }
}

enum HypoglycemiaLevel {
  none('None'),
  mild('Mild'),
  severe('Severe');

  final String value;
  const HypoglycemiaLevel(this.value);

  String label(BuildContext context) {
    switch (this) {
      case HypoglycemiaLevel.none:
        return context.l10n.hypoglycemia_none;
      case HypoglycemiaLevel.mild:
        return context.l10n.hypoglycemia_mild;
      case HypoglycemiaLevel.severe:
        return context.l10n.hypoglycemia_severe;
    }
  }

  static HypoglycemiaLevel? fromValue(String? value) =>
      _fromValue(HypoglycemiaLevel.values, value, (e) => e.value);
}

enum PhysicalActivityLevel {
  regular('Regular'),
  occasional('Occasional'),
  sedentary('Sedentary');

  final String value;
  const PhysicalActivityLevel(this.value);

  String label(BuildContext context) {
    switch (this) {
      case PhysicalActivityLevel.regular:
        return context.l10n.activity_regular;
      case PhysicalActivityLevel.occasional:
        return context.l10n.activity_occasional;
      case PhysicalActivityLevel.sedentary:
        return context.l10n.activity_sedentary;
    }
  }

  static PhysicalActivityLevel? fromValue(String? value) =>
      _fromValue(PhysicalActivityLevel.values, value, (e) => e.value);
}

enum DietQuality {
  healthy('Healthy'),
  needsImprovement('Needs Improvement');

  final String value;
  const DietQuality(this.value);

  String label(BuildContext context) {
    switch (this) {
      case DietQuality.healthy:
        return context.l10n.diet_healthy;
      case DietQuality.needsImprovement:
        return context.l10n.diet_needs_improvement;
    }
  }

  static DietQuality? fromValue(String? value) =>
      _fromValue(DietQuality.values, value, (e) => e.value);
}

enum SmokingStatus {
  current('Current'),
  former('Former'),
  never('Never');

  final String value;
  const SmokingStatus(this.value);

  String label(BuildContext context) {
    switch (this) {
      case SmokingStatus.current:
        return context.l10n.smoking_current;
      case SmokingStatus.former:
        return context.l10n.smoking_former;
      case SmokingStatus.never:
        return context.l10n.smoking_never;
    }
  }

  static SmokingStatus? fromValue(String? value) =>
      _fromValue(SmokingStatus.values, value, (e) => e.value);
}

enum FeetSkinStatus {
  normal('Normal'),
  dry('Dry'),
  ulcer('Ulcer'),
  infection('Infection');

  final String value;
  const FeetSkinStatus(this.value);

  String label(BuildContext context) {
    switch (this) {
      case FeetSkinStatus.normal:
        return context.l10n.skin_normal;
      case FeetSkinStatus.dry:
        return context.l10n.skin_dry;
      case FeetSkinStatus.ulcer:
        return context.l10n.skin_ulcer;
      case FeetSkinStatus.infection:
        return context.l10n.skin_infection;
    }
  }

  static FeetSkinStatus? fromValue(String? value) =>
      _fromValue(FeetSkinStatus.values, value, (e) => e.value);
}

enum FeetDeformityStatus {
  none('None'),
  bunions('Bunions'),
  clawToes('Claw toes');

  final String value;
  const FeetDeformityStatus(this.value);

  String label(BuildContext context) {
    switch (this) {
      case FeetDeformityStatus.none:
        return context.l10n.deformity_none;
      case FeetDeformityStatus.bunions:
        return context.l10n.deformity_bunions;
      case FeetDeformityStatus.clawToes:
        return context.l10n.deformity_claw_toes;
    }
  }

  static FeetDeformityStatus? fromValue(String? value) =>
      _fromValue(FeetDeformityStatus.values, value, (e) => e.value);
}
