import 'package:equatable/equatable.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';

/// A section the client's document names but specifies no questions for. It
/// opens a screen the app already ships instead of inventing content.
enum HealthSectionRoute {
  mentalState;

  static HealthSectionRoute? fromWire(String? value) =>
      value == 'mental_state' ? HealthSectionRoute.mentalState : null;
}

class HealthSectionSummary extends Equatable {
  final String code;
  final String title;
  final String description;
  final HealthSectionRoute? opensRoute;
  final int questionCount;
  final DateTime? updatedAt;

  const HealthSectionSummary({
    required this.code,
    required this.title,
    required this.description,
    this.opensRoute,
    this.questionCount = 0,
    this.updatedAt,
  });

  bool get isStarted => updatedAt != null;

  @override
  List<Object?> get props =>
      [code, title, description, opensRoute, questionCount, updatedAt];
}

class HealthSection extends Equatable {
  final String code;
  final String title;
  final String description;
  final List<HealthQuestion> questions;
  final Map<String, dynamic> answers;
  final DateTime? updatedAt;

  const HealthSection({
    required this.code,
    required this.title,
    required this.description,
    this.questions = const [],
    this.answers = const {},
    this.updatedAt,
  });

  /// Questions whose `enable_when` is satisfied by the answers given so far.
  List<HealthQuestion> visibleFor(Map<String, dynamic> current) {
    return questions.where((question) {
      final rule = question.enableWhen;
      return rule == null || rule.isSatisfiedBy(current[rule.question]);
    }).toList();
  }

  @override
  List<Object?> get props =>
      [code, title, description, questions, answers, updatedAt];
}
