import 'package:equatable/equatable.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/domain/entities/composer_state.dart';

sealed class IntakeState extends Equatable {
  const IntakeState();

  @override
  List<Object?> get props => [];
}

class IntakeInitial extends IntakeState {
  const IntakeInitial();
}

/// Starting the session / loading history before the first render.
class IntakeConnecting extends IntakeState {
  const IntakeConnecting();
}

/// Unrecoverable startup error (session/history failed).
class IntakeFatal extends IntakeState {
  final String message;
  const IntakeFatal(this.message);

  @override
  List<Object?> get props => [message];
}

/// The live conversation.
class IntakeActive extends IntakeState {
  final String sessionId;
  final List<Block> blocks;
  final ComposerState composer;

  /// True from a send until the next server block (drives the thinking dots).
  final bool awaitingReply;

  /// SSE connection health (for a subtle "reconnecting…" hint).
  final bool connected;

  /// Non-null when the last action failed to send.
  final String? actionError;

  /// Interactive blocks already acted on: block id → chosen reply token. Used to
  /// make buttons one-shot and highlight the chosen option.
  final Map<int, String> resolvedChoices;

  const IntakeActive({
    required this.sessionId,
    this.blocks = const [],
    this.composer = ComposerState.defaults,
    this.awaitingReply = false,
    this.connected = false,
    this.actionError,
    this.resolvedChoices = const {},
  });

  IntakeActive copyWith({
    List<Block>? blocks,
    ComposerState? composer,
    bool? awaitingReply,
    bool? connected,
    String? actionError,
    bool clearActionError = false,
    Map<int, String>? resolvedChoices,
  }) {
    return IntakeActive(
      sessionId: sessionId,
      blocks: blocks ?? this.blocks,
      composer: composer ?? this.composer,
      awaitingReply: awaitingReply ?? this.awaitingReply,
      connected: connected ?? this.connected,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      resolvedChoices: resolvedChoices ?? this.resolvedChoices,
    );
  }

  @override
  List<Object?> get props =>
      [sessionId, blocks, composer, awaitingReply, connected, actionError, resolvedChoices];
}
