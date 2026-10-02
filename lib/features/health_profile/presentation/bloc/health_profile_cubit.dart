import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/domain/entities/health_profile_subject.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_state.dart';

class HealthProfileCubit extends Cubit<HealthProfileState> {
  final GetHealthSections getSections;
  final HealthProfileSubject subject;

  HealthProfileCubit({required this.getSections, required this.subject})
      : super(const HealthProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: HealthProfileStatus.loading));

    final result = await getSections(subject.patientProfileId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: HealthProfileStatus.error,
        failure: failure,
      )),
      (sections) => emit(state.copyWith(
        status: HealthProfileStatus.ready,
        sections: sections.where(_isShown).toList(),
      )),
    );
  }

  // The mental state page stores data per account, so a family member's
  // profile must not open it under their name.
  bool _isShown(HealthSectionSummary section) => switch (section.opensRoute) {
        null => true,
        HealthSectionRoute.mentalState => subject.isAccountHolder,
        HealthSectionRoute.unknown => false,
      };
}
