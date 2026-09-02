import 'package:equatable/equatable.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';

abstract class ProfessionalProfileState extends Equatable {
  const ProfessionalProfileState();

  @override
  List<Object?> get props => [];
}

class ProfessionalProfileInitial extends ProfessionalProfileState {}

class ProfessionalProfileLoading extends ProfessionalProfileState {}

class ProfessionalProfileSaving extends ProfessionalProfileState {}

class ProfessionalProfileLoaded extends ProfessionalProfileState {
  final ProfessionalProfile profile;

  const ProfessionalProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfessionalProfileSuccess extends ProfessionalProfileState {
  final String message;

  const ProfessionalProfileSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfessionalProfileError extends ProfessionalProfileState {
  final String message;

  const ProfessionalProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfessionalProfileUnauthenticated extends ProfessionalProfileState {}

class ProfessionalProfileVerificationSubmitting
    extends ProfessionalProfileState {}

class ProfessionalProfileVerificationSubmitted
    extends ProfessionalProfileState {
  final String message;

  const ProfessionalProfileVerificationSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}
