import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_profile_remote_datasource.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';

class ProfessionalProfileRepositoryImpl extends ProfessionalProfileRepository {
  ProfessionalProfileRemoteDatasource remoteDatasource;

  ProfessionalProfileRepositoryImpl({required this.remoteDatasource});

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
        'working_hours': params.workHours,
        'workplace': params.workPlace,
        'experience': params.experience,
        'service_radius_preference': params.serviceRadiusPreference,
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
}
