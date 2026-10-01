import 'package:equatable/equatable.dart';

class AssistantSessionSummary extends Equatable {
  final String id;
  final bool active;
  final String? preview;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  const AssistantSessionSummary({
    required this.id,
    required this.active,
    required this.preview,
    required this.lastMessageAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, active, preview, lastMessageAt, createdAt];
}
