import 'package:equatable/equatable.dart';

enum HealthQuestionType {
  singleChoice,
  multiChoice,
  longText,

  /// Sent by a newer API. The question is not shown, and its stored answer is
  /// sent back unchanged so a save from this app never erases it.
  unknown;

  bool get isChoice => this == singleChoice || this == multiChoice;
}

enum HealthQuestionLayout { rows, chips, grid }

enum HealthOptionIcon { walk, gym, run, swim, bike }

class HealthOption extends Equatable {
  final String code;
  final String label;

  /// Clears every other answer on its question when picked, and is cleared by
  /// them. "I'm not sure" cannot coexist with a named condition.
  final bool exclusive;
  final HealthOptionIcon? icon;

  const HealthOption({
    required this.code,
    required this.label,
    this.exclusive = false,
    this.icon,
  });

  @override
  List<Object?> get props => [code, label, exclusive, icon];
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
  final HealthQuestionLayout layout;
  final String? group;
  final String? hint;
  final List<HealthOption> options;
  final bool allowsCustom;
  final String? customLabel;
  final HealthEnableWhen? enableWhen;

  const HealthQuestion({
    required this.code,
    required this.text,
    required this.type,
    this.layout = HealthQuestionLayout.rows,
    this.group,
    this.hint,
    this.options = const [],
    this.allowsCustom = false,
    this.customLabel,
    this.enableWhen,
  });

  bool isExclusive(String value) =>
      options.any((option) => option.code == value && option.exclusive);

  bool isCustomValue(String value) =>
      allowsCustom && !options.any((option) => option.code == value);

  @override
  List<Object?> get props => [
        code,
        text,
        type,
        layout,
        group,
        hint,
        options,
        allowsCustom,
        customLabel,
        enableWhen,
      ];
}
