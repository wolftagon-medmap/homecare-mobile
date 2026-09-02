import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';

sealed class ConditionExperienceState extends Equatable {
  const ConditionExperienceState();

  @override
  List<Object?> get props => [];
}

class ConditionExperienceLoading extends ConditionExperienceState {
  const ConditionExperienceLoading();
}

class ConditionExperienceUnavailable extends ConditionExperienceState {
  const ConditionExperienceUnavailable(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ConditionExperienceReady extends ConditionExperienceState {
  const ConditionExperienceReady({
    required this.entries,
    this.isDirty = false,
    this.isSaving = false,
    this.error,
  });

  /// The whole catalogue, with the professional's levels merged in. Unclaimed
  /// rows sit at 0 and are what the picker offers.
  final List<LeveledEntry> entries;
  final bool isDirty;
  final bool isSaving;
  final String? error;

  ConditionExperienceReady copyWith({
    List<LeveledEntry>? entries,
    bool? isDirty,
    bool? isSaving,
    String? error,
  }) =>
      ConditionExperienceReady(
        entries: entries ?? this.entries,
        isDirty: isDirty ?? this.isDirty,
        isSaving: isSaving ?? this.isSaving,
        error: error,
      );

  @override
  List<Object?> get props => [entries, isDirty, isSaving, error];
}

class ConditionExperienceSaved extends ConditionExperienceState {
  const ConditionExperienceSaved(this.entries);

  final List<LeveledEntry> entries;

  @override
  List<Object?> get props => [entries];
}

class ConditionExperienceCubit extends Cubit<ConditionExperienceState> {
  ConditionExperienceCubit({required this.repository})
      : super(const ConditionExperienceLoading());

  final ProfessionalProfileRepository repository;

  Future<void> load(List<LeveledEntry> claimed) async {
    emit(const ConditionExperienceLoading());

    final result = await repository.conditionCatalog();
    result.fold(
      (failure) => emit(ConditionExperienceUnavailable(failure.message)),
      (catalog) => emit(ConditionExperienceReady(
        entries: _merge(catalog, claimed),
      )),
    );
  }

  void update(List<LeveledEntry> entries) {
    final current = state;
    if (current is! ConditionExperienceReady) return;

    emit(current.copyWith(entries: entries, isDirty: true));
  }

  Future<void> save() async {
    final current = state;
    if (current is! ConditionExperienceReady || current.isSaving) return;

    emit(current.copyWith(isSaving: true));

    final result = await repository.saveConditionExperience(current.entries);
    result.fold(
      (failure) =>
          emit(current.copyWith(isSaving: false, error: failure.message)),
      (saved) {
        emit(ConditionExperienceSaved(saved));
        emit(ConditionExperienceReady(entries: _merge(current.entries, saved)));
      },
    );
  }

  /// Levels come from what the professional has claimed; labels and the set of
  /// rows come from the catalogue, so a renamed label follows the server.
  static List<LeveledEntry> _merge(
    List<LeveledEntry> catalog,
    List<LeveledEntry> claimed,
  ) {
    final levels = {for (final c in claimed) c.code: c.level};
    return [
      for (final entry in catalog)
        entry.copyWith(level: levels[entry.code] ?? 0),
    ];
  }
}
