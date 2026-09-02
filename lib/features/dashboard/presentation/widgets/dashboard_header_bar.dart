import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/features/dashboard/domain/entities/dashboard_header.dart';
import 'package:m2health/features/dashboard/presentation/widgets/ai_assistant_bar.dart';
import 'package:m2health/features/dashboard/presentation/widgets/notification_bell.dart';
import 'package:m2health/features/dashboard/presentation/widgets/profile_avatar.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m2health/i18n/translations.g.dart';

class DashboardHeaderBar extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;

  const DashboardHeaderBar({
    super.key,
    required this.onNotificationsTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    // Selected one value at a time so the header only rebuilds when the piece
    // it actually shows changes. lastActiveProfile survives reloads and saves,
    // so none of these blank out mid-refresh.
    final fullName = context.select<PatientProfileCubit, String?>(
        (cubit) => cubit.state.lastActiveProfile?.name);
    final avatarUrl = context.select<PatientProfileCubit, String?>(
        (cubit) => cubit.state.lastActiveProfile?.avatar);
    final canSwitchProfile =
        context.select<UserRoleCubit, bool>((cubit) => cubit.state.isPatient);
    final unread = context
        .select<NotificationsCubit, int>((cubit) => cubit.state.unreadCount);

    final header = DashboardHeader.from(
      fullName: fullName,
      avatarUrl: avatarUrl,
      canSwitchProfile: canSwitchProfile,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(Const.banner, fit: BoxFit.contain, height: 36),
            const Spacer(),
            NotificationBell(unread: unread, onTap: onNotificationsTap),
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
            _greeting(context, header),
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
  String _greeting(BuildContext context, DashboardHeader header) {
    final t = context.t.dashboard;
    if (!header.hasName) return t.greeting_generic;
    return t.greeting(displayName: header.firstName!);
  }
}
