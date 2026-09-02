import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';

/// Manages appointment routing based on user role
class AppointmentManager {
  static final List<String> providerRoles =
      PROFESSIONAL_ROLES.map((role) => role.value).toList();

  /// Check if the current user is a provider
  static Future<bool> isProvider() async {
    final role = await Utils.getSpString(Const.ROLE);
    return role != null && providerRoles.contains(role.toLowerCase());
  }

  /// Get the provider type for the current user
  static Future<String?> getProviderType() async {
    final role = await Utils.getSpString(Const.ROLE);
    if (role != null && providerRoles.contains(role.toLowerCase())) {
      return role.toLowerCase();
    }
    return null;
  }
}
