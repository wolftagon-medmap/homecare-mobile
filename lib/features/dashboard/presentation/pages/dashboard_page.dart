import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:m2health/features/dashboard/presentation/bloc/home_services_cubit.dart';
import 'package:m2health/features/dashboard/presentation/widgets/dashboard_header_bar.dart';
import 'package:m2health/features/dashboard/presentation/widgets/home_services_section.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/widgets/profile_switcher_sheet.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeServicesCubit>()..restore()),
        BlocProvider(create: (_) => sl<NotificationsCubit>()),
        BlocProvider(
          create: (context) => DashboardCubit(
            profiles: context.read<PatientProfileCubit>(),
            userRole: context.read<UserRoleCubit>(),
            notifications: context.read<NotificationsCubit>(),
          )..load(),
        ),
      ],
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 180,
        elevation: 2,
        automaticallyImplyLeading: false,
        flexibleSpace: const _HeaderBackground(),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              return DashboardHeaderBar(
                state: state,
                onNotificationsTap: () => _openNotificationInbox(context),
                onAvatarTap: () => _openProfile(context, state),
              );
            },
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
        color: Colors.white,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              HomeServicesSection(),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotificationInbox(BuildContext context) {
    final notifications = context.read<NotificationsCubit>();
    notifications.load();
    context.push(AppRoutes.notificationInbox, extra: notifications);
  }

  void _openProfile(BuildContext context, DashboardState state) {
    if (state.header.canSwitchProfile) {
      showProfileSwitcherSheet(context);
      return;
    }
    context.go(AppRoutes.profile);
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8EF4E8), Color(0xFF35C5CF)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
