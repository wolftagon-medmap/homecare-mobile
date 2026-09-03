import 'package:equatable/equatable.dart';

enum HealthQuestionType {
  singleChoice,
  multiChoice,
  chipMultiChoice,
  longText;

  static HealthQuestionType fromWire(String? value) => switch (value) {
        'single_choice' => HealthQuestionType.singleChoice,
        'chip_multi_choice' => HealthQuestionType.chipMultiChoice,
        'long_text' => HealthQuestionType.longText,
        _ => HealthQuestionType.multiChoice,
      };

  bool get isMultiple =>
      this == HealthQuestionType.multiChoice ||
      this == HealthQuestionType.chipMultiChoice;
}

class HealthOption extends Equatable {
  final String code;
  final String label;

  /// Clears every other answer on its question when picked, and is cleared by
  /// them. "I'm not sure" cannot coexist with a named condition.
  final bool exclusive;

  const HealthOption({
    required this.code,
    required this.label,
    this.exclusive = false,
  });

  @override
  List<Object?> get props => [code, label, exclusive];
}

class HealthEnableWhen extends Equatable {
  final String question;
  final List<String> notIn;

  const HealthEnableWhen({required this.question, required this.notIn});

  bool isSatisfiedBy(Object? answer) =>
      answer is String && answer.isNotEmpty && !notIn.contains(answer);

  @override
  List<Object?> get props => [question, notIn];
}

class HealthQuestion extends Equatable {
  final String code;
  final String text;
  final HealthQuestionType type;
  final String? group;
  final String? hint;
  final List<HealthOption> options;
  final bool allowsCustom;
  final String? customLabel;
  final bool allowsAttachments;
  final HealthEnableWhen? enableWhen;

  const HealthQuestion({
    required this.code,
    required this.text,
    required this.type,
    this.group,
    this.hint,
    this.options = const [],
    this.allowsCustom = false,
    this.customLabel,
    this.allowsAttachments = false,
    this.enableWhen,
  });

  String get attachmentsKey => '${code}_attachments';

  bool isExclusive(String optionCode) =>
      options.any((option) => option.code == optionCode && option.exclusive);

  /// An answer the option list does not contain is one the user typed.
  bool isCustomValue(String value) =>
      allowsCustom && !options.any((option) => option.code == value);

  @override
  List<Object?> get props => [
        code,
        text,
        type,
        group,
        hint,
        options,
        allowsCustom,
        customLabel,
        allowsAttachments,
        enableWhen,
      ];
}
