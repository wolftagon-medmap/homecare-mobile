import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';

class WorkPreferencesState extends Equatable {
  const WorkPreferencesState({
    required this.preferences,
    this.isDirty = false,
    this.isSaving = false,
    this.error,
    this.saved,
  });

  final WorkPreferences preferences;
  final bool isDirty;
  final bool isSaving;
  final String? error;
  final WorkPreferences? saved;

  WorkPreferencesState copyWith({
    WorkPreferences? preferences,
    bool? isDirty,
    bool? isSaving,
    String? error,
    WorkPreferences? saved,
  }) =>
      WorkPreferencesState(
        preferences: preferences ?? this.preferences,
        isDirty: isDirty ?? this.isDirty,
        isSaving: isSaving ?? this.isSaving,
        error: error,
        saved: saved,
      );

  @override
  List<Object?> get props => [preferences, isDirty, isSaving, error, saved];
}

class WorkPreferencesCubit extends Cubit<WorkPreferencesState> {
  WorkPreferencesCubit({
    required this.repository,
    required WorkPreferences initial,
  }) : super(WorkPreferencesState(preferences: initial));

  final ProfessionalProfileRepository repository;

  void update(WorkPreferences preferences) =>
      emit(state.copyWith(preferences: preferences, isDirty: true));

  Future<void> save() async {
    if (!state.isDirty || state.isSaving) return;

    emit(state.copyWith(isSaving: true));

    final result = await repository.saveWorkPreferences(state.preferences);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, error: failure.message)),
      (saved) => emit(WorkPreferencesState(preferences: saved, saved: saved)),
    );
  }
}
