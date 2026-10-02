import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

enum HealthProfileStatus { initial, loading, ready, error }

class HealthProfileState extends Equatable {
  final HealthProfileStatus status;
  final List<HealthSectionSummary> sections;
  final Failure? failure;

  const HealthProfileState({
    this.status = HealthProfileStatus.initial,
    this.sections = const [],
    this.failure,
  });

  HealthProfileState copyWith({
    HealthProfileStatus? status,
    List<HealthSectionSummary>? sections,
    Failure? failure,
  }) {
    return HealthProfileState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, sections, failure];
}
