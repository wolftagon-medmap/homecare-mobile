import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/auth_guard_dialog.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/care_dna_card.dart';
import 'package:m2health/features/professional_profile/domain/entities/onboarding_status.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/pages/manage_provided_services_page.dart';
import 'package:m2health/core/presentation/widgets/profile_shared_widgets.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';

class ProfessionalProfilePage extends StatefulWidget {
  const ProfessionalProfilePage({super.key});

  @override
  State<ProfessionalProfilePage> createState() =>
      _ProfessionalProfilePageState();
}

class _ProfessionalProfilePageState extends State<ProfessionalProfilePage> {
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return context.l10n.none;
    return DateFormat('MMM dd, yyyy • HH:mm').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<ProfessionalProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.profile_professional_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ProfessionalProfileCubit, ProfessionalProfileState>(
        listener: (context, state) {
          if (state is ProfessionalProfileUnauthenticated) {
            showAuthGuardDialog(context);
          }
        },
        builder: (context, state) {
          if (state is ProfessionalProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfessionalProfileLoaded) {
            final ProfessionalProfile profile = state.profile;
            return RefreshIndicator(
              onRefresh: () async {
                _fetchData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfileHeader(
                      name: profile.name ?? context.l10n.none,
                      avatarUrl: profile.avatar,
                      lastUpdated: formatDateTime(profile.updatedAt),
                      isVerified: profile.isVerified,
                      verifiedAt: profile.verifiedAt,
                      verificationStatus: profile.verificationStatus,
                    ),
                    const SizedBox(height: 16),
                    if (profile.verificationStatus !=
                        VerificationStatus.verified) ...[
                      _VerificationOnboardingCard(profile: profile),
                      const SizedBox(height: 16),
                    ],
                    const CareDnaCard(),
                    const SizedBox(height: 16),
                    _ProfessionalProfileSection(profile: profile),
                    const SizedBox(height: 16),
                    const AppointmentSection(),
                    const SizedBox(height: 16),
                    const SettingSection(),
                    const SizedBox(height: 16),
                    const LogoutButton(),
                    const SizedBox(height: 80)
                  ],
                ),
              ),
            );
          } else if (state is ProfessionalProfileError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text(context.l10n.profile_not_found));
          }
        },
      ),
    );
  }
}

/// The profile hub, grouped rather than listed.
///
/// A flat list of editors is a settings page. Three groups answer three
/// different questions — who you are, what you do, and how you work — which is
/// also why the location and schedule screens sit together instead of being
/// scattered between Edit Profile and here.
class _ProfessionalProfileSection extends StatelessWidget {
  final ProfessionalProfile profile;
  const _ProfessionalProfileSection({required this.profile});

  Future<void> _openServices(BuildContext context) async {
    final role = await Utils.getSpString(Const.ROLE);
    if (role == null || !context.mounted) return;

    await context.push(
      AppRoutes.professionalServices,
      extra: ManageServicesArgs(
        role: role,
        isHomeScreeningAuthorized: profile.isHomeScreeningAuthorized ?? false,
        currentServices: profile.providedServices,
      ),
    );

    if (context.mounted) {
      context.read<ProfessionalProfileCubit>().loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HubGroup(
          title: 'Profile',
          rows: [
            _HubRow(
              icon: Icons.assignment_ind,
              title: 'Personal details',
              onTap: () => context.push(AppRoutes.editProfessionalProfile,
                  extra: profile),
            ),
            _HubRow(
              icon: Icons.workspace_premium_outlined,
              title: 'Credentials',
              onTap: () => context.push(AppRoutes.verificationHub),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _HubGroup(
          title: 'Practice',
          rows: [
            _HubRow(
              icon: Icons.medical_services_outlined,
              title: 'Services & expertise',
              onTap: () => _openServices(context),
            ),
            _HubRow(
              icon: Icons.favorite_outline,
              title: 'Condition experience',
              onTap: () => context.push(AppRoutes.professionalConditions),
            ),
            _HubRow(
              icon: Icons.translate,
              title: 'Languages & care style',
              onTap: () => context.push(AppRoutes.professionalLanguages),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _HubGroup(
          title: 'Availability',
          rows: [
            _HubRow(
              icon: Icons.calendar_month,
              title: 'Working hours',
              onTap: () => context.push(AppRoutes.workingSchedule),
            ),
            _HubRow(
              icon: Icons.map_outlined,
              title: 'Coverage area',
              onTap: () => context.push(AppRoutes.professionalCoverage),
            ),
            _HubRow(
              icon: Icons.tune,
              title: 'Work preferences',
              onTap: () => context.push(AppRoutes.professionalPreferences),
            ),
          ],
        ),
      ],
    );
  }
}

class _HubGroup extends StatelessWidget {
  const _HubGroup({required this.title, required this.rows});

  final String title;
  final List<_HubRow> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _HubRow extends StatelessWidget {
  const _HubRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Const.aqua),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _VerificationOnboardingCard extends StatelessWidget {
  final ProfessionalProfile profile;
  const _VerificationOnboardingCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      child: InkWell(
        onTap: () => context.push(AppRoutes.verificationHub),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: switch (profile.verificationStatus) {
            VerificationStatus.pending => _buildPending(context),
            VerificationStatus.rejected => _buildRejected(context),
            _ => _buildIncomplete(context, profile.onboarding),
          },
        ),
      ),
    );
  }

  Widget _buildRejected(BuildContext context) {
    final reason = (profile.rejectionReason?.isNotEmpty ?? false)
        ? profile.rejectionReason!
        : rejectionCategoryLabel(profile.rejectionCategory);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.red),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Changes needed',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(reason,
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Review & resubmit',
                style:
                    TextStyle(color: Const.aqua, fontWeight: FontWeight.w600)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: Const.aqua),
          ],
        ),
      ],
    );
  }

  Widget _buildPending(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.hourglass_top, color: Colors.orange),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Verification under review',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                "Your profile has been submitted. We'll notify you once it's reviewed.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ],
    );
  }

  Widget _buildIncomplete(BuildContext context, OnboardingStatus? onboarding) {
    final completed = onboarding?.completedCount ?? 0;
    final total = onboarding?.totalCount ?? 4;
    final double progress = total == 0 ? 0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Const.aqua.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_user, color: Const.aqua),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Get verified',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    'Complete your profile so patients can find and book you.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(Const.aqua),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$completed of $total steps complete',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            const Row(
              children: [
                Text('Continue',
                    style: TextStyle(
                        color: Const.aqua, fontWeight: FontWeight.w600)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Const.aqua),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
