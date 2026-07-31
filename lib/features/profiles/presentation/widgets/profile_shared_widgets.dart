import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/profile_widget.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/profiles/domain/entities/onboarding_status.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

// Widgets shared by two or more of the role-specific profile pages
// (Patient / Professional / Admin). Split out of profile_page.dart (SCRUM-67).

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String lastUpdated;
  final bool? isVerified;
  final DateTime? verifiedAt;
  final VerificationStatus? verificationStatus;

  const ProfileHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.lastUpdated,
    this.isVerified,
    this.verifiedAt,
    this.verificationStatus,
  });

  VerificationStatus? get _status =>
      verificationStatus ??
      (isVerified == null
          ? null
          : (isVerified!
              ? VerificationStatus.verified
              : VerificationStatus.incomplete));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatarWidget(
          avatarUrl: avatarUrl,
          size: 100,
          borderRadius: 10,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_status != null) ...[
                _VerificationBadge(status: _status!),
                if (_status == VerificationStatus.verified &&
                    verifiedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.profile_verified_since_date(
                        DateFormat('MMM dd, yyyy').format(verifiedAt!)),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
                const SizedBox(height: 8),
              ],
              Text(
                '${context.l10n.last_updated}:',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                lastUpdated,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final VerificationStatus status;
  const _VerificationBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    final String label;
    switch (status) {
      case VerificationStatus.verified:
        color = Colors.green;
        icon = Icons.verified;
        label = context.l10n.profile_professional_verified_label;
        break;
      case VerificationStatus.pending:
        color = Colors.orange;
        icon = Icons.hourglass_top;
        label = 'Under review';
        break;
      case VerificationStatus.rejected:
        color = Colors.red;
        icon = Icons.error_outline;
        label = 'Needs changes';
        break;
      case VerificationStatus.incomplete:
      case VerificationStatus.unknown:
        color = Colors.orange;
        icon = Icons.pending_outlined;
        label = context.l10n.profile_professional_unverified_label;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentSection extends StatelessWidget {
  const AppointmentSection({super.key});

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
              context.l10n.appointment,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ListTile(
              leading:
                  const Icon(Icons.calendar_today, color: Color(0xFF35C5CF)),
              title: Text(context.l10n.profile_all_my_appointments),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.go(AppRoutes.appointment);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingSection extends StatelessWidget {
  /// Saved addresses are a patient concept (home, parent's house, etc.) — admins
  /// and professionals have no visit locations to manage here.
  final bool showSavedAddresses;

  const SettingSection({super.key, this.showSavedAddresses = false});

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
              context.t.settings.settings,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ListTile(
              leading: const Icon(Icons.key_rounded, color: Const.aqua),
              title: Text(context.t.settings.account),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.pushNamed(AppRoutes.accountSettings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Const.aqua),
              title: Text(context.t.settings.app_language),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.pushNamed(AppRoutes.appLanguageSetting);
              },
            ),
            if (showSavedAddresses)
              ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Const.aqua),
                title: Text(context.l10n.settings_saved_addresses),
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.pushNamed(AppRoutes.savedAddresses);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () async {
          if (context.mounted) {
            context.read<AuthCubit>().loggedOut();
          }
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(context.l10n.auth_logout,
            style: const TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
