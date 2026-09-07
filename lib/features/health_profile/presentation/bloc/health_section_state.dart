import 'package:equatable/equatable.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

enum HealthSectionStatus { initial, loading, ready, saving, saved, error }

class HealthSectionState extends Equatable {
  final HealthSectionStatus status;
  final HealthSection? section;
  final Map<String, dynamic> answers;
  final Map<String, dynamic> savedAnswers;
  final bool uploading;
  final String? errorMessage;

  const HealthSectionState({
    this.status = HealthSectionStatus.initial,
    this.section,
    this.answers = const {},
    this.savedAnswers = const {},
    this.uploading = false,
    this.errorMessage,
  });

  List<HealthQuestion> get visibleQuestions =>
      section?.visibleFor(answers) ?? const [];

  /// A question hidden by `enable_when` keeps its answer in state so it returns
  /// if the condition comes back, but that answer must never reach the record.
  Map<String, dynamic> get visibleAnswers {
    final keep = <String>{};
    for (final question in visibleQuestions) {
      keep
        ..add(question.code)
        ..add(question.attachmentsKey);
    }
    return {
      for (final entry in answers.entries)
        if (keep.contains(entry.key)) entry.key: entry.value,
    };
  }

  bool get isDirty {
    final visible = visibleAnswers;
    if (visible.length != savedAnswers.length) return true;
    for (final entry in visible.entries) {
      if (!_sameAnswer(entry.value, savedAnswers[entry.key])) return true;
    }
    return false;
  }

  bool get canSave =>
      isDirty && status != HealthSectionStatus.saving && !uploading;

  List<String> selection(String questionCode) {
    final value = answers[questionCode];
    if (value is List) return value.map((item) => '$item').toList();
    if (value is String && value.isNotEmpty) return [value];
    return const [];
  }

  String text(String questionCode) {
    final value = answers[questionCode];
    return value is String ? value : '';
  }

  List<int> attachments(String questionCode) {
    final value = answers['${questionCode}_attachments'];
    if (value is List) return value.whereType<int>().toList();
    return const [];
  }

  HealthSectionState copyWith({
    HealthSectionStatus? status,
    HealthSection? section,
    Map<String, dynamic>? answers,
    Map<String, dynamic>? savedAnswers,
    bool? uploading,
    String? errorMessage,
  }) {
    return HealthSectionState(
      status: status ?? this.status,
      section: section ?? this.section,
      answers: answers ?? this.answers,
      savedAnswers: savedAnswers ?? this.savedAnswers,
      uploading: uploading ?? this.uploading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, section, answers, savedAnswers, uploading, errorMessage];
}

bool _sameAnswer(Object? a, Object? b) {
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
  return a == b;
}
