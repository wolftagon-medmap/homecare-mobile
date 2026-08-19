import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/mental_health_state.dart';

abstract class MentalHealthStateState extends Equatable {
  const MentalHealthStateState();

  @override
  List<Object?> get props => [];
}

class MentalHealthStateInitial extends MentalHealthStateState {}

class MentalHealthStateLoading extends MentalHealthStateState {}

class MentalHealthStateSaving extends MentalHealthStateState {}

class MentalHealthStateLoaded extends MentalHealthStateState {
  final MentalHealthState mentalHealthState;

  const MentalHealthStateLoaded(this.mentalHealthState);

  @override
  List<Object?> get props => [mentalHealthState];
}

class MentalHealthStateSuccess extends MentalHealthStateState {
  final String message;

  const MentalHealthStateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MentalHealthStateError extends MentalHealthStateState {
  final String message;

  const MentalHealthStateError(this.message);

  @override
  List<Object?> get props => [message];
}