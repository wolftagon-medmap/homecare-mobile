import 'package:equatable/equatable.dart';

enum BookingRequestStatus {
  pendingApproval,
  confirmed,
  alternativeProposed,
  cancelled;

  static BookingRequestStatus fromWire(String? value) => switch (value) {
        'accepted' || 'confirmed' => BookingRequestStatus.confirmed,
        'time_proposed' => BookingRequestStatus.alternativeProposed,
        'cancelled' => BookingRequestStatus.cancelled,
        _ => BookingRequestStatus.pendingApproval,
      };
}

class SubmittedRequest extends Equatable {
  final int id;
  final BookingRequestStatus status;
  final DateTime submittedAt;
  final String? professionalName;
  final DateTime? preferredAt;

  final DateTime? proposedAt;

  const SubmittedRequest({
    required this.id,
    required this.status,
    required this.submittedAt,
    this.professionalName,
    this.preferredAt,
    this.proposedAt,
  });

  @override
  List<Object?> get props =>
      [id, status, submittedAt, professionalName, preferredAt, proposedAt];
}
