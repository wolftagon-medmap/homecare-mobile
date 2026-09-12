import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/patient_health_profile/etc/data/models/mental_health_state_model.dart';
import 'package:m2health/features/patient_health_profile/etc/domain/entities/mental_health_state.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Profile>>> getProfiles() async {
    try {
      final profiles = await remoteDatasource.getProfiles();
      // Hand back a real List<Profile>: the datasource's List<ProfileModel> only
      // *looks* like one, and List.firstWhere would then reject an orElse
      // returning the supertype.
      return Right(List<Profile>.from(profiles));
    } catch (e, stackTrace) {
      log('Failed to fetch profiles: $e',
          name: 'ProfileRepositoryImpl', stackTrace: stackTrace);
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> create(CreateProfileParams params) async {
    try {
      final profileData = {
        'name': params.name,
        'country_code': params.countryCode,
        'date_of_birth': _formatDate(params.dateOfBirth),
        'gender': params.gender,
        'relation': params.relation,
        'weight': params.weight,
        'height': params.height,
        'phone_number': params.phoneNumber,
      };

      final created =
          await remoteDatasource.createProfile(profileData, params.avatar);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(UpdateProfileParams params) async {
    try {
      final profileData = {
        'name': params.name,
        'country_code': params.countryCode,
        'date_of_birth': params.dateOfBirth != null
            ? _formatDate(params.dateOfBirth!)
            : null,
        'weight': params.weight,
        'height': params.height,
        'phone_number': params.phoneNumber,
        'gender': params.gender,
        'relation': params.relation,
      };

      await remoteDatasource.updateProfile(
          params.profileId, profileData, params.avatar);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(int profileId) async {
    try {
      await remoteDatasource.deleteProfile(profileId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// The API validates date_of_birth as YYYY-MM-DD.
  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  // --- Mental Health State Methods ---

  @override
  Future<Either<Failure, MentalHealthState>> getMentalHealthState() async {
    try {
      final state = await remoteDatasource.getMentalHealthState();
      return Right(state);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMentalHealthState(
      MentalHealthState state) async {
    try {
      final Map<String, dynamic> data =
          MentalHealthStateModel.fromEntity(state).toJson();
      await remoteDatasource.updateMentalHealthState(data);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
