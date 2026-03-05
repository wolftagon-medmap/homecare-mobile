// chatbot/presentation/bloc/chat_cubit.dart
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  final String service;

  ChatCubit({required ChatRepository repository, required this.service})
      : _repository = repository,
        super(const ChatState.initial());

  StreamSubscription<ChatEvent>? _eventSubscription;
  Timer? _throttleTimer;
  List<ChatEvent>? _pendingEvents;
  Future<void> Function()? _lastAction; // For retrying failed actions

  Future<void> initialize() async {
    log("Initializing ChatCubit. Checking for active session...",
        name: 'ChatCubit.initialize');
    _lastAction = initialize;
    emit(const ChatState.loading(message: "Loading chat..."));
    try {
      final session = await _repository.getActiveSession(service: service);
      if (session != null && !session.isExpired) {
        emit(ChatState.loaded(
          events: session.events,
          activeInputEvent: session.activeInputEvent,
        ));
      } else {
        log(
          "No active session found. Starting new session.",
          name: 'ChatCubit.initialize',
        );
        _startSession();
      }
    } catch (e) {
      log("Error during initialization: $e", name: 'ChatCubit.initialize');
      emit(const ChatState.error(
        message: "Failed to load chat session. Please try again.",
        isRetryable: true,
      ));
    }
  }

  void _startSession() {
    _lastAction = () async => _startSession();
    emit(const ChatState.loading(message: "Starting new session..."));
    _eventSubscription?.cancel();
    _eventSubscription = _repository.invokeSession(service: service).listen(
          _handleEvent,
          onError: _handleStreamError,
        );
  }

  void _handleEvent(ChatEvent event) {
    log("Handling new event. Sender: ${event.sender},Type: ${event.type}, Node ID: ${event.nodeId}",
        name: 'ChatCubit._handleEvent');

    // First event received --> Change from loading to loaded state
    if (state is! Loaded) {
      emit(ChatState.loaded(events: [event]));
      return;
    }

    state.mapOrNull(loaded: (s) {
      final events = List<ChatEvent>.from(s.events);
      switch (event) {
        case InputEvent _:
          emit(
            s.copyWith(
              events: [...events, event],
              activeInputEvent: event,
              isProcessing: false,
            ),
          );
        case StreamMessageEvent streamEvent:
          _processStreamChunk(events, streamEvent, (processedEvents) {
            emit(
              s.copyWith(
                events: processedEvents,
                isProcessing: streamEvent.streamStatus == EventStatus.stream,
              ),
            );
          });

        case OutputMessageEvent _:
          emit(
            s.copyWith(
              events: [...events, event],
              isProcessing: false,
            ),
          );
        default:
          break;
      }
    });
  }

  void _processStreamChunk(
    List<ChatEvent> stateEvents,
    StreamMessageEvent chunk,
    void Function(List<ChatEvent>) onComplete,
  ) {
    final index = stateEvents.lastIndexWhere((e) =>
        e is StreamMessageEvent &&
        e.nodeExecutionId == chunk.nodeExecutionId &&
        e.outputKey == chunk.outputKey);

    if (index < 0) {
      stateEvents.add(chunk); // No matching output message, add as new message
      onComplete(stateEvents);
      return;
    }

    final isOngoingStream = chunk.streamStatus == EventStatus.stream;
    final events = _pendingEvents ?? stateEvents;
    final existing = events[index] as StreamMessageEvent;
    events[index] = StreamMessageEvent(
      nodeId: existing.nodeId,
      content: isOngoingStream
          ? existing.content + chunk.content
          : chunk.content, // Final replace
      streamStatus: chunk.streamStatus,
      nodeExecutionId: chunk.nodeExecutionId,
      outputKey: chunk.outputKey,
    );
    if (isOngoingStream) {
      // throttle updates for ongoing streams to avoid UI jank
      _pendingEvents = events;
      _throttleTimer ??= Timer(const Duration(milliseconds: 48), () {
        if (_pendingEvents != null) {
          onComplete(_pendingEvents!);
          _pendingEvents = null;
        }
        _throttleTimer = null;
      });
    } else {
      // end of stream: finalize immediately
      _throttleTimer?.cancel();
      _throttleTimer = null;
      _pendingEvents = null;
      onComplete(events);
    }
  }

  Future<void> sendText(String text) async {
    log("Attempting to send user text input: $text",
        name: 'ChatCubit.sendText');

    if (state is! Loaded) {
      log("Cannot send input. Current state is not loaded.",
          name: 'ChatCubit.sendText');
      return;
    }

    if (state.mapOrNull(loaded: (s) => s.activeInputEvent == null) ?? true) {
      log("No active input event. Ignoring user input.",
          name: 'ChatCubit.sendText');
      return;
    }

    _lastAction = () => sendText(text);

    // Clear previous message-level errors when starting a new attempt
    state.mapOrNull(
        loaded: (s) => emit(s.copyWith(error: null, isRetryable: false)));

    // 1. Local Optimistic Update
    final activeInputEvent =
        state.mapOrNull(loaded: (s) => s.activeInputEvent)!;
    final userEvent = UserInputEvent(
      textInput: text,
      repliedMessageId: activeInputEvent.messageId,
    );
    state.mapOrNull(loaded: (s) {
      emit(
        s.copyWith(
          events: s.events.contains(userEvent)
              ? s.events
              : [...s.events, userEvent],
          isProcessing: true,
        ),
      );
    });

    // 2. Start Request Stream
    _eventSubscription?.cancel();
    _eventSubscription = _repository.sendInput(
      service: service,
      nodeId: activeInputEvent.nodeId,
      messageId: activeInputEvent.messageId,
      input: {'user_input': text},
    ).listen(
      _handleEvent,
      onError: _handleStreamError,
    );
  }

  void _handleStreamError(dynamic e) {
    state.maybeMap(
      loaded: (s) => emit(s.copyWith(
        isProcessing: false,
        error: "Failed to send message.\nPlease try again.",
        isRetryable: true,
      )),
      orElse: () => emit(const ChatState.error(
        message: "Could not connect to AI service.\nPlease try again.",
        isRetryable: true,
      )),
    );
  }

  Future<void> resetChat() async {
    log("Resetting chat session for service: $service",
        name: 'ChatCubit.resetChat');
    emit(const ChatState.loading(message: "Resetting chat..."));
    try {
      _eventSubscription?.cancel();
      await _repository.closeSession(service: service);
      _startSession();
    } catch (e) {
      log("Error resetting chat: $e", name: 'ChatCubit.resetChat');
      emit(const ChatState.error(
        message: "Failed to reset chat. Please try again.",
        isRetryable: true,
      ));
    }
  }

  void retry() {
    if (_lastAction != null) {
      _lastAction!();
    }
  }
}
