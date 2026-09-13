import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_state.dart';
import 'package:m2health/i18n/translations.g.dart';

class DashboardNoticeBanner extends StatelessWidget {
  final Future<void> Function() onRetry;

  const DashboardNoticeBanner({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final failed = context.select<PatientProfileCubit, bool>((cubit) {
      final state = cubit.state;
      return state is PatientProfileError ||
          state is PatientProfileUnauthenticated;
    });

    if (!failed) return const SizedBox.shrink();

    final t = context.t.dashboard;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        decoration: BoxDecoration(
          color: DashboardPalette.noticeBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: DashboardPalette.noticeBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline,
                size: 18, color: DashboardPalette.noticeInk),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.header_error,
                style: const TextStyle(
                  color: DashboardPalette.noticeInk,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                foregroundColor: DashboardPalette.noticeInk,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(t.retry),
            ),
          ],
        ),
      ),
    );
  }
}
