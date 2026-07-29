import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';

abstract class PatientProfileState extends Equatable {
  const PatientProfileState();

  @override
  List<Object?> get props => [];
}

class PatientProfileInitial extends PatientProfileState {}

class PatientProfileLoading extends PatientProfileState {}

class PatientProfileSaving extends PatientProfileState {}

class PatientProfileLoaded extends PatientProfileState {
  final Profile profile;

  const PatientProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class PatientProfileSuccess extends PatientProfileState {
  final String message;

  const PatientProfileSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientProfileError extends PatientProfileState {
  final String message;

  const PatientProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class PatientProfileUnauthenticated extends PatientProfileState {}
