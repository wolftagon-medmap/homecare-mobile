import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/entities/provided_services.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/utils.dart';

class ProfessionalProfileCubit extends Cubit<ProfessionalProfileState> {
  final GetProfessionalProfile getProfessionalProfileUseCase;
  final UpdateProfessionalProfile updateProfessionalProfileUseCase;
  final SubmitProfessionalVerification submitProfessionalVerificationUseCase;

  String? _currentRole;

  ProfessionalProfileCubit({
    required this.getProfessionalProfileUseCase,
    required this.updateProfessionalProfileUseCase,
    required this.submitProfessionalVerificationUseCase,
  }) : super(ProfessionalProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfessionalProfileLoading());

    _currentRole = await Utils.getSpString(Const.ROLE);

    final result = await getProfessionalProfileUseCase();
    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure) {
          emit(ProfessionalProfileUnauthenticated());
        } else {
          emit(ProfessionalProfileError(failure.message));
        }
      },
      (profile) => emit(ProfessionalProfileLoaded(profile)),
    );
  }

  Future<void> updateProfessionalProfile(
      UpdateProfessionalProfileParams params) async {
    if (_currentRole == null) {
      emit(const ProfessionalProfileError(
          "Cannot update profile: role unknown."));
      return;
    }
    emit(ProfessionalProfileSaving());

    final fullParams = params.copyWith(role: _currentRole);

    final result = await updateProfessionalProfileUseCase(fullParams);
    result.fold(
      (failure) => emit(ProfessionalProfileError(failure.message)),
      (_) {
        emit(const ProfessionalProfileSuccess('Profile updated successfully!'));
        loadProfile();
      },
    );
  }

  Future<void> submitForVerification() async {
    emit(ProfessionalProfileVerificationSubmitting());
    final result = await submitProfessionalVerificationUseCase();
    result.fold(
      (failure) {
        emit(ProfessionalProfileError(failure.message));
        // Restore the loaded profile so the hub can rebuild its checklist.
        loadProfile();
      },
      (profile) {
        emit(const ProfessionalProfileVerificationSubmitted(
            'Your profile has been submitted for verification.'));
        emit(ProfessionalProfileLoaded(profile));
      },
    );
  }

  /// Folds a saved list back into the profile already in memory. Reloading
  /// instead would emit Loading and flash a spinner on the hub behind the
  /// screen that just saved.
  void applyConditionExperience(List<LeveledEntry> entries) =>
      _patch((profile) => profile.copyWith(conditionExperience: entries));

  void applyLanguages(List<LeveledEntry> languages) =>
      _patch((profile) => profile.copyWith(languages: languages));

  void applyCareStyle(List<CareStyleTrait> traits) =>
      _patch((profile) => profile.copyWith(careStyle: traits));

  void applyServices(ProvidedServices saved) => _patch(
        (profile) => profile.copyWith(
          providedServices: saved.services,
          serviceProficiency: saved.proficiency,
        ),
      );

  void _patch(ProfessionalProfile Function(ProfessionalProfile) change) {
    final current = state;
    if (current is! ProfessionalProfileLoaded) return;

    emit(ProfessionalProfileLoaded(change(current.profile)));
  }
}
