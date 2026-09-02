import 'package:equatable/equatable.dart';

/// One row of the booking-chat session history (backend GET /v2/intake/sessions).
/// Only one session is active; the rest are read-only history.
class IntakeSessionSummary extends Equatable {
  final String id;
  final bool active;
  final String? preview;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  const IntakeSessionSummary({
    required this.id,
    required this.active,
    this.preview,
    this.lastMessageAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, active, preview, lastMessageAt, createdAt];
}
