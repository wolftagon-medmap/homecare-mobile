import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_state.dart';

class HealthProfileCubit extends Cubit<HealthProfileState> {
  final GetHealthSections getSections;
  final int? patientProfileId;
  final bool isAccountHolder;

  HealthProfileCubit({
    required this.getSections,
    required this.patientProfileId,
    required this.isAccountHolder,
  }) : super(const HealthProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: HealthProfileStatus.loading));

    final result = await getSections(patientProfileId);
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

  // The mental state page is per account, so it must not open under a family member.
  bool _isShown(HealthSectionSummary section) => switch (section.opensRoute) {
        null => true,
        HealthSectionRoute.mentalState => isAccountHolder,
        HealthSectionRoute.unknown => false,
      };
}
