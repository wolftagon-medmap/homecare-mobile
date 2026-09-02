import '../../domain/entities/time_proposal.dart';

/// Mirrors `TimeProposalPayload`.
class TimeProposalModel {
  final int proposalId;
  final int careTaskId;
  final String status;
  final String? originalStart;
  final String? originalEnd;
  final String proposedStart;
  final String proposedEnd;
  final String? reason;
  final String? expiresAt;
  final int proposedByUserId;

  const TimeProposalModel({
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

  factory TimeProposalModel.fromJson(Map<String, dynamic> json) =>
      TimeProposalModel(
        proposalId: (json['proposalId'] as num?)?.toInt() ?? 0,
        careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? 'pending',
        originalStart: json['originalStart'] as String?,
        originalEnd: json['originalEnd'] as String?,
        proposedStart: json['proposedStart'] as String? ?? '',
        proposedEnd: json['proposedEnd'] as String? ?? '',
        reason: json['reason'] as String?,
        expiresAt: json['expiresAt'] as String?,
        proposedByUserId: (json['proposedByUserId'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'proposalId': proposalId,
        'careTaskId': careTaskId,
        'status': status,
        'originalStart': originalStart,
        'originalEnd': originalEnd,
        'proposedStart': proposedStart,
        'proposedEnd': proposedEnd,
        'reason': reason,
        'expiresAt': expiresAt,
        'proposedByUserId': proposedByUserId,
      };

  TimeProposal toEntity() => TimeProposal(
        proposalId: proposalId,
        careTaskId: careTaskId,
        status: switch (status) {
          'accepted' => TimeProposalStatus.accepted,
          'declined' => TimeProposalStatus.declined,
          'withdrawn' => TimeProposalStatus.withdrawn,
          'expired' => TimeProposalStatus.expired,
          _ => TimeProposalStatus.pending,
        },
        originalStart: DateTime.tryParse(originalStart ?? ''),
        originalEnd: DateTime.tryParse(originalEnd ?? ''),
        proposedStart: DateTime.tryParse(proposedStart) ?? DateTime.now(),
        proposedEnd: DateTime.tryParse(proposedEnd) ?? DateTime.now(),
        reason: reason,
        expiresAt: DateTime.tryParse(expiresAt ?? ''),
        proposedByUserId: proposedByUserId,
      );
}
