import 'package:equatable/equatable.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';

/// A section with no questions of its own opens a page the app already has.
enum HealthSectionRoute {
  mentalState,

  /// A route this app version does not know; the section is hidden.
  unknown,
}

class HealthSectionSummary extends Equatable {
  final String code;
  final String title;
  final HealthSectionRoute? opensRoute;
  final DateTime? updatedAt;

  const HealthSectionSummary({
    required this.code,
    required this.title,
    this.opensRoute,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [code, title, opensRoute, updatedAt];
}

class HealthSection extends Equatable {
  final String code;
  final String title;
  final List<HealthQuestion> questions;
  final Map<String, Object> answers;
  final DateTime? updatedAt;

  const HealthSection({
    required this.code,
    required this.title,
    this.questions = const [],
    this.answers = const {},
    this.updatedAt,
  });

  /// Questions that apply to [answers], in order. A follow-up always comes
  /// after the question that controls it, so one pass resolves chains.
  List<HealthQuestion> applicableFor(Map<String, Object> answers) {
    final shown = <String>{};
    final result = <HealthQuestion>[];
    for (final question in questions) {
      final rule = question.enableWhen;
      final applies = rule == null ||
          (shown.contains(rule.question) &&
              rule.isSatisfiedBy(answers[rule.question]));
      if (!applies) continue;
      shown.add(question.code);
      result.add(question);
    }
    return result;
  }

  @override
  List<Object?> get props => [code, title, questions, answers, updatedAt];
}
