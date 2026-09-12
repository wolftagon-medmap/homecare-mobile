import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/features/dashboard/domain/entities/dashboard_header.dart';
import 'package:m2health/features/dashboard/presentation/widgets/ai_assistant_bar.dart';
import 'package:m2health/features/dashboard/presentation/widgets/notification_bell.dart';
import 'package:m2health/features/dashboard/presentation/widgets/profile_avatar.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

class DashboardHeaderBar extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;

  const DashboardHeaderBar({
    super.key,
    required this.onNotificationsTap,
    required this.onAvatarTap,
  });

  static const _avatarRowHeight = 56.0;
  static const _gapBelowAvatarRow = 10.0;
  static const _gapBelowGreeting = 20.0;
  static const _bottomPadding = 25.0;
  static const _greetingSize = 13.0;
  static const _greetingLineHeight = 1.2;
  static const _assistantMinContent = 34.0;
  static const _assistantVerticalPadding = 18.0;
  static const _maxTextScale = 1.3;

  static TextScaler scalerOf(BuildContext context) =>
      MediaQuery.textScalerOf(context).clamp(maxScaleFactor: _maxTextScale);

  static double heightOf(BuildContext context) {
    final scaler = scalerOf(context);
    final greeting = scaler.scale(_greetingSize) * _greetingLineHeight;
    final assistantText = scaler.scale(AiAssistantBar.textSize) *
        AiAssistantBar.textLineHeight *
        AiAssistantBar.textMaxLines;
    final assistant = math.max(_assistantMinContent, assistantText) +
        _assistantVerticalPadding;

    return _avatarRowHeight +
        _gapBelowAvatarRow +
        greeting +
        _gapBelowGreeting +
        assistant +
        _bottomPadding;
  }

  @override
  Widget build(BuildContext context) {
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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: scalerOf(context)),
      child: Column(
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
          const SizedBox(height: _gapBelowAvatarRow),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _greeting(context, header),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: _greetingSize,
                height: _greetingLineHeight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: _gapBelowGreeting),
          const AiAssistantBar(),
        ],
      ),
    );
  }

  String _greeting(BuildContext context, DashboardHeader header) {
    final t = context.t.dashboard;
    if (!header.hasName) return t.greeting_generic;
    return t.greeting(displayName: header.firstName!);
  }
}
