import 'package:equatable/equatable.dart';

class DashboardHeader extends Equatable {
  final String? firstName;
  final String? avatarUrl;
  final bool canSwitchProfile;

  const DashboardHeader({
    this.firstName,
    this.avatarUrl,
    this.canSwitchProfile = false,
  });

  /// Built from primitives rather than a Profile so the dashboard's domain
  /// doesn't depend on another feature's entities.
  factory DashboardHeader.from({
    String? fullName,
    String? avatarUrl,
    bool canSwitchProfile = false,
  }) {
    return DashboardHeader(
      firstName: firstNameOf(fullName),
      avatarUrl: avatarUrl,
      canSwitchProfile: canSwitchProfile,
    );
  }

  bool get hasName => firstName != null && firstName!.isNotEmpty;

  /// Greets people by their first name only. Accounts created from an email
  /// can carry the address as the name, so the domain is dropped rather than
  /// greeting someone as "Ahmad.hamdi@gmail.com". Returns null when nothing
  /// usable is left, and the greeting then drops the name entirely.
  static String? firstNameOf(String? fullName) {
    if (fullName == null) return null;
    var name = fullName.trim();
    if (name.isEmpty) return null;

    final at = name.indexOf('@');
    if (at > 0) name = name.substring(0, at);

    final token = name
        .split(RegExp(r'[\s._\-]+'))
        .firstWhere((part) => part.isNotEmpty, orElse: () => '');
    if (token.isEmpty) return null;

    return token[0].toUpperCase() + token.substring(1);
  }

  @override
  List<Object?> get props => [firstName, avatarUrl, canSwitchProfile];
}
