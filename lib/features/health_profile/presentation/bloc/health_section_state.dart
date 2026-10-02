import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

enum HealthSectionStatus { initial, loading, loadFailed, ready, saving }

class HealthSectionState extends Equatable {
  final HealthSectionStatus status;
  final HealthSection? section;
  final Map<String, Object> answers;
  final Failure? failure;

  const HealthSectionState({
    this.status = HealthSectionStatus.initial,
    this.section,
    this.answers = const {},
    this.failure,
  });

  List<HealthQuestion> get visibleQuestions => [
        for (final question in section?.applicableFor(answers) ?? const [])
          if (question.type != HealthQuestionType.unknown) question,
      ];

  /// What a save sends: answers to questions that apply, unknown types
  /// included unchanged, nothing empty.
  Map<String, Object> get payload => _payloadFor(answers);

  bool get isDirty {
    final saved = _payloadFor(section?.answers ?? const {});
    final current = payload;
    if (saved.length != current.length) return true;
    for (final entry in current.entries) {
      if (!_sameAnswer(entry.value, saved[entry.key])) return true;
    }
    return false;
  }

  bool get canSave => isDirty && status == HealthSectionStatus.ready;

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

  Map<String, Object> _payloadFor(Map<String, Object> source) {
    final applicable = section?.applicableFor(source) ?? const [];
    return {
      for (final question in applicable)
        if (_hasValue(source[question.code]))
          question.code: source[question.code]!,
    };
  }

  HealthSectionState copyWith({
    HealthSectionStatus? status,
    HealthSection? section,
    Map<String, Object>? answers,
    Failure? failure,
  }) {
    return HealthSectionState(
      status: status ?? this.status,
      section: section ?? this.section,
      answers: answers ?? this.answers,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, section, answers, failure];
}

bool _hasValue(Object? value) =>
    value != null &&
    !(value is String && value.isEmpty) &&
    !(value is List && value.isEmpty);

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
