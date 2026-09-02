import 'package:equatable/equatable.dart';

/// How the input bar should behave, dictated by the backend (latest wins).
/// A dumb client never computes this itself.
class ComposerState extends Equatable {
  final bool enabled;
  final String? placeholder;

  /// When the composer is disabled, an optional notice shown in its place
  /// (e.g. "A staff member will contact you shortly").
  final String? notice;

  const ComposerState({
    this.enabled = true,
    this.placeholder,
    this.notice,
  });

  static const ComposerState defaults = ComposerState(enabled: true);

  factory ComposerState.fromJson(Map<String, dynamic> json) {
    return ComposerState(
      enabled: json['enabled'] as bool? ?? true,
      placeholder: json['placeholder'] as String?,
      notice: json['notice'] as String?,
    );
  }

  @override
  List<Object?> get props => [enabled, placeholder, notice];
}
