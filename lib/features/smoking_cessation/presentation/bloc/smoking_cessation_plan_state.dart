part of 'smoking_cessation_plan_cubit.dart';

enum SmokingCessationPlanStatus { initial, loading, success, failure }

class SmokingCessationPlanState extends Equatable {
  final SmokingCessationPlan plan;
  final SmokingCessationPlanStatus submitStatus;
  final SmokingCessationPlanStatus fetchStatus;
  final String? errorMessage;
  final bool prescribeMedication;

  const SmokingCessationPlanState({
    this.plan = const SmokingCessationPlan(),
    this.submitStatus = SmokingCessationPlanStatus.initial,
    this.fetchStatus = SmokingCessationPlanStatus.initial,
    this.errorMessage,
    this.prescribeMedication = false,
  });

  SmokingCessationPlanState copyWith({
    SmokingCessationPlan? plan,
    SmokingCessationPlanStatus? submitStatus,
    SmokingCessationPlanStatus? fetchStatus,
    String? errorMessage,
    bool? prescribeMedication,
  }) {
    return SmokingCessationPlanState(
      plan: plan ?? this.plan,
      submitStatus: submitStatus ?? this.submitStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      errorMessage: errorMessage,
      prescribeMedication: prescribeMedication ?? this.prescribeMedication,
    );
  }

  @override
  List<Object?> get props =>
      [plan, submitStatus, fetchStatus, errorMessage, prescribeMedication];
}
