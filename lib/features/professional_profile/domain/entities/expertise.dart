import 'package:equatable/equatable.dart';

/// The scales the PRD asks for. It defines only 0 and 5, so the words for 1-4
/// are a proposal agreed with the PM, not a specification.
enum LevelScale { language, experience, proficiency }

extension LevelScaleX on LevelScale {
  /// Single-letter prefix shown in a chip, e.g. the `E` in `Dementia E4`.
  /// Proficiency keeps `S` for service, which is what the PRD's own example
  /// line uses (`Wound Care S4`).
  String get prefix => switch (this) {
        LevelScale.language => 'L',
        LevelScale.experience => 'E',
        LevelScale.proficiency => 'S',
      };

  String labelFor(int level) {
    if (level < minLevel || level > maxLevel) return 'None';
    if (this == LevelScale.language) {
      return const [
        'Basic',
        'Elementary',
        'Conversational',
        'Fluent',
        'Native',
      ][level - 1];
    }
    return const [
      'Some exposure',
      'Basic',
      'Competent',
      'Experienced',
      'Expert',
    ][level - 1];
  }

  static const int minLevel = 1;
  static const int maxLevel = 5;
}

/// One thing a professional claims, at a level. Codes come from the server
/// catalogues, never from the label.
class LeveledEntry extends Equatable {
  const LeveledEntry({
    required this.code,
    required this.label,
    this.level = 0,
  });

  final String code;
  final String label;

  /// 0 means not claimed. The server never stores 0; it is how the picker says
  /// "nothing selected".
  final int level;

  bool get isClaimed => level >= LevelScaleX.minLevel;

  LeveledEntry copyWith({String? label, int? level}) => LeveledEntry(
        code: code,
        label: label ?? this.label,
        level: level ?? this.level,
      );

  /// Compact form for a chip: `Dementia E4`.
  String badge(LevelScale scale) => '$label ${scale.prefix}$level';

  @override
  List<Object?> get props => [code, label, level];
}
