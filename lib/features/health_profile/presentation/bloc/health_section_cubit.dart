import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';

/// Matches the API's limits (contract C4), so the app never sends a save the
/// server will refuse.
const int maxOwnTextLength = 100;
const int maxOwnTexts = 5;
const int maxLongTextLength = 2000;

class HealthSectionCubit extends Cubit<HealthSectionState> {
  final String code;
  final int? patientProfileId;
  final GetHealthSection getSection;
  final SaveHealthSection saveSection;

  HealthSectionCubit({
    required this.code,
    required this.patientProfileId,
    required this.getSection,
    required this.saveSection,
  }) : super(const HealthSectionState());

  Future<void> load() async {
    emit(state.copyWith(status: HealthSectionStatus.loading));

    final result = await getSection(code, patientProfileId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: HealthSectionStatus.loadFailed,
        failure: failure,
      )),
      (section) => emit(state.copyWith(
        status: HealthSectionStatus.ready,
        section: section,
        answers: Map<String, Object>.from(section.answers),
      )),
    );
  }

  void setText(HealthQuestion question, String value) =>
      _write(question.code, value);

  void selectOne(HealthQuestion question, String value) {
    final current = state.answers[question.code];
    _write(question.code, current == value ? '' : value);
  }

  void toggleMany(HealthQuestion question, String value) {
    final selected = List<String>.from(state.selection(question.code));

    if (selected.contains(value)) {
      selected.remove(value);
    } else if (question.isExclusive(value)) {
      selected
        ..clear()
        ..add(value);
    } else {
      selected
        ..removeWhere(question.isExclusive)
        ..add(value);
    }

    _write(question.code, selected);
  }

  bool canAddCustomValue(HealthQuestion question) {
    if (!question.allowsCustom) return false;
    if (question.type != HealthQuestionType.multiChoice) return true;
    final own = state.selection(question.code).where(question.isCustomValue);
    return own.length < maxOwnTexts;
  }

  void addCustomValue(HealthQuestion question, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty ||
        trimmed.length > maxOwnTextLength ||
        !canAddCustomValue(question)) {
      return;
    }

    if (question.type == HealthQuestionType.multiChoice) {
      final selected = List<String>.from(state.selection(question.code));
      if (selected.contains(trimmed)) return;
      selected
        ..removeWhere(question.isExclusive)
        ..add(trimmed);
      _write(question.code, selected);
      return;
    }

    _write(question.code, trimmed);
  }

  void removeValue(HealthQuestion question, String value) {
    if (question.type == HealthQuestionType.multiChoice) {
      final selected = List<String>.from(state.selection(question.code))
        ..remove(value);
      _write(question.code, selected);
      return;
    }
    if (state.answers[question.code] == value) _write(question.code, '');
  }

  /// True when saved. On failure the answers stay as the patient left them.
  Future<bool> save() async {
    if (!state.canSave) return false;
    emit(state.copyWith(status: HealthSectionStatus.saving));

    final result = await saveSection(
      code: code,
      answers: state.payload,
      patientProfileId: patientProfileId,
    );
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: HealthSectionStatus.ready,
          failure: failure,
        ));
        return false;
      },
      (section) {
        emit(state.copyWith(
          status: HealthSectionStatus.ready,
          section: section,
          answers: Map<String, Object>.from(section.answers),
        ));
        return true;
      },
    );
  }

  void _write(String key, Object value) {
    emit(state.copyWith(
      status: HealthSectionStatus.ready,
      answers: {...state.answers, key: value},
    ));
  }
}
