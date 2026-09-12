import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

enum MobilityStatus {
  bedbound,
  wheelchair,
  walkingAid,
  independent;

  String get apiValue {
    switch (this) {
      case MobilityStatus.bedbound:
        return 'bedbound';
      case MobilityStatus.wheelchair:
        return 'wheelchair';
      case MobilityStatus.walkingAid:
        return 'walkingAid';
      case MobilityStatus.independent:
        return 'independent';
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case MobilityStatus.bedbound:
        return context.l10n.booking_mobility_bedbound;
      case MobilityStatus.wheelchair:
        return context.l10n.booking_mobility_wheelchair_bound;
      case MobilityStatus.walkingAid:
        return context.l10n.booking_mobility_walking_aid;
      case MobilityStatus.independent:
        return context.l10n.booking_mobility_mobile_without_aid;
    }
  }

  static MobilityStatus? fromApiValue(String? value) {
    if (value == null) return null;
    return MobilityStatus.values.firstWhereOrNull((e) => e.apiValue == value);
  }
}
