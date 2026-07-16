import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/profile_widget.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';

/// The profile list the account can act for, opened from the dashboard header
/// and the patient profile page. Picking one switches the active profile.
///
/// Patients only — professionals and admins have no family profiles, so callers
/// must not offer this to them.
Future<void> showProfileSwitcherSheet(BuildContext context) {
  final cubit = context.read<PatientProfileCubit>();

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    // Without this the sheet mounts on the shell branch's navigator and the
    // bottom nav bar covers its lower rows.
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    // The sheet lives above the page, outside the provider subtree it was
    // opened from, so it needs the cubit handed to it explicitly.
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const _ProfileSwitcherSheet(),
    ),
  );
}

class _ProfileSwitcherSheet extends StatelessWidget {
  const _ProfileSwitcherSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PatientProfileCubit, PatientProfileState>(
        builder: (context, state) {
          if (state is! PatientProfileLoaded) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHeader(activeName: state.activeProfile.name),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.profiles.length,
                  itemBuilder: (context, index) {
                    final profile = state.profiles[index];
                    return _ProfileTile(
                      profile: profile,
                      isActive: profile.id == state.activeProfileId,
                      onTap: () {
                        context
                            .read<PatientProfileCubit>()
                            .setActiveProfile(profile.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const _NewProfileButton(),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String activeName;
  const _SheetHeader({required this.activeName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              activeName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.l10n.common_close,
              style: const TextStyle(
                color: Const.aqua,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Profile profile;
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.profile,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ProfileAvatarWidget(
        avatarUrl: profile.avatar,
        size: 40,
        borderRadius: 20,
      ),
      title: Text(
        profile.name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isActive ? Const.aqua : Colors.black87,
        ),
      ),
      subtitle: Text(
        relationLabel(context, profile.relation),
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing:
          isActive ? const Icon(Icons.check, color: Const.aqua, size: 20) : null,
    );
  }
}

class _NewProfileButton extends StatelessWidget {
  const _NewProfileButton();

  @override
  Widget build(BuildContext context) {
    // Disabled until SCRUM-72 builds the create page.
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        child: Text(
          context.l10n.profile_switcher_new_profile,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

/// Human-readable label for a profile's relationship to the account holder.
String relationLabel(BuildContext context, String? relation) {
  switch (relation) {
    case 'self':
      return context.l10n.profile_relation_self;
    case 'spouse':
      return context.l10n.profile_relation_spouse;
    case 'parent':
      return context.l10n.profile_relation_parent;
    case 'child':
      return context.l10n.profile_relation_child;
    case 'sibling':
      return context.l10n.profile_relation_sibling;
    default:
      return context.l10n.profile_relation_other;
  }
}
