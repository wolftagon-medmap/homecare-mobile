import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';

enum AdminActionStatus { initial, submitting, success, failure }

class AdminHomecareState extends Equatable {
  final List<ServiceEntity> services;
  final List<SubscriptionPlanEntity> plans;
  final bool isLoading;
  final String? error;
  final AdminActionStatus actionStatus;
  final String? actionError;

  const AdminHomecareState({
    this.services = const [],
    this.plans = const [],
    this.isLoading = false,
    this.error,
    this.actionStatus = AdminActionStatus.initial,
    this.actionError,
  });

  AdminHomecareState copyWith({
    List<ServiceEntity>? services,
    List<SubscriptionPlanEntity>? plans,
    bool? isLoading,
    String? error,
    AdminActionStatus? actionStatus,
    String? actionError,
  }) {
    return AdminHomecareState(
      services: services ?? this.services,
      plans: plans ?? this.plans,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      actionStatus: actionStatus ?? this.actionStatus,
      actionError: actionError,
    );
  }

  @override
  List<Object?> get props => [services, plans, isLoading, error, actionStatus, actionError];
}
