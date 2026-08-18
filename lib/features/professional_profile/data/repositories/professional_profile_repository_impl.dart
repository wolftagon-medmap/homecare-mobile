import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/data/datasources/expertise_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_profile_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/service_area_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/work_preference_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/models/expertise_model.dart';
import 'package:m2health/features/professional_profile/data/models/work_preferences_model.dart';
import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';

class ProfessionalProfileRepositoryImpl extends ProfessionalProfileRepository {
  ProfessionalProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.expertiseDatasource,
    required this.workPreferenceDatasource,
    required this.serviceAreaDatasource,
  });

  final ProfessionalProfileRemoteDatasource remoteDatasource;
  final ExpertiseRemoteDatasource expertiseDatasource;
  final WorkPreferenceRemoteDatasource workPreferenceDatasource;
  final ServiceAreaRemoteDatasource serviceAreaDatasource;

  List<LeveledEntry>? _conditions;
  List<LeveledEntry>? _languages;
  List<CareStyleTrait>? _traits;
  final Map<String, List<AreaOption>> _areas = {};

  @override
  Future<Either<Failure, ProfessionalProfile>> getProfessionalProfile() async {
    try {
      final profile = await remoteDatasource.getProfessionalProfile();
      return Right(profile);
    } catch (e, stackTrace) {
      log('Failed to fetch professional profile',
          error: e,
          name: 'ProfessionalProfileRepositoryImpl',
          stackTrace: stackTrace);
      if (e is Failure) {
        return Left(e);
      }
      return const Left(ServerFailure('Failed to fetch professional profile'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfessionalProfile(
      UpdateProfessionalProfileParams params) async {
    try {
      final profileData = {
        'name': params.name,
        'country_code': params.countryCode,
        'about': params.about,
        'job_title': params.jobTitle,
        'experience': params.experience,
        'service_radius_preference': params.serviceRadiusPreference,
        'gender': params.gender,
        'emergency_contact_name': params.emergencyContactName,
        'emergency_contact_relationship': params.emergencyContactRelationship,
        'emergency_contact_phone': params.emergencyContactPhone,
      };

      await remoteDatasource.updateProfessionalProfile(
        profileData,
        params.avatar,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfessionalProfile>>
      submitProfessionalVerification() async {
    try {
      final profile = await remoteDatasource.submitForVerification();
      return Right(profile);
    } catch (e, stackTrace) {
      log('Failed to submit professional verification',
          error: e,
          name: 'ProfessionalProfileRepositoryImpl',
          stackTrace: stackTrace);
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  // --- Catalogues ---

  @override
  Future<Either<Failure, List<LeveledEntry>>> conditionCatalog() =>
      _attempt('condition catalogue', () async {
        return _conditions ??= await expertiseDatasource.conditionCatalog();
      });

  @override
  Future<Either<Failure, List<LeveledEntry>>> languageCatalog() =>
      _attempt('language catalogue', () async {
        return _languages ??= await expertiseDatasource.languageCatalog();
      });

  @override
  Future<Either<Failure, List<CareStyleTrait>>> careStyleCatalog() =>
      _attempt('care style catalogue', () async {
        return _traits ??= await workPreferenceDatasource.careStyleCatalog();
      });

  @override
  Future<Either<Failure, List<AreaOption>>> areas(String countryCode) =>
      _attempt('area catalogue', () async {
        final key = countryCode.toUpperCase();
        return _areas[key] ??= await serviceAreaDatasource.listAreas(key);
      });

  // --- Saves ---

  @override
  Future<Either<Failure, List<LeveledEntry>>> saveConditionExperience(
          List<LeveledEntry> entries) =>
      _attempt('condition experience', () async {
        return expertiseDatasource
            .updateConditionExperience(_asLeveledModels(entries));
      });

  @override
  Future<Either<Failure, List<LeveledEntry>>> saveLanguages(
          List<LeveledEntry> entries) =>
      _attempt('languages', () async {
        return expertiseDatasource.updateLanguages(_asLeveledModels(entries));
      });

  @override
  Future<Either<Failure, List<CareStyleTrait>>> saveCareStyle(
          List<CareStyleTrait> traits) =>
      _attempt('care style', () async {
        return workPreferenceDatasource.updateCareStyle([
          for (final t in traits)
            CareStyleTraitModel(code: t.code, label: t.label),
        ]);
      });

  @override
  Future<Either<Failure, WorkPreferences>> saveWorkPreferences(
          WorkPreferences preferences) =>
      _attempt('work preferences', () async {
        return workPreferenceDatasource
            .updatePreferences(WorkPreferencesModel.fromEntity(preferences));
      });

  @override
  Future<Either<Failure, List<ServiceArea>>> saveServiceAreas(
          String countryCode, List<String> codes) =>
      _attempt('service areas', () async {
        return serviceAreaDatasource.updateServiceAreas(countryCode, codes);
      });

  @override
  Future<Either<Failure, ServiceArea?>> saveResidentialArea(
          String countryCode, String? code) =>
      _attempt('residential area', () async {
        return serviceAreaDatasource.updateResidentialArea(countryCode, code);
      });

  /// Only levelled entries the professional actually claims reach the server;
  /// the catalogue rows sit at 0 and the validator rejects them.
  List<LeveledEntryModel> _asLeveledModels(List<LeveledEntry> entries) => [
        for (final e in entries)
          if (e.isClaimed)
            LeveledEntryModel(code: e.code, label: e.label, level: e.level),
      ];

  Future<Either<Failure, T>> _attempt<T>(
      String what, Future<T> Function() call) async {
    try {
      return Right(await call());
    } catch (e, stackTrace) {
      log('Failed to resolve $what',
          error: e,
          name: 'ProfessionalProfileRepositoryImpl',
          stackTrace: stackTrace);
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
