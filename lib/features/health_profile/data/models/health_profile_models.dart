import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

class HealthOptionModel extends HealthOption {
  const HealthOptionModel({
    required super.code,
    required super.label,
    super.exclusive,
    super.icon,
  });

  factory HealthOptionModel.fromJson(Map<String, dynamic> json) {
    return HealthOptionModel(
      code: json['code'] as String,
      label: json['label'] as String,
      exclusive: json['exclusive'] as bool? ?? false,
      icon: _byName(HealthOptionIcon.values, json['icon']),
    );
  }
}

class HealthQuestionModel extends HealthQuestion {
  const HealthQuestionModel({
    required super.code,
    required super.text,
    required super.type,
    super.layout,
    super.group,
    super.hint,
    super.options,
    super.allowsCustom,
    super.customLabel,
    super.enableWhen,
  });

  factory HealthQuestionModel.fromJson(Map<String, dynamic> json) {
    final wireType = json['type'] as String?;
    final enableWhen = json['enable_when'] as Map<String, dynamic>?;

    return HealthQuestionModel(
      code: json['code'] as String,
      text: json['text'] as String,
      type: _typeFromWire(wireType),
      layout: _byName(HealthQuestionLayout.values, json['layout']) ??
          (wireType == 'chip_multi_choice'
              ? HealthQuestionLayout.chips
              : HealthQuestionLayout.rows),
      group: json['group'] as String?,
      hint: json['hint'] as String?,
      options: ((json['options'] as List?) ?? const [])
          .map((option) =>
              HealthOptionModel.fromJson(option as Map<String, dynamic>))
          .toList(),
      allowsCustom: json['allows_custom'] as bool? ?? false,
      customLabel: json['custom_label'] as String?,
      enableWhen: enableWhen == null
          ? null
          : HealthEnableWhen(
              question: enableWhen['question'] as String,
              notIn: ((enableWhen['not_in'] as List?) ?? const [])
                  .map((value) => value as String)
                  .toList(),
            ),
    );
  }
}

class HealthSectionSummaryModel extends HealthSectionSummary {
  const HealthSectionSummaryModel({
    required super.code,
    required super.title,
    super.opensRoute,
  });

  factory HealthSectionSummaryModel.fromJson(Map<String, dynamic> json) {
    return HealthSectionSummaryModel(
      code: json['code'] as String,
      title: json['title'] as String,
      opensRoute: _routeFromWire(json['opens_route'] as String?),
    );
  }
}

class HealthSectionModel extends HealthSection {
  const HealthSectionModel({
    required super.code,
    required super.title,
    super.questions,
    super.answers,
    super.updatedAt,
  });

  factory HealthSectionModel.fromJson(Map<String, dynamic> json) {
    final rawAnswers = (json['answers'] as Map?) ?? const {};
    return HealthSectionModel(
      code: json['code'] as String,
      title: json['title'] as String,
      questions: ((json['questions'] as List?) ?? const [])
          .map((question) =>
              HealthQuestionModel.fromJson(question as Map<String, dynamic>))
          .toList(),
      answers: {
        for (final entry in rawAnswers.entries)
          if (entry.value != null) '${entry.key}': _answerFromWire(entry.value),
      },
      updatedAt: _parseDate(json['updated_at']),
    );
  }
}

HealthQuestionType _typeFromWire(String? value) => switch (value) {
      'single_choice' => HealthQuestionType.singleChoice,
      'multi_choice' || 'chip_multi_choice' => HealthQuestionType.multiChoice,
      'long_text' => HealthQuestionType.longText,
      _ => HealthQuestionType.unknown,
    };

HealthSectionRoute? _routeFromWire(String? value) => switch (value) {
      null => null,
      'mental_state' => HealthSectionRoute.mentalState,
      _ => HealthSectionRoute.unknown,
    };

Object _answerFromWire(Object value) =>
    value is List ? value.map((item) => '$item').toList() : value;

T? _byName<T extends Enum>(List<T> values, Object? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}

DateTime? _parseDate(Object? raw) =>
    raw is String ? DateTime.tryParse(raw)?.toLocal() : null;
