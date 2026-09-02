import 'package:equatable/equatable.dart';
import 'package:m2health/features/pricing/domain/entities/estimate.dart';

enum EstimateRevisionStatus { proposed, approved, rejected, superseded }

/// A revised estimate the professional proposed after assessing the patient.
///
/// Its own record with its own approval — not a care-task status. The messaging
/// feature renders it as an action card; the record and the maths are pricing's.
class EstimateRevision extends Equatable {
  final int id;
  final int careTaskId;
  final int professionalId;
  final EstimateRevisionStatus status;

  /// A snapshot taken when it was proposed, so a later price change cannot move
  /// what the patient is approving.
  final Estimate estimate;

  final double previousTotal;
  final String? note;
  final DateTime? respondedAt;
  final DateTime createdAt;

  const EstimateRevision({
    required this.id,
    required this.careTaskId,
    required this.professionalId,
    required this.status,
    required this.estimate,
    required this.previousTotal,
    required this.createdAt,
    this.note,
    this.respondedAt,
  });

  double get proposedTotal => estimate.total;

  double get difference => proposedTotal - previousTotal;

  bool get awaitingPatient => status == EstimateRevisionStatus.proposed;

  @override
  List<Object?> get props => [
        id,
        careTaskId,
        professionalId,
        status,
        estimate,
        previousTotal,
        note,
        respondedAt,
        createdAt,
      ];
}
