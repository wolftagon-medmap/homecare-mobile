import 'package:equatable/equatable.dart';

/// Verification lifecycle state of a professional, mirroring the backend
/// `verification_status` field.
enum VerificationStatus { incomplete, pending, verified, rejected, unknown }

VerificationStatus verificationStatusFromString(String? value) {
  switch (value) {
    case 'incomplete':
      return VerificationStatus.incomplete;
    case 'pending':
      return VerificationStatus.pending;
    case 'verified':
      return VerificationStatus.verified;
    case 'rejected':
      return VerificationStatus.rejected;
    default:
      return VerificationStatus.unknown;
  }
}

/// Human-readable text for a backend rejection category, used when the admin
/// left no free-text note.
String rejectionCategoryLabel(String? category) {
  switch (category) {
    case 'certificate_issue':
      return 'A certificate is missing, unclear, or expired.';
    case 'license_invalid':
      return 'Your license or registration could not be verified.';
    case 'info_incomplete':
      return 'Your profile information is incomplete or inconsistent.';
    case 'other':
      return 'Some changes are needed before we can verify you.';
    default:
      return 'Your submission needs changes before it can be verified.';
  }
}

/// A single onboarding checklist step and, when incomplete, the fields still missing.
class OnboardingStep extends Equatable {
  final bool complete;
  final List<String> missing;

  const OnboardingStep({required this.complete, this.missing = const []});

  @override
  List<Object?> get props => [complete, missing];
}

/// Server-computed onboarding checklist that drives the verification hub UI and
/// the submit guard. The backend is authoritative over completeness.
class OnboardingStatus extends Equatable {
  final bool canSubmit;
  final int completedCount;
  final int totalCount;
  final OnboardingStep profile;
  final OnboardingStep certificates;
  final OnboardingStep services;
  final OnboardingStep schedule;

  const OnboardingStatus({
    required this.canSubmit,
    required this.completedCount,
    required this.totalCount,
    required this.profile,
    required this.certificates,
    required this.services,
    required this.schedule,
  });

  @override
  List<Object?> get props => [
        canSubmit,
        completedCount,
        totalCount,
        profile,
        certificates,
        services,
        schedule,
      ];
}
