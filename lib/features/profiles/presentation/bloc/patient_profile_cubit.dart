import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;

  PatientProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(PatientProfileInitial());

  Future<void> loadProfile() async {
    emit(PatientProfileLoading());

    final result = await getProfileUseCase();
    result.fold(
      (failure) {
        log('Failed to load profile: ${failure.message}',
            name: 'PatientProfileCubit');
        if (failure is UnauthorizedFailure) {
          emit(PatientProfileUnauthenticated());
        } else {
          emit(PatientProfileError(failure.message));
        }
      },
      (profile) => emit(PatientProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    emit(PatientProfileSaving());
    final result = await updateProfileUseCase(params);
    result.fold(
      (failure) => emit(PatientProfileError(failure.message)),
      (_) {
        emit(const PatientProfileSuccess('Profile updated successfully!'));
        loadProfile();
      },
    );
  }
}
