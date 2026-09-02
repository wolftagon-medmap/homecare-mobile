import 'package:equatable/equatable.dart';

enum TimeProposalStatus { pending, accepted, declined, withdrawn, expired }

/// A professional's alternative slot, awaiting the patient. The slot is held
/// for the same 30 minutes an offer runs for; [expiresAt] is that hold's TTL.
class TimeProposal extends Equatable {
  final int proposalId;
  final int careTaskId;
  final TimeProposalStatus status;

  /// What the patient originally asked for. Null when the request carried no time.
  final DateTime? originalStart;
  final DateTime? originalEnd;
  final DateTime proposedStart;
  final DateTime proposedEnd;
  final String? reason;
  final DateTime? expiresAt;
  final int proposedByUserId;

  const TimeProposal({
    required this.proposalId,
    required this.careTaskId,
    required this.status,
    required this.originalStart,
    required this.originalEnd,
    required this.proposedStart,
    required this.proposedEnd,
    required this.reason,
    required this.expiresAt,
    required this.proposedByUserId,
  });

  bool get isOpen => status == TimeProposalStatus.pending && !hasExpired;

  bool get hasExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  Duration? get timeLeft {
    if (expiresAt == null) return null;
    final left = expiresAt!.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  TimeProposal copyWith({TimeProposalStatus? status}) => TimeProposal(
        proposalId: proposalId,
        careTaskId: careTaskId,
        status: status ?? this.status,
        originalStart: originalStart,
        originalEnd: originalEnd,
        proposedStart: proposedStart,
        proposedEnd: proposedEnd,
        reason: reason,
        expiresAt: expiresAt,
        proposedByUserId: proposedByUserId,
      );

  @override
  List<Object?> get props => [
        proposalId,
        careTaskId,
        status,
        originalStart,
        originalEnd,
        proposedStart,
        proposedEnd,
        reason,
        expiresAt,
        proposedByUserId,
      ];
}
