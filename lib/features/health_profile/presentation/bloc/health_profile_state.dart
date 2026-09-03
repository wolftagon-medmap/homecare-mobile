import 'package:equatable/equatable.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

enum HealthProfileStatus { initial, loading, ready, error }

class HealthProfileState extends Equatable {
  final HealthProfileStatus status;
  final List<HealthSectionSummary> sections;
  final String? errorMessage;

  const HealthProfileState({
    this.status = HealthProfileStatus.initial,
    this.sections = const [],
    this.errorMessage,
  });

  HealthProfileState copyWith({
    HealthProfileStatus? status,
    List<HealthSectionSummary>? sections,
    String? errorMessage,
  }) {
    return HealthProfileState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sections, errorMessage];
}
