import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';

class LeveledEntryModel extends LeveledEntry {
  const LeveledEntryModel({
    required super.code,
    required super.label,
    super.level,
  });

  /// Serves both the catalogues, which carry no level, and the professional's
  /// own claims, which do.
  factory LeveledEntryModel.fromJson(Map<String, dynamic> json) {
    return LeveledEntryModel(
      code: json['code'] as String,
      label: json['label'] as String? ?? json['code'] as String,
      level: (json['level'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'level': level};
}

class CareStyleTraitModel extends CareStyleTrait {
  const CareStyleTraitModel({required super.code, required super.label});

  factory CareStyleTraitModel.fromJson(Map<String, dynamic> json) {
    return CareStyleTraitModel(
      code: json['code'] as String,
      label: json['label'] as String? ?? json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'code': code};
}
