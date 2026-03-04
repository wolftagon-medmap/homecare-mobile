// chatbot/presentation/bloc/chat_cubit.dart
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  StreamSubscription<ChatEvent>? _eventSubscription;
  final String service;

  ChatCubit({required ChatRepository repository, required this.service})
      : _repository = repository,
        super(const ChatState.initial());

  Future<void> initialize() async {
    log("Initializing ChatCubit. Checking for active session...",
        name: 'ChatCubit.initialize');
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
      emit(ChatState.error(e.toString()));
    }
  }

  void _startSession() {
    emit(const ChatState.loading(message: "Starting new session..."));
    _eventSubscription?.cancel();
    _eventSubscription = _repository.invokeSession(service: service).listen(
      _handleEvent,
      onError: (e) {
        log("Error in session stream",
            name: 'ChatCubit._startSession', error: e);
      },
      onDone: () {
        log("Session stream closed", name: 'ChatCubit._startSession');
      },
    );
  }

  void _handleEvent(ChatEvent event) {
    log("Handling new event. Sender: ${event.sender},Type: ${event.type}, Node ID: ${event.nodeId}",
        name: 'ChatCubit._handleEvent');

    // First event received --> Change from loading to loaded state
    if (state is! Loaded) {
      final events = <ChatEvent>[event];
      emit(ChatState.loaded(events: events));
      return;
    }

    state.mapOrNull(loaded: (s) {
      final events = List<ChatEvent>.from(s.events);
      log("Received event: ${event.type}, Node ID: ${event.nodeId}, Sender: ${(event is UserInputEvent) ? 'user' : 'assistant'}",
          name: 'ChatCubit._handleEvent');

      switch (event) {
        case InputEvent _:
          emit(
            s.copyWith(
              events: [...events, event],
              activeInputEvent: event,
              isProcessing: false,
            ),
          );
        case StreamMessageEvent _:
          _processStreamChunk(events, event);
          emit(s.copyWith(events: events));
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

  void _processStreamChunk(List<ChatEvent> events, StreamMessageEvent chunk) {
    final index = events.lastIndexWhere((e) =>
        e is StreamMessageEvent &&
        e.nodeExecutionId == chunk.nodeExecutionId &&
        e.outputKey == chunk.outputKey);

    if (index >= 0) {
      // Update existing streaming event in-place
      final existing = events[index] as StreamMessageEvent;
      events[index] = StreamMessageEvent(
        nodeId: existing.nodeId,
        content: chunk.streamStatus == EventStatus.stream
            ? existing.content + chunk.content
            : chunk.content, // Final replace
        streamStatus: chunk.streamStatus,
        nodeExecutionId: chunk.nodeExecutionId,
        outputKey: chunk.outputKey,
      );
    } else {
      events.add(chunk);
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

    // 1. Local Optimistic Update
    final userEvent = UserInputEvent(textInput: text);
    state.mapOrNull(
      loaded: (s) => emit(
        s.copyWith(
          events: [...s.events, userEvent],
          isProcessing: true,
        ),
      ),
    );

    // 2. Start Request Stream
    final activeInputEvent =
        state.mapOrNull(loaded: (s) => s.activeInputEvent)!;
    _eventSubscription?.cancel();
    _eventSubscription = _repository.sendInput(
      service: service,
      nodeId: activeInputEvent.nodeId,
      messageId: activeInputEvent.messageId,
      input: {'user_input': text},
    ).listen(_handleEvent);
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
      emit(ChatState.error(e.toString()));
    }
  }
}
