import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/domain/entities/composer_state.dart';

/// Parse one backend block payload into a domain [Block]. Unknown kinds map to
/// [UnknownBlock] so a newer backend never crashes an older client.
Block blockFromJson(Map<String, dynamic> json) {
  final id = (json['id'] as num?)?.toInt() ?? 0;
  final composer = json['composer'] is Map<String, dynamic>
      ? ComposerState.fromJson(json['composer'] as Map<String, dynamic>)
      : null;
  final kind = json['kind'] as String? ?? 'unknown';
  final text = json['text'] as String? ?? '';

  switch (kind) {
    case 'user_text':
      return UserTextBlock(id: id, text: text, composer: composer);
    case 'assistant_text':
      return AssistantTextBlock(id: id, text: text, composer: composer);
    case 'confirm_request':
      return ConfirmRequestBlock(
        id: id,
        text: text,
        confirmId: json['confirmId'] as String? ?? '',
        cancelId: json['cancelId'] as String? ?? '',
        composer: composer,
      );
    case 'professional_shortlist':
      final candidates = (json['candidates'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(_candidateFromJson)
          .toList();
      return ProfessionalShortlistBlock(
        id: id,
        taskId: (json['taskId'] as num?)?.toInt() ?? 0,
        candidates: candidates,
        composer: composer,
      );
    case 'location_request':
      return LocationRequestBlock(id: id, text: text, composer: composer);
    case 'booking_created':
      return BookingCreatedBlock(
        id: id,
        text: text,
        appointmentId: (json['appointmentId'] as num?)?.toInt() ?? 0,
        composer: composer,
      );
    case 'handoff':
      return NoticeBlock(
          id: id,
          text: text,
          noticeKind: NoticeKind.handoff,
          composer: composer);
    case 'safety_alert':
      return NoticeBlock(
          id: id,
          text: text,
          noticeKind: NoticeKind.safety,
          composer: composer);
    case 'info':
      return NoticeBlock(
          id: id, text: text, noticeKind: NoticeKind.info, composer: composer);
    default:
      return UnknownBlock(id: id, kind: kind, composer: composer);
  }
}

CandidateOption _candidateFromJson(Map<String, dynamic> json) {
  return CandidateOption(
    selectId: json['selectId'] as String? ?? '',
    professionalId: (json['professionalId'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    ratingAvg: (json['ratingAvg'] as num?)?.toDouble(),
    distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
    languages: (json['languages'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    score: (json['score'] as num?)?.toDouble() ?? 0,
  );
}
