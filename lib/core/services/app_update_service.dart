import 'dart:io';

import 'package:in_app_update/in_app_update.dart';

/// Handles Android in-app updates via the Google Play In-App Update API.
///
/// iOS updates are handled declaratively via [UpgradeAlert] in main.dart —
/// no service code needed on that side.
class AppUpdateService {
  /// Checks Google Play for a pending update and starts a flexible update
  /// flow if one is available.
  ///
  /// Flexible update: the update is downloaded in the background while the
  /// user continues using the app. Once downloaded, the system prompts the
  /// user to restart and install.
  ///
  /// Errors are swallowed — an update check should never crash the app.
  static Future<void> checkAndroidUpdate() async {
    if (!Platform.isAndroid) return;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      if (info.immediateUpdateAllowed) {
        // High-priority update (e.g. critical security fix): block UI until done.
        await InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        // Regular update: download silently, then prompt to restart.
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (_) {
      // Silently ignore — Play Store may be unavailable in dev/test builds.
    }
  }
}
