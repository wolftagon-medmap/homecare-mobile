import 'package:m2health/route/app_routes.dart';

/// Where a conversation lives, for callers outside the messaging feature.
///
/// The paths themselves are owned by `MessagingRoutes`, which builds its routes
/// from these constants — they are declared here so a card can navigate without
/// importing the feature.
class MessagingEntry {
  const MessagingEntry._();

  static const String list = AppRoutes.messages;

  static String threadPath(int threadId) => '$list/thread/$threadId';
}
