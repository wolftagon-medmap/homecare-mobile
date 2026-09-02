import 'package:equatable/equatable.dart';
import 'package:m2health/features/intake_booking/domain/entities/composer_state.dart';

/// A render block streamed by the backend. `kind` is the discriminator; the UI
/// does `switch (block)` and renders the matching widget. The client holds NO
/// booking logic — it renders what it's told and echoes back the tokens it's
/// given. See `M2Health-Mobile-AI-Booking-Plan.md`.
sealed class Block extends Equatable {
  final int id;
  final ComposerState? composer;

  const Block({required this.id, this.composer});

  @override
  List<Object?> get props => [id, composer];
}

class UserTextBlock extends Block {
  final String text;
  const UserTextBlock({required super.id, required this.text, super.composer});

  @override
  List<Object?> get props => [...super.props, text];
}

class AssistantTextBlock extends Block {
  final String text;
  const AssistantTextBlock(
      {required super.id, required this.text, super.composer});

  @override
  List<Object?> get props => [...super.props, text];
}

class ConfirmRequestBlock extends Block {
  final String text;
  final String confirmId;
  final String cancelId;
  const ConfirmRequestBlock({
    required super.id,
    required this.text,
    required this.confirmId,
    required this.cancelId,
    super.composer,
  });

  @override
  List<Object?> get props => [...super.props, text, confirmId, cancelId];
}

class ProfessionalShortlistBlock extends Block {
  final int taskId;
  final List<CandidateOption> candidates;
  const ProfessionalShortlistBlock({
    required super.id,
    required this.taskId,
    required this.candidates,
    super.composer,
  });

  @override
  List<Object?> get props => [...super.props, taskId, candidates];
}

class LocationRequestBlock extends Block {
  final String text;
  const LocationRequestBlock(
      {required super.id, required this.text, super.composer});

  @override
  List<Object?> get props => [...super.props, text];
}

/// A map-picked visit location, rendered as a mini-map in the transcript.
class LocationSetBlock extends Block {
  final String text;
  final double? lat;
  final double? lng;
  final String? address;
  const LocationSetBlock({
    required super.id,
    required this.text,
    required this.lat,
    required this.lng,
    required this.address,
    super.composer,
  });

  @override
  List<Object?> get props => [...super.props, text, lat, lng, address];
}

class BookingCreatedBlock extends Block {
  final String text;
  final int appointmentId;
  const BookingCreatedBlock({
    required super.id,
    required this.text,
    required this.appointmentId,
    super.composer,
  });

  @override
  List<Object?> get props => [...super.props, text, appointmentId];
}

/// Handoff / safety / generic system notice — all carry a single text line.
class NoticeBlock extends Block {
  final String text;
  final NoticeKind noticeKind;
  const NoticeBlock({
    required super.id,
    required this.text,
    required this.noticeKind,
    super.composer,
  });

  @override
  List<Object?> get props => [...super.props, text, noticeKind];
}

enum NoticeKind { handoff, safety, info }

/// A block kind this client version doesn't know how to render (forward-compat).
class UnknownBlock extends Block {
  final String kind;
  const UnknownBlock({required super.id, required this.kind, super.composer});

  @override
  List<Object?> get props => [...super.props, kind];
}

class CandidateOption extends Equatable {
  final String selectId;
  final int professionalId;
  final String name;
  final double? ratingAvg;
  final double distanceKm;
  final List<String> languages;
  final double score;

  const CandidateOption({
    required this.selectId,
    required this.professionalId,
    required this.name,
    required this.ratingAvg,
    required this.distanceKm,
    required this.languages,
    required this.score,
  });

  @override
  List<Object?> get props =>
      [selectId, professionalId, name, ratingAvg, distanceKm, languages, score];
}
