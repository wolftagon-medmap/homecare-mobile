import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/view/profile_summary.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/profile_highlights.dart';

/// Lets the professional see their own profile through a patient's eyes.
///
/// This is the moment that motivates filling the profile in: the gap between
/// what you have entered and what a patient actually sees is the argument for
/// entering more.
class ProfilePreviewPage extends StatelessWidget {
  const ProfilePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preview',
          style: ProText.pageTitle,
        ),
      ),
      body: BlocBuilder<ProfessionalProfileCubit, ProfessionalProfileState>(
        builder: (context, state) {
          if (state is! ProfessionalProfileLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profile;
          final summary = ProfileSummary.of(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PreviewBanner(),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Const.aqua.withValues(alpha: 0.15),
                        backgroundImage: (profile.avatar?.isNotEmpty ?? false)
                            ? NetworkImage(profile.avatar!)
                            : null,
                        child: (profile.avatar?.isNotEmpty ?? false)
                            ? null
                            : const Icon(Icons.person,
                                size: 44, color: Const.tosca),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile.name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(profile.jobTitle ?? '',
                          style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ProfileHighlightStrip(summary: summary),
                const SizedBox(height: 28),
                ProfileHighlightSections(summary: summary),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
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
              'This is how patients see your profile.',
              style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
