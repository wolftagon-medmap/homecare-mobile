import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';

abstract class PatientProfileState extends Equatable {
  /// The profile the app was last known to be acting for, carried through
  /// Loading, Saving, Success and Error so screens already showing a profile
  /// don't blank out during a reload or a save.
  final Profile? lastActiveProfile;

  const PatientProfileState({this.lastActiveProfile});

  @override
  List<Object?> get props => [lastActiveProfile];
}

class PatientProfileInitial extends PatientProfileState {
  const PatientProfileInitial();
}

class PatientProfileLoading extends PatientProfileState {
  const PatientProfileLoading({super.lastActiveProfile});
}

class PatientProfileSaving extends PatientProfileState {
  const PatientProfileSaving({super.lastActiveProfile});
}

class PatientProfileLoaded extends PatientProfileState {
  /// The account holder's own profile plus any family members, primary first.
  final List<Profile> profiles;

  /// Which profile the app is currently acting for.
  final int activeProfileId;

  PatientProfileLoaded(this.profiles, this.activeProfileId)
      : super(lastActiveProfile: _resolve(profiles, activeProfileId));

  static Profile? _resolve(List<Profile> profiles, int activeProfileId) {
    if (profiles.isEmpty) return null;
    return profiles.firstWhere(
      (profile) => profile.id == activeProfileId,
      orElse: () => profiles.first,
    );
  }

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

  const PatientProfileSuccess(this.message, {super.lastActiveProfile});

  @override
  List<Object?> get props => [message, lastActiveProfile];
}

class PatientProfileError extends PatientProfileState {
  final String message;

  const PatientProfileError(this.message, {super.lastActiveProfile});

  @override
  List<Object?> get props => [message, lastActiveProfile];
}

class PatientProfileUnauthenticated extends PatientProfileState {
  const PatientProfileUnauthenticated();
}
