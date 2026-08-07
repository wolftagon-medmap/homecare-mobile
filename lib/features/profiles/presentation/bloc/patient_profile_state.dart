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
  /// The account holder's own profile plus any family members, primary first.
  final List<Profile> profiles;

  /// Which profile the app is currently acting for.
  final int activeProfileId;

  const PatientProfileLoaded(this.profiles, this.activeProfileId);

  /// The profile the app is acting for, falling back to the first one when the
  /// active id no longer resolves (e.g. it was just removed).
  Profile get activeProfile => profiles.firstWhere(
        (profile) => profile.id == activeProfileId,
        orElse: () => profiles.first,
      );

  /// The account holder's own profile.
  Profile get primaryProfile => profiles.firstWhere(
        (profile) => profile.isPrimary,
        orElse: () => profiles.first,
      );

  bool get isActiveProfilePrimary => activeProfile.isPrimary;

  @override
  List<Object?> get props => [profiles, activeProfileId];
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
