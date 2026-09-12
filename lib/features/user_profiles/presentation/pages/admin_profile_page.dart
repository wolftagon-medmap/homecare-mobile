import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/auth_guard_dialog.dart';
import 'package:m2health/core/presentation/widgets/profile_shared_widgets.dart';
import 'package:m2health/features/pricing/pricing_routes.dart';
import 'package:m2health/features/user_profiles/domain/entities/profile.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_state.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
    context.read<PatientProfileCubit>().loadProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          // Matches the original unified page: admin reuses the
          // "professional" title copy — preserved as-is, not a new choice.
          context.l10n.profile_professional_title,
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
            final Profile profile = state.activeProfile;
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
                    const _AdminSection(),
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

class _AdminSection extends StatelessWidget {
  const _AdminSection();

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
              context.l10n.profile_admin_panel_section,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note, color: Color(0xFF35C5CF)),
              title: Text(context.l10n.profile_admin_manage_services),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                GoRouter.of(context).push(AppRoutes.manageServices);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.verified_user, color: Color(0xFF35C5CF)),
              title: Text(context.l10n.profile_admin_verify_professional),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(AppRoutes.adminProfessionals);
              },
            ),
            ListTile(
              leading: const Icon(Icons.price_change, color: Color(0xFF35C5CF)),
              title: Text(context.t.pricing.floor_title),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(PricingRoutes.floorPrices);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility,
                  color: Color(0xFF35C5CF)),
              title: Text(context.l10n.profile_admin_homecare_config),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(AppRoutes.adminHomecareConfig);
              },
            ),
          ],
        ),
      ),
    );
  }
}
