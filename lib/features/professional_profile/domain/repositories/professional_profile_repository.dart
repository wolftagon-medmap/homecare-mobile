import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';

abstract class ProfessionalProfileRepository {
  Future<Either<Failure, ProfessionalProfile>> getProfessionalProfile();
  Future<Either<Failure, Unit>> updateProfessionalProfile(
      UpdateProfessionalProfileParams params);
  Future<Either<Failure, ProfessionalProfile>> submitProfessionalVerification();

  // Catalogues. Static per deployment, so the implementation may cache them.
  Future<Either<Failure, List<LeveledEntry>>> conditionCatalog();
  Future<Either<Failure, List<LeveledEntry>>> languageCatalog();
  Future<Either<Failure, List<CareStyleTrait>>> careStyleCatalog();
  Future<Either<Failure, List<AreaOption>>> areas(String countryCode);

  // Each save replaces the whole list, which is what the screens submit.
  Future<Either<Failure, List<LeveledEntry>>> saveConditionExperience(
      List<LeveledEntry> entries);
  Future<Either<Failure, List<LeveledEntry>>> saveLanguages(
      List<LeveledEntry> entries);
  Future<Either<Failure, List<CareStyleTrait>>> saveCareStyle(
      List<CareStyleTrait> traits);
  Future<Either<Failure, WorkPreferences>> saveWorkPreferences(
      WorkPreferences preferences);
  Future<Either<Failure, List<ServiceArea>>> saveServiceAreas(
      String countryCode, List<String> codes);
  Future<Either<Failure, ServiceArea?>> saveResidentialArea(
      String countryCode, String? code);
}
