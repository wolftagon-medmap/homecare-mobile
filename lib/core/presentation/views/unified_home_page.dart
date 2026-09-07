import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/features/appointment/pages/professional_today_page.dart';
import 'package:m2health/features/dashboard/presentation/pages/dashboard_page.dart';

/// Picks the home screen for the signed-in role, mirroring
/// `UnifiedAppointmentPage` and `UnifiedProfilePage`.
///
/// The patient dashboard is a service catalogue, which is the wrong home for
/// someone who delivers the services rather than buying them.
class UnifiedHomePage extends StatelessWidget {
  const UnifiedHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRoleCubit, UserRoleState>(
      builder: (context, state) {
        if (state.isProvider) return const ProfessionalTodayPage();
        return const DashboardPage();
      },
    );
  }
}
