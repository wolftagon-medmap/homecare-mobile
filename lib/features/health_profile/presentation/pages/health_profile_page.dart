import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/health_profile_routes.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_state.dart';
import 'package:m2health/features/health_profile/presentation/widgets/section_tile.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

class HealthProfilePage extends StatefulWidget {
  const HealthProfilePage({super.key});

  @override
  State<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HealthProfileCubit>().load(_patientProfileId);
    });
  }

  int? get _patientProfileId {
    try {
      return context.read<PatientProfileCubit>().activeProfile?.id;
    } catch (_) {
      return null;
    }
  }

  Future<void> _open(HealthSectionSummary section) async {
    final route = section.opensRoute;
    if (route == HealthSectionRoute.mentalState) {
      await context.push(AppRoutes.profileMentalState);
      return;
    }

    await context.push(HealthProfileRoutes.sectionFor(section.code));
    if (mounted) await context.read<HealthProfileCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.healthProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t.namespace_title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<HealthProfileCubit, HealthProfileState>(
        builder: (context, state) {
          return switch (state.status) {
            HealthProfileStatus.initial ||
            HealthProfileStatus.loading =>
              BookingLoadingState(message: t.list.loading),
            HealthProfileStatus.error => BookingErrorState(
                message: state.errorMessage ?? t.list.error,
                onRetry: () =>
                    context.read<HealthProfileCubit>().load(_patientProfileId),
              ),
            HealthProfileStatus.ready => state.sections.isEmpty
                ? BookingEmptyState(message: t.list.empty)
                : ListView(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Text(
                          t.list.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      for (final section in state.sections)
                        SectionTile(
                          title: section.title,
                          description: section.description,
                          status: _statusFor(context, section),
                          onTap: () => _open(section),
                        ),
                    ],
                  ),
          };
        },
      ),
    );
  }

  String _statusFor(BuildContext context, HealthSectionSummary section) {
    final t = context.t.healthProfile;
    final updatedAt = section.updatedAt;
    if (updatedAt == null) return t.list.not_started;
    return t.list.updated(date: DateFormat('d MMM y').format(updatedAt));
  }
}
