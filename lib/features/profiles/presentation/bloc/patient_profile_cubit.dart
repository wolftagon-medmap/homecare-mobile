import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final GetProfiles getProfilesUseCase;
  final UpdateProfile updateProfileUseCase;

  PatientProfileCubit({
    required this.getProfilesUseCase,
    required this.updateProfileUseCase,
  }) : super(PatientProfileInitial());

  /// Survives Loading/Saving/Success, which would otherwise erase the choice:
  /// saving an edit emits Success before reloading, and reading the selection
  /// back off the state at that point would find no Loaded state to read.
  int? _activeProfileId;

  /// The profile the app is acting for, or null before the first load.
  /// Lets any feature read the active profile without depending on the state type.
  Profile? get activeProfile {
    final current = state;
    return current is PatientProfileLoaded ? current.activeProfile : null;
  }

  Future<void> loadProfiles() async {
    emit(PatientProfileLoading());

    final result = await getProfilesUseCase();
    result.fold(
      (failure) {
        log('Failed to load profiles: ${failure.message}',
            name: 'PatientProfileCubit');
        if (failure is UnauthorizedFailure) {
          emit(PatientProfileUnauthenticated());
        } else {
          emit(PatientProfileError(failure.message));
        }
      },
      (profiles) {
        if (profiles.isEmpty) {
          emit(const PatientProfileError('No profile found for this account'));
          return;
        }
        _activeProfileId = _resolveActiveId(profiles, _activeProfileId);
        emit(PatientProfileLoaded(profiles, _activeProfileId!));
      },
    );
  }

  /// Switch which profile the app acts for. Ignores ids this account doesn't own.
  void setActiveProfile(int profileId) {
    final current = state;
    if (current is! PatientProfileLoaded) return;
    if (!current.profiles.any((profile) => profile.id == profileId)) return;
    if (current.activeProfileId == profileId) return;

    _activeProfileId = profileId;
    emit(PatientProfileLoaded(current.profiles, profileId));
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    emit(PatientProfileSaving());
    final result = await updateProfileUseCase(params);
    result.fold(
      (failure) => emit(PatientProfileError(failure.message)),
      (_) {
        emit(const PatientProfileSuccess('Profile updated successfully!'));
        loadProfiles();
      },
    );
  }

  /// Keeps the previously selected profile when it still exists, otherwise falls
  /// back to the account holder's own profile.
  int _resolveActiveId(List<Profile> profiles, int? previousActiveId) {
    if (previousActiveId != null &&
        profiles.any((profile) => profile.id == previousActiveId)) {
      return previousActiveId;
    }
    return profiles
        .firstWhere((profile) => profile.isPrimary,
            orElse: () => profiles.first)
        .id;
  }
}
