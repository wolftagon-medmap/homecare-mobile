// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatState()';
  }
}

/// @nodoc
class $ChatStateCopyWith<$Res> {
  $ChatStateCopyWith(ChatState _, $Res Function(ChatState) __);
}

/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case Loaded() when loaded != null:
        return loaded(_that);
      case _Error() when error != null:
        return error(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Loading():
        return loading(_that);
      case Loaded():
        return loaded(_that);
      case _Error():
        return error(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case Loaded() when loaded != null:
        return loaded(_that);
      case _Error() when error != null:
        return error(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
            List<ChatEvent> events,
            InputEvent? activeInputEvent,
            bool isProcessing,
            bool isSessionClosed,
            String? error,
            bool? isRetryable)?
        loaded,
    TResult Function(String message, bool isRetryable)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading(_that.message);
      case Loaded() when loaded != null:
        return loaded(_that.events, _that.activeInputEvent, _that.isProcessing,
            _that.isSessionClosed, _that.error, _that.isRetryable);
      case _Error() when error != null:
        return error(_that.message, _that.isRetryable);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
            List<ChatEvent> events,
            InputEvent? activeInputEvent,
            bool isProcessing,
            bool isSessionClosed,
            String? error,
            bool? isRetryable)
        loaded,
    required TResult Function(String message, bool isRetryable) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Loading():
        return loading(_that.message);
      case Loaded():
        return loaded(_that.events, _that.activeInputEvent, _that.isProcessing,
            _that.isSessionClosed, _that.error, _that.isRetryable);
      case _Error():
        return error(_that.message, _that.isRetryable);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
            List<ChatEvent> events,
            InputEvent? activeInputEvent,
            bool isProcessing,
            bool isSessionClosed,
            String? error,
            bool? isRetryable)?
        loaded,
    TResult? Function(String message, bool isRetryable)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading(_that.message);
      case Loaded() when loaded != null:
        return loaded(_that.events, _that.activeInputEvent, _that.isProcessing,
            _that.isSessionClosed, _that.error, _that.isRetryable);
      case _Error() when error != null:
        return error(_that.message, _that.isRetryable);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements ChatState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatState.initial()';
  }
}

/// @nodoc

class _Loading implements ChatState {
  const _Loading({this.message});

  final String? message;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadingCopyWith<_Loading> get copyWith =>
      __$LoadingCopyWithImpl<_Loading>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Loading &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ChatState.loading(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) =
      __$LoadingCopyWithImpl;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$LoadingCopyWithImpl<$Res> implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_Loading(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class Loaded implements ChatState {
  const Loaded(
      {required final List<ChatEvent> events,
      this.activeInputEvent,
      this.isProcessing = false,
      this.isSessionClosed = false,
      this.error,
      this.isRetryable})
      : _events = events;

  final List<ChatEvent> _events;
  List<ChatEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  final InputEvent? activeInputEvent;
// The input event that is currently active (waiting for user input)
  @JsonKey()
  final bool isProcessing;
  @JsonKey()
  final bool isSessionClosed;
// Message level error (e.g. failed to send input). Preserve chat history while allowing retry.
  final String? error;
  final bool? isRetryable;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoadedCopyWith<Loaded> get copyWith =>
      _$LoadedCopyWithImpl<Loaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Loaded &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.activeInputEvent, activeInputEvent) ||
                other.activeInputEvent == activeInputEvent) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isSessionClosed, isSessionClosed) ||
                other.isSessionClosed == isSessionClosed) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isRetryable, isRetryable) ||
                other.isRetryable == isRetryable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_events),
      activeInputEvent,
      isProcessing,
      isSessionClosed,
      error,
      isRetryable);

  @override
  String toString() {
    return 'ChatState.loaded(events: $events, activeInputEvent: $activeInputEvent, isProcessing: $isProcessing, isSessionClosed: $isSessionClosed, error: $error, isRetryable: $isRetryable)';
  }
}

/// @nodoc
abstract mixin class $LoadedCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $LoadedCopyWith(Loaded value, $Res Function(Loaded) _then) =
      _$LoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<ChatEvent> events,
      InputEvent? activeInputEvent,
      bool isProcessing,
      bool isSessionClosed,
      String? error,
      bool? isRetryable});
}

/// @nodoc
class _$LoadedCopyWithImpl<$Res> implements $LoadedCopyWith<$Res> {
  _$LoadedCopyWithImpl(this._self, this._then);

  final Loaded _self;
  final $Res Function(Loaded) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? events = null,
    Object? activeInputEvent = freezed,
    Object? isProcessing = null,
    Object? isSessionClosed = null,
    Object? error = freezed,
    Object? isRetryable = freezed,
  }) {
    return _then(Loaded(
      events: null == events
          ? _self._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<ChatEvent>,
      activeInputEvent: freezed == activeInputEvent
          ? _self.activeInputEvent
          : activeInputEvent // ignore: cast_nullable_to_non_nullable
              as InputEvent?,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSessionClosed: null == isSessionClosed
          ? _self.isSessionClosed
          : isSessionClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isRetryable: freezed == isRetryable
          ? _self.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _Error implements ChatState {
  const _Error({required this.message, this.isRetryable = true});

  final String message;
  @JsonKey()
  final bool isRetryable;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRetryable, isRetryable) ||
                other.isRetryable == isRetryable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isRetryable);

  @override
  String toString() {
    return 'ChatState.error(message: $message, isRetryable: $isRetryable)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String message, bool isRetryable});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? isRetryable = null,
  }) {
    return _then(_Error(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRetryable: null == isRetryable
          ? _self.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
