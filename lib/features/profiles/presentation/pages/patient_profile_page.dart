import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/auth_guard_dialog.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';
import 'package:m2health/features/profiles/presentation/widgets/profile_shared_widgets.dart';
import 'package:m2health/route/app_routes.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
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
    context.read<PatientProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.profile_patient_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<PatientProfileCubit, PatientProfileState>(
        listener: (context, state) {
          if (state is PatientProfileUnauthenticated) {
            showAuthGuardDialog(context);
          }
        },
        builder: (context, state) {
          if (state is PatientProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PatientProfileLoaded) {
            final Profile profile = state.profile;
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
                      name: profile.name,
                      avatarUrl: profile.avatar,
                      lastUpdated: formatDateTime(profile.updatedAt),
                    ),
                    const SizedBox(height: 16),
                    const _ProfileInformationSection(),
                    const SizedBox(height: 16),
                    const _HealthRecordsSection(),
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
          } else if (state is PatientProfileError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text(context.l10n.profile_not_found));
          }
        },
      ),
    );
  }
}

class _ProfileInformationSection extends StatelessWidget {
  const _ProfileInformationSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.profile_patient_info_section,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_basic_info,
              svgAsset: 'assets/icons/lab_profile.svg',
              onTap: () {
                context.push(AppRoutes.profileBasicInfo);
              },
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_medical_history_n_risk_factor,
              svgAsset: 'assets/icons/medical_report.svg',
              onTap: () {
                context.push(AppRoutes.profileMedicalHistory);
              },
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_lifestyle_n_selfcare,
              svgAsset: 'assets/icons/muscle.svg',
              onTap: () {
                context.push(AppRoutes.profileLifestyle);
              },
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_physical_sign,
              svgAsset: 'assets/icons/physical_sign.svg',
              onTap: () {
                context.push(AppRoutes.profilePhysicalSigns);
              },
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_mental_state,
              svgAsset: 'assets/icons/mental_health.svg',
              onTap: () {
                context.push(AppRoutes.profileMentalState);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthRecordsSection extends StatelessWidget {
  const _HealthRecordsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.profile_patient_health_record_section,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_medical_record,
              svgAsset: 'assets/icons/capsule_n_pill.svg',
              onTap: () {
                context.push(AppRoutes.medicalRecord);
              },
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_pharmacogenomics,
              svgAsset: 'assets/icons/DNA.svg',
              onTap: () {
                context.push(AppRoutes.pharmagenomics);
              },
            ),
            _CustomListTile(
              title: context.l10n.profile_patient_wellness_genomics,
              svgAsset: 'assets/icons/DNA.svg',
              onTap: () {
                context.push(AppRoutes.wellnessGenomics);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final String svgAsset;
  final VoidCallback onTap;

  const _CustomListTile({
    required this.title,
    required this.svgAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 28,
        width: 24,
        child: SvgPicture.asset(
          svgAsset,
          height: 28,
          colorFilter: const ColorFilter.mode(Const.aqua, BlendMode.srcIn),
        ),
      ),
      title: Text(title),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
