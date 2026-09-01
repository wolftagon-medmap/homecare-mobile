import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:m2health/features/dashboard/presentation/widgets/ai_assistant_bar.dart';
import 'package:m2health/features/dashboard/presentation/widgets/notification_bell.dart';
import 'package:m2health/features/dashboard/presentation/widgets/profile_avatar.dart';
import 'package:m2health/i18n/translations.g.dart';

class DashboardHeaderBar extends StatelessWidget {
  final DashboardState state;
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;

  const DashboardHeaderBar({
    super.key,
    required this.state,
    required this.onNotificationsTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final header = state.header;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(Const.banner, fit: BoxFit.contain, height: 36),
            const Spacer(),
            NotificationBell(
              unread: state.unreadNotifications,
              onTap: onNotificationsTap,
            ),
            const SizedBox(width: 10),
            ProfileAvatar(
              avatarUrl: header.avatarUrl,
              showSwitcherChevron: header.canSwitchProfile,
              onTap: onAvatarTap,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _greeting(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const AiAssistantBar(),
      ],
    );
  }

  /// Greets without a name until one resolves, so the header never shows a
  /// spinner or a placeholder that is then replaced.
  String _greeting(BuildContext context) {
    final t = context.t.dashboard;
    final header = state.header;
    if (!header.hasName) return t.greeting_generic;
    return t.greeting(displayName: header.firstName!);
  }
}
