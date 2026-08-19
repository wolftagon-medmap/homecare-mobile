import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/professional_profile/data/models/expertise_model.dart';
import 'package:m2health/features/professional_profile/data/models/service_area_model.dart';
import 'package:m2health/features/professional_profile/data/models/work_preferences_model.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';

void main() {
  group('LeveledEntryModel', () {
    test('reads a catalogue row, which carries no level', () {
      final entry = LeveledEntryModel.fromJson(
          const {'code': 'dementia', 'label': 'Dementia'});

      expect(entry.level, 0);
      expect(entry.isClaimed, isFalse);
    });

    test('sends only the code and the level', () {
      const entry = LeveledEntryModel(code: 'zh', label: 'Mandarin', level: 5);

      expect(entry.toJson(), {'code': 'zh', 'level': 5});
    });
  });

  group('CareStyleTraitModel', () {
    test('sends the code alone, because traits are claimed not rated', () {
      const trait = CareStyleTraitModel(code: 'empathy', label: 'Empathy');

      expect(trait.toJson(), {'code': 'empathy'});
    });
  });

  group('WorkPreferencesModel', () {
    test('round-trips every key the server validates', () {
      const original = WorkPreferencesModel(
        targetWeeklyHours: 24,
        nightShift: true,
        longTermClient: true,
        clientGenderPreference: ClientGenderPreference.male,
        petFriendly: true,
      );

      final restored = WorkPreferencesModel.fromJson(original.toJson());

      expect(restored, original);
      expect(original.toJson().length, 13);
    });

    test('keeps a null target apart from zero', () {
      final prefs =
          WorkPreferencesModel.fromJson(const {'target_weekly_hours': null});

      expect(prefs.targetWeeklyHours, isNull);
      expect(prefs.toJson()['target_weekly_hours'], isNull);
    });
  });

  group('ServiceAreaModel', () {
    test('reads parent_name and country_code', () {
      final option = AreaOptionModel.fromJson(const {
        'country_code': 'sg',
        'code': 'BM',
        'name': 'Bukit Merah',
        'parent_name': 'Central Region',
      });

      expect(option.countryCode, 'SG');
      expect(option.parentName, 'Central Region');
    });

    test('tolerates a missing parent', () {
      final area =
          ServiceAreaModel.fromJson(const {'code': 'X', 'name': 'X Area'});

      expect(area.parentName, isNull);
    });
  });

  group('LevelScale', () {
    test('labels differ between languages and experience', () {
      expect(LevelScale.language.labelFor(5), 'Native');
      expect(LevelScale.experience.labelFor(5), 'Expert');
      expect(LevelScale.proficiency.prefix, 'S');
    });

    test('reads out of range as none', () {
      expect(LevelScale.language.labelFor(0), 'None');
      expect(LevelScale.language.labelFor(6), 'None');
    });
  });
}
