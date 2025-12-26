import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

enum PhysiotherapyType {
  musculoskeletal,
  neurological;

  String getLabel(BuildContext context) {
    switch (this) {
      case PhysiotherapyType.musculoskeletal:
        return context.l10n.physiotherapy_musculoskeletal_title;
      case PhysiotherapyType.neurological:
        return context.l10n.physiotherapy_neurological_title;
    }
  }
}
