import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';

sealed class LanguagesCareStyleState extends Equatable {
  const LanguagesCareStyleState();

  @override
  List<Object?> get props => [];
}

class LanguagesCareStyleLoading extends LanguagesCareStyleState {
  const LanguagesCareStyleLoading();
}

class LanguagesCareStyleUnavailable extends LanguagesCareStyleState {
  const LanguagesCareStyleUnavailable(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class LanguagesCareStyleReady extends LanguagesCareStyleState {
  const LanguagesCareStyleReady({
    required this.languages,
    required this.traits,
    required this.selectedTraitCodes,
    this.languagesDirty = false,
    this.careStyleDirty = false,
    this.isSaving = false,
    this.error,
  });

  /// The whole catalogue with claimed levels merged in; unclaimed sit at 0.
  final List<LeveledEntry> languages;
  final List<CareStyleTrait> traits;
  final Set<String> selectedTraitCodes;
  final bool languagesDirty;
  final bool careStyleDirty;
  final bool isSaving;
  final String? error;

  bool get isDirty => languagesDirty || careStyleDirty;

  LanguagesCareStyleReady copyWith({
    List<LeveledEntry>? languages,
    Set<String>? selectedTraitCodes,
    bool? languagesDirty,
    bool? careStyleDirty,
    bool? isSaving,
    String? error,
  }) =>
      LanguagesCareStyleReady(
        languages: languages ?? this.languages,
        traits: traits,
        selectedTraitCodes: selectedTraitCodes ?? this.selectedTraitCodes,
        languagesDirty: languagesDirty ?? this.languagesDirty,
        careStyleDirty: careStyleDirty ?? this.careStyleDirty,
        isSaving: isSaving ?? this.isSaving,
        error: error,
      );

  @override
  List<Object?> get props => [
        languages,
        traits,
        selectedTraitCodes,
        languagesDirty,
        careStyleDirty,
        isSaving,
        error,
      ];
}

/// Emitted per endpoint that succeeded, so the profile cubit can fold each half
/// in even when the other one failed.
class LanguagesSaved extends LanguagesCareStyleState {
  const LanguagesSaved(this.languages);

  final List<LeveledEntry> languages;

  @override
  List<Object?> get props => [languages];
}

class CareStyleSaved extends LanguagesCareStyleState {
  const CareStyleSaved(this.traits);

  final List<CareStyleTrait> traits;

  @override
  List<Object?> get props => [traits];
}

/// One screen over two backend services: ExpertiseService owns language
/// proficiency, WorkPreferenceService owns care style. Naming it for either one
/// would hide the other.
class LanguagesCareStyleCubit extends Cubit<LanguagesCareStyleState> {
  LanguagesCareStyleCubit({required this.repository})
      : super(const LanguagesCareStyleLoading());

  final ProfessionalProfileRepository repository;

  Future<void> load({
    required List<LeveledEntry> claimedLanguages,
    required List<CareStyleTrait> claimedTraits,
  }) async {
    emit(const LanguagesCareStyleLoading());

    final (languageResult, traitResult) = await (
      repository.languageCatalog(),
      repository.careStyleCatalog(),
    ).wait;

    final failure = languageResult.fold((f) => f, (_) => null) ??
        traitResult.fold((f) => f, (_) => null);
    if (failure != null) {
      return emit(LanguagesCareStyleUnavailable(failure.message));
    }

    final languageCatalog = languageResult.getOrElse(() => const []);
    final traitCatalog = traitResult.getOrElse(() => const []);

    final levels = {for (final l in claimedLanguages) l.code: l.level};
    emit(LanguagesCareStyleReady(
      languages: [
        for (final entry in languageCatalog)
          entry.copyWith(level: levels[entry.code] ?? 0),
      ],
      traits: traitCatalog,
      selectedTraitCodes: {for (final t in claimedTraits) t.code},
    ));
  }

  void updateLanguages(List<LeveledEntry> languages) {
    final current = state;
    if (current is! LanguagesCareStyleReady) return;

    emit(current.copyWith(languages: languages, languagesDirty: true));
  }

  void updateTraits(Set<String> codes) {
    final current = state;
    if (current is! LanguagesCareStyleReady) return;

    emit(current.copyWith(selectedTraitCodes: codes, careStyleDirty: true));
  }

  /// Saves only what changed. A half that succeeds goes clean and is announced
  /// even when the other half fails, so nothing silently reports a total
  /// failure after part of the work landed.
  Future<void> save() async {
    final current = state;
    if (current is! LanguagesCareStyleReady || current.isSaving) return;

    emit(current.copyWith(isSaving: true));

    var languagesDirty = current.languagesDirty;
    var careStyleDirty = current.careStyleDirty;
    final failures = <String>[];

    if (current.languagesDirty) {
      final result = await repository.saveLanguages(current.languages);
      result.fold(
        (failure) => failures.add('languages (${failure.message})'),
        (saved) {
          languagesDirty = false;
          emit(LanguagesSaved(saved));
        },
      );
    }

    if (current.careStyleDirty) {
      final selected = [
        for (final t in current.traits)
          if (current.selectedTraitCodes.contains(t.code)) t,
      ];
      final result = await repository.saveCareStyle(selected);
      result.fold(
        (failure) => failures.add('care style (${failure.message})'),
        (saved) {
          careStyleDirty = false;
          emit(CareStyleSaved(saved));
        },
      );
    }

    emit(current.copyWith(
      isSaving: false,
      languagesDirty: languagesDirty,
      careStyleDirty: careStyleDirty,
      error:
          failures.isEmpty ? null : 'Could not save ${failures.join(' and ')}',
    ));
  }
}
