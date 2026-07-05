import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/domain/entities/onboarding_status.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/features/profiles/presentation/pages/manage_provided_services_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';

/// Guides an unverified professional through the steps required before they can
/// submit their profile for verification. The checklist state is server-driven
/// via `profile.onboarding`.
class VerificationHubPage extends StatefulWidget {
  const VerificationHubPage({super.key});

  @override
  State<VerificationHubPage> createState() => _VerificationHubPageState();
}

class _VerificationHubPageState extends State<VerificationHubPage> {
  @override
  void initState() {
    super.initState();
    // Ensure a fresh profile (and onboarding checklist) is loaded when arriving
    // here directly.
    final state = context.read<ProfileCubit>().state;
    if (state is! ProfessionalProfileLoaded) {
      context.read<ProfileCubit>().loadProfile();
    }
  }

  Future<void> _openAndRefresh(Future<void> Function() navigate) async {
    await navigate();
    if (mounted) context.read<ProfileCubit>().loadProfile();
  }

  void _openProfile(ProfessionalProfile profile) {
    _openAndRefresh(
        () => context.push(AppRoutes.editProfessionalProfile, extra: profile));
  }

  Future<void> _openServices(ProfessionalProfile profile) async {
    final role = await Utils.getSpString(Const.ROLE);
    if (role == null || !mounted) return;
    await _openAndRefresh(
      () => GoRouter.of(context).pushNamed(
        AppRoutes.editProfessionalServices,
        extra: ManageServicesArgs(
          role: role,
          isHomeScreeningAuthorized: profile.isHomeScreeningAuthorized ?? false,
          currentServices: profile.providedServices,
        ),
      ),
    );
  }

  void _openSchedule() {
    _openAndRefresh(() => context.push(AppRoutes.workingSchedule));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get verified',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! ProfessionalProfileLoaded) {
            return const Center(child: Text('Unable to load your profile.'));
          }

          final profile = state.profile;
          final onboarding = profile.onboarding;

          return RefreshIndicator(
            onRefresh: () async => context.read<ProfileCubit>().loadProfile(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const _HubHeader(),
                const SizedBox(height: 16),
                if (onboarding != null) _ProgressBar(onboarding: onboarding),
                const SizedBox(height: 24),
                _StepTile(
                  index: 1,
                  title: 'Professional profile',
                  incompleteHint: _profileHint(onboarding?.profile),
                  icon: Icons.assignment_ind_outlined,
                  step: onboarding?.profile,
                  onTap: () => _openProfile(profile),
                ),
                _StepTile(
                  index: 2,
                  title: 'Certificates',
                  incompleteHint: 'Add at least one professional certificate',
                  icon: Icons.workspace_premium_outlined,
                  step: onboarding?.certificates,
                  onTap: () => _openProfile(profile),
                ),
                _StepTile(
                  index: 3,
                  title: 'Provided services',
                  incompleteHint: 'Select the services you offer to patients',
                  icon: Icons.medical_services_outlined,
                  step: onboarding?.services,
                  onTap: () => _openServices(profile),
                ),
                _StepTile(
                  index: 4,
                  title: 'Working schedule',
                  incompleteHint: 'Set your weekly availability',
                  icon: Icons.calendar_month_outlined,
                  step: onboarding?.schedule,
                  onTap: _openSchedule,
                ),
                const SizedBox(height: 16),
                _ReadinessNote(onboarding: onboarding),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _profileHint(OnboardingStep? step) {
    if (step == null || step.complete || step.missing.isEmpty) return null;
    final labels = step.missing.map(_fieldLabel).toList();
    return 'Missing: ${labels.join(', ')}';
  }

  String _fieldLabel(String key) {
    switch (key) {
      case 'name':
        return 'Name';
      case 'job_title':
        return 'Job title';
      case 'country_code':
        return 'Country';
      case 'about':
        return 'About you';
      case 'workplace':
        return 'Workplace';
      default:
        return key;
    }
  }
}

class _HubHeader extends StatelessWidget {
  const _HubHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Complete these steps to get verified',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Verified professionals become visible to patients and can receive '
          'bookings. Finish every step below, then submit for review.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final OnboardingStatus onboarding;
  const _ProgressBar({required this.onboarding});

  @override
  Widget build(BuildContext context) {
    final completed = onboarding.completedCount;
    final total = onboarding.totalCount;
    final double progress = total == 0 ? 0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$completed of $total steps complete',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(Const.aqua),
          ),
        ),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final String title;
  final String? incompleteHint;
  final IconData icon;
  final OnboardingStep? step;
  final VoidCallback onTap;

  const _StepTile({
    required this.index,
    required this.title,
    required this.incompleteHint,
    required this.icon,
    required this.step,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool complete = step?.complete ?? false;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: complete ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: complete
                ? Colors.green.withValues(alpha: 0.1)
                : Const.aqua.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            complete ? Icons.check : icon,
            color: complete ? Colors.green : Const.aqua,
            size: 20,
          ),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(
          complete ? 'Completed' : (incompleteHint ?? 'Not started yet'),
          style: TextStyle(
            fontSize: 12,
            color: complete ? Colors.green.shade700 : Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}

class _ReadinessNote extends StatelessWidget {
  final OnboardingStatus? onboarding;
  const _ReadinessNote({required this.onboarding});

  @override
  Widget build(BuildContext context) {
    final bool ready = onboarding?.canSubmit ?? false;
    final Color color = ready ? Colors.green : Colors.grey;
    final String message = ready
        ? "All steps complete — you're ready to submit for verification."
        : 'Complete all steps above to submit for verification.';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(ready ? Icons.check_circle_outline : Icons.info_outline,
              size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }
}
