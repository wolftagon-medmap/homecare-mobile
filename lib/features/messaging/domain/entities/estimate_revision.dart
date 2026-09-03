import 'package:equatable/equatable.dart';

enum EstimateRevisionStatus { pending, approved, withdrawn }

enum EstimateLineChange { unchanged, added, removed }

class EstimateLine extends Equatable {
  final String code;
  final String label;
  final double amount;
  final EstimateLineChange change;

  const EstimateLine({
    required this.code,
    required this.label,
    required this.amount,
    required this.change,
  });

  @override
  List<Object?> get props => [code, label, amount, change];
}

/// A revised estimate the professional proposes after assessing over chat.
///
/// Every number here is computed upstream by the pricing module and carried
/// whole. Nothing in this feature adds anything up — the card displays what it
/// is given, and [delta] is the only arithmetic, on two totals that both arrived
/// already calculated.
class EstimateRevision extends Equatable {
  final int revisionId;
  final int careTaskId;
  final EstimateRevisionStatus status;
  final String currency;
  final double currentTotal;
  final double proposedTotal;
  final List<EstimateLine> lines;
  final String? note;

  const EstimateRevision({
    required this.revisionId,
    required this.careTaskId,
    required this.status,
    required this.currency,
    required this.currentTotal,
    required this.proposedTotal,
    required this.lines,
    required this.note,
  });

  double get delta => proposedTotal - currentTotal;

  bool get isPending => status == EstimateRevisionStatus.pending;

  EstimateRevision copyWith({EstimateRevisionStatus? status}) =>
      EstimateRevision(
        revisionId: revisionId,
        careTaskId: careTaskId,
        status: status ?? this.status,
        currency: currency,
        currentTotal: currentTotal,
        proposedTotal: proposedTotal,
        lines: lines,
        note: note,
      );

  @override
  List<Object?> get props => [
        revisionId,
        careTaskId,
        status,
        currency,
        currentTotal,
        proposedTotal,
        lines,
        note,
      ];
}
