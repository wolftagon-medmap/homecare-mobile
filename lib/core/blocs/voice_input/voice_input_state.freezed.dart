// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_input_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoiceInputState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VoiceInputState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VoiceInputState()';
  }
}

/// @nodoc
class $VoiceInputStateCopyWith<$Res> {
  $VoiceInputStateCopyWith(
      VoiceInputState _, $Res Function(VoiceInputState) __);
}

/// Adds pattern-matching-related methods to [VoiceInputState].
extension VoiceInputStatePatterns on VoiceInputState {
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
    TResult Function(_Idle value)? idle,
    TResult Function(_Recording value)? recording,
    TResult Function(_Paused value)? paused,
    TResult Function(_Transcribing value)? transcribing,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null:
        return idle(_that);
      case _Recording() when recording != null:
        return recording(_that);
      case _Paused() when paused != null:
        return paused(_that);
      case _Transcribing() when transcribing != null:
        return transcribing(_that);
      case _Success() when success != null:
        return success(_that);
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
    required TResult Function(_Idle value) idle,
    required TResult Function(_Recording value) recording,
    required TResult Function(_Paused value) paused,
    required TResult Function(_Transcribing value) transcribing,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle():
        return idle(_that);
      case _Recording():
        return recording(_that);
      case _Paused():
        return paused(_that);
      case _Transcribing():
        return transcribing(_that);
      case _Success():
        return success(_that);
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
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Recording value)? recording,
    TResult? Function(_Paused value)? paused,
    TResult? Function(_Transcribing value)? transcribing,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null:
        return idle(_that);
      case _Recording() when recording != null:
        return recording(_that);
      case _Paused() when paused != null:
        return paused(_that);
      case _Transcribing() when transcribing != null:
        return transcribing(_that);
      case _Success() when success != null:
        return success(_that);
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
    TResult Function()? idle,
    TResult Function(double amplitude)? recording,
    TResult Function(double amplitude)? paused,
    TResult Function()? transcribing,
    TResult Function(String text)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null:
        return idle();
      case _Recording() when recording != null:
        return recording(_that.amplitude);
      case _Paused() when paused != null:
        return paused(_that.amplitude);
      case _Transcribing() when transcribing != null:
        return transcribing();
      case _Success() when success != null:
        return success(_that.text);
      case _Error() when error != null:
        return error(_that.message);
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
    required TResult Function() idle,
    required TResult Function(double amplitude) recording,
    required TResult Function(double amplitude) paused,
    required TResult Function() transcribing,
    required TResult Function(String text) success,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle():
        return idle();
      case _Recording():
        return recording(_that.amplitude);
      case _Paused():
        return paused(_that.amplitude);
      case _Transcribing():
        return transcribing();
      case _Success():
        return success(_that.text);
      case _Error():
        return error(_that.message);
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
    TResult? Function()? idle,
    TResult? Function(double amplitude)? recording,
    TResult? Function(double amplitude)? paused,
    TResult? Function()? transcribing,
    TResult? Function(String text)? success,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Idle() when idle != null:
        return idle();
      case _Recording() when recording != null:
        return recording(_that.amplitude);
      case _Paused() when paused != null:
        return paused(_that.amplitude);
      case _Transcribing() when transcribing != null:
        return transcribing();
      case _Success() when success != null:
        return success(_that.text);
      case _Error() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Idle implements VoiceInputState {
  const _Idle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Idle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VoiceInputState.idle()';
  }
}

/// @nodoc

class _Recording implements VoiceInputState {
  const _Recording({this.amplitude = 0.0});

  @JsonKey()
  final double amplitude;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecordingCopyWith<_Recording> get copyWith =>
      __$RecordingCopyWithImpl<_Recording>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Recording &&
            (identical(other.amplitude, amplitude) ||
                other.amplitude == amplitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amplitude);

  @override
  String toString() {
    return 'VoiceInputState.recording(amplitude: $amplitude)';
  }
}

/// @nodoc
abstract mixin class _$RecordingCopyWith<$Res>
    implements $VoiceInputStateCopyWith<$Res> {
  factory _$RecordingCopyWith(
          _Recording value, $Res Function(_Recording) _then) =
      __$RecordingCopyWithImpl;
  @useResult
  $Res call({double amplitude});
}

/// @nodoc
class __$RecordingCopyWithImpl<$Res> implements _$RecordingCopyWith<$Res> {
  __$RecordingCopyWithImpl(this._self, this._then);

  final _Recording _self;
  final $Res Function(_Recording) _then;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amplitude = null,
  }) {
    return _then(_Recording(
      amplitude: null == amplitude
          ? _self.amplitude
          : amplitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _Paused implements VoiceInputState {
  const _Paused({this.amplitude = 0.0});

  @JsonKey()
  final double amplitude;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PausedCopyWith<_Paused> get copyWith =>
      __$PausedCopyWithImpl<_Paused>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Paused &&
            (identical(other.amplitude, amplitude) ||
                other.amplitude == amplitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amplitude);

  @override
  String toString() {
    return 'VoiceInputState.paused(amplitude: $amplitude)';
  }
}

/// @nodoc
abstract mixin class _$PausedCopyWith<$Res>
    implements $VoiceInputStateCopyWith<$Res> {
  factory _$PausedCopyWith(_Paused value, $Res Function(_Paused) _then) =
      __$PausedCopyWithImpl;
  @useResult
  $Res call({double amplitude});
}

/// @nodoc
class __$PausedCopyWithImpl<$Res> implements _$PausedCopyWith<$Res> {
  __$PausedCopyWithImpl(this._self, this._then);

  final _Paused _self;
  final $Res Function(_Paused) _then;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amplitude = null,
  }) {
    return _then(_Paused(
      amplitude: null == amplitude
          ? _self.amplitude
          : amplitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _Transcribing implements VoiceInputState {
  const _Transcribing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Transcribing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VoiceInputState.transcribing()';
  }
}

/// @nodoc

class _Success implements VoiceInputState {
  const _Success({required this.text});

  final String text;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SuccessCopyWith<_Success> get copyWith =>
      __$SuccessCopyWithImpl<_Success>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Success &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'VoiceInputState.success(text: $text)';
  }
}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res>
    implements $VoiceInputStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) =
      __$SuccessCopyWithImpl;
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$SuccessCopyWithImpl<$Res> implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
  }) {
    return _then(_Success(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Error implements VoiceInputState {
  const _Error({required this.message});

  final String message;

  /// Create a copy of VoiceInputState
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
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'VoiceInputState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $VoiceInputStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of VoiceInputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Error(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
