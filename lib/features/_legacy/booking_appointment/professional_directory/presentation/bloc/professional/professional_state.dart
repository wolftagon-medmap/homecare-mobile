import 'package:equatable/equatable.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

abstract class ProfessionalState extends Equatable {
  const ProfessionalState();

  @override
  List<Object> get props => [];
}

class ProfessionalInitial extends ProfessionalState {}

class ProfessionalLoading extends ProfessionalState {}

class ProfessionalLoaded extends ProfessionalState {
  final List<ProfessionalEntity> professionals;

  /// Set when a per-row action (e.g. favouriting) failed, so the page can
  /// surface it without tearing down the list.
  final String? actionError;

  const ProfessionalLoaded(this.professionals, {this.actionError});

  @override
  List<Object> get props => [professionals, actionError ?? ''];
}

class ProfessionalError extends ProfessionalState {
  final String message;

  const ProfessionalError(this.message);

  @override
  List<Object> get props => [message];
}
