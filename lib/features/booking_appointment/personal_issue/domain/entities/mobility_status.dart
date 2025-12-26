import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

enum MobilityStatus {
  bedbound,
  wheelchairBound,
  walkingAid,
  mobileWithoutAid;

  String get apiValue {
    switch (this) {
      case MobilityStatus.bedbound:
        return 'bedbound';
      case MobilityStatus.wheelchairBound:
        return 'wheelchairBound';
      case MobilityStatus.walkingAid:
        return 'walkingAid';
      case MobilityStatus.mobileWithoutAid:
        return 'mobileWithoutAid';
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case MobilityStatus.bedbound:
        return context.l10n.booking_mobility_bedbound;
      case MobilityStatus.wheelchairBound:
        return context.l10n.booking_mobility_wheelchair_bound;
      case MobilityStatus.walkingAid:
        return context.l10n.booking_mobility_walking_aid;
      case MobilityStatus.mobileWithoutAid:
        return context.l10n.booking_mobility_mobile_without_aid;
    }
  }

  static MobilityStatus? fromApiValue(String? value) {
    if (value == null) return null;
    return MobilityStatus.values.firstWhereOrNull((e) => e.apiValue == value);
  }
}
