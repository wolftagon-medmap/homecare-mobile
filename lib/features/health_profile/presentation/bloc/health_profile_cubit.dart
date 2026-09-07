import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_state.dart';

class HealthProfileCubit extends Cubit<HealthProfileState> {
  final GetHealthSections getSections;

  HealthProfileCubit(this.getSections) : super(const HealthProfileState());

  int? _patientProfileId;

  Future<void> load(int? patientProfileId) async {
    _patientProfileId = patientProfileId;
    emit(state.copyWith(status: HealthProfileStatus.loading));

    final result = await getSections(patientProfileId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: HealthProfileStatus.error,
        errorMessage: failure.message,
      )),
      (sections) => emit(state.copyWith(
        status: HealthProfileStatus.ready,
        sections: sections,
      )),
    );
  }

  Future<void> refresh() => load(_patientProfileId);
}
