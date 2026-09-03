import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';

class HealthSectionCubit extends Cubit<HealthSectionState> {
  final String code;
  final int? patientProfileId;
  final GetHealthSection getSection;
  final SaveHealthSection saveSection;
  final UploadHealthAttachment uploadAttachment;

  HealthSectionCubit({
    required this.code,
    required this.patientProfileId,
    required this.getSection,
    required this.saveSection,
    required this.uploadAttachment,
  }) : super(const HealthSectionState());

  Future<void> load() async {
    emit(state.copyWith(status: HealthSectionStatus.loading));

    final result = await getSection(code, patientProfileId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: HealthSectionStatus.error,
        errorMessage: failure.message,
      )),
      (section) => emit(state.copyWith(
        status: HealthSectionStatus.ready,
        section: section,
        answers: Map<String, dynamic>.from(section.answers),
        savedAnswers: Map<String, dynamic>.from(section.answers),
      )),
    );
  }

  void setText(String questionCode, String value) =>
      _write(questionCode, value);

  void selectOne(HealthQuestion question, String optionCode) {
    final current = state.answers[question.code];
    _write(question.code, current == optionCode ? '' : optionCode);
  }

  /// Exclusive options and the rest of the list cannot coexist, so picking
  /// either side clears the other.
  void toggleMany(HealthQuestion question, String optionCode) {
    final selected = List<String>.from(state.selection(question.code));

    if (selected.contains(optionCode)) {
      selected.remove(optionCode);
    } else if (question.isExclusive(optionCode)) {
      selected
        ..clear()
        ..add(optionCode);
    } else {
      selected
        ..removeWhere(question.isExclusive)
        ..add(optionCode);
    }

    _write(question.code, selected);
  }

  void addCustomValue(HealthQuestion question, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    if (question.type.isMultiple) {
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
    if (question.type.isMultiple) {
      final selected = List<String>.from(state.selection(question.code))
        ..remove(value);
      _write(question.code, selected);
      return;
    }
    if (state.answers[question.code] == value) _write(question.code, '');
  }

  Future<void> attach(HealthQuestion question, String filePath) async {
    emit(state.copyWith(uploading: true));

    final result = await uploadAttachment(filePath);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        uploading: false,
        errorMessage: failure.message,
      )),
      (id) {
        final ids = List<int>.from(state.attachments(question.code))..add(id);
        emit(state.copyWith(
          uploading: false,
          answers: {...state.answers, question.attachmentsKey: ids},
        ));
      },
    );
  }

  void removeAttachment(HealthQuestion question, int id) {
    final ids = List<int>.from(state.attachments(question.code))..remove(id);
    _write(question.attachmentsKey, ids);
  }

  Future<HealthSection?> save() async {
    emit(state.copyWith(status: HealthSectionStatus.saving));

    final result = await saveSection(
      code: code,
      answers: state.answers,
      patientProfileId: patientProfileId,
    );
    if (isClosed) return null;

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: HealthSectionStatus.error,
          errorMessage: failure.message,
        ));
        return null;
      },
      (section) {
        emit(state.copyWith(
          status: HealthSectionStatus.saved,
          section: section,
          answers: Map<String, dynamic>.from(section.answers),
          savedAnswers: Map<String, dynamic>.from(section.answers),
        ));
        return section;
      },
    );
  }

  void _write(String key, Object? value) {
    emit(state.copyWith(
      status: HealthSectionStatus.ready,
      answers: {...state.answers, key: value},
    ));
  }
}
