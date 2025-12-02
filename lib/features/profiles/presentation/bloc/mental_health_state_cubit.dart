import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/profiles/domain/entities/mental_health_state.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/profiles/presentation/bloc/mental_health_state_state.dart';

class MentalHealthStateCubit extends Cubit<MentalHealthStateState> {
  final ProfileRepository repository;

  MentalHealthStateCubit({required this.repository})
      : super(MentalHealthStateInitial());

  Future<void> loadMentalHealthState() async {
    emit(MentalHealthStateLoading());
    final result = await repository.getMentalHealthState();
    result.fold(
      (failure) => emit(MentalHealthStateError(failure.message)),
      (mentalHealthState) => emit(MentalHealthStateLoaded(mentalHealthState)),
    );
  }

  Future<void> saveMentalHealthState(MentalHealthState data) async {
    emit(MentalHealthStateSaving());
    final result = await repository.updateMentalHealthState(data);
    result.fold(
      (failure) => emit(MentalHealthStateError(failure.message)),
      (_) {
        emit(const MentalHealthStateSuccess("Updated successfully!"));
        // Reload to get fresh data
        loadMentalHealthState();
      },
    );
  }
}