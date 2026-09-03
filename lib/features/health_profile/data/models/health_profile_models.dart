import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

class HealthOptionModel extends HealthOption {
  const HealthOptionModel({
    required super.code,
    required super.label,
    super.exclusive,
  });

  factory HealthOptionModel.fromJson(Map<String, dynamic> json) {
    return HealthOptionModel(
      code: json['code'] as String,
      label: json['label'] as String,
      exclusive: json['exclusive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() =>
      {'code': code, 'label': label, 'exclusive': exclusive};
}

class HealthQuestionModel extends HealthQuestion {
  const HealthQuestionModel({
    required super.code,
    required super.text,
    required super.type,
    super.group,
    super.hint,
    super.options,
    super.allowsCustom,
    super.customLabel,
    super.allowsAttachments,
    super.enableWhen,
  });

  factory HealthQuestionModel.fromJson(Map<String, dynamic> json) {
    final enableWhen = json['enable_when'] as Map<String, dynamic>?;
    return HealthQuestionModel(
      code: json['code'] as String,
      text: json['text'] as String,
      type: HealthQuestionType.fromWire(json['type'] as String?),
      group: json['group'] as String?,
      hint: json['hint'] as String?,
      options: ((json['options'] as List?) ?? const [])
          .map((option) =>
              HealthOptionModel.fromJson(option as Map<String, dynamic>))
          .toList(),
      allowsCustom: json['allows_custom'] as bool? ?? false,
      customLabel: json['custom_label'] as String?,
      allowsAttachments: json['allows_attachments'] as bool? ?? false,
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
    required super.description,
    super.opensRoute,
    super.questionCount,
    super.updatedAt,
  });

  factory HealthSectionSummaryModel.fromJson(Map<String, dynamic> json) {
    return HealthSectionSummaryModel(
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      opensRoute: HealthSectionRoute.fromWire(json['opens_route'] as String?),
      questionCount: json['question_count'] as int? ?? 0,
      updatedAt: _parseDate(json['updated_at']),
    );
  }
}

class HealthSectionModel extends HealthSection {
  const HealthSectionModel({
    required super.code,
    required super.title,
    required super.description,
    super.questions,
    super.answers,
    super.updatedAt,
  });

  factory HealthSectionModel.fromJson(Map<String, dynamic> json) {
    return HealthSectionModel(
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      questions: ((json['questions'] as List?) ?? const [])
          .map((question) =>
              HealthQuestionModel.fromJson(question as Map<String, dynamic>))
          .toList(),
      answers: Map<String, dynamic>.from(
          (json['answers'] as Map?) ?? const <String, dynamic>{}),
      updatedAt: _parseDate(json['updated_at']),
    );
  }
}

DateTime? _parseDate(Object? raw) =>
    raw is String ? DateTime.tryParse(raw)?.toLocal() : null;
