import 'package:m2health/features/profiles/domain/entities/onboarding_status.dart';

class OnboardingStatusModel extends OnboardingStatus {
  const OnboardingStatusModel({
    required super.canSubmit,
    required super.completedCount,
    required super.totalCount,
    required super.profile,
    required super.certificates,
    required super.services,
    required super.schedule,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    final steps = (json['steps'] as Map<String, dynamic>?) ?? const {};
    return OnboardingStatusModel(
      canSubmit: json['can_submit'] == true,
      completedCount: json['completed_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
      profile: _step(steps['profile']),
      certificates: _step(steps['certificates']),
      services: _step(steps['services']),
      schedule: _step(steps['schedule']),
    );
  }

  static OnboardingStep _step(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const OnboardingStep(complete: false);
    }
    return OnboardingStep(
      complete: json['complete'] == true,
      missing: (json['missing'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
