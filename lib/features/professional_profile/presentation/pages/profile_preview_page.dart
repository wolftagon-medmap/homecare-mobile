import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_state.dart';
import 'package:m2health/features/professional_profile/domain/entities/onboarding_status.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/public_profile_body.dart';

/// The professional's own profile fetched from the endpoint patients use and
/// rendered with the widget patients see, so the two cannot drift apart.
class ProfilePreviewPage extends StatelessWidget {
  const ProfilePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfessionalProfileCubit>().state;
    final profile =
        profileState is ProfessionalProfileLoaded ? profileState.profile : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview', style: ProText.pageTitle),
      ),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : profile.verificationStatus != VerificationStatus.verified
              ? const _NotVisibleYet()
              : _Preview(professionalId: profile.id),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.professionalId});

  final int professionalId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfessionalDetailCubit, ProfessionalDetailState>(
      builder: (context, state) {
        return switch (state) {
          ProfessionalDetailLoaded(:final professional) =>
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PreviewBanner(),
                  PublicProfileBody(professional: professional),
                ],
              ),
            ),
          ProfessionalDetailError(:final message) => _Unavailable(
              message: message,
              onRetry: () => context
                  .read<ProfessionalDetailCubit>()
                  .fetchProfessionalDetail(professionalId),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_outlined,
              size: 16, color: Colors.amber.shade800),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This is exactly what patients see.',
              style: ProText.hint.copyWith(color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotVisibleYet extends StatelessWidget {
  const _NotVisibleYet();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility_off_outlined,
                size: 40, color: Const.placeholderTextColor),
            SizedBox(height: 12),
            Text(
              'Not visible to patients yet',
              style: ProText.sectionTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Your profile appears in search once your verification is '
              'approved. Everything you fill in now will be ready for it.',
              style: ProText.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off,
                size: 40, color: Const.placeholderTextColor),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: ProText.caption),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
