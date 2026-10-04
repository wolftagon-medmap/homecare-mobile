import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/health_profile_routes.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_state.dart';
import 'package:m2health/features/health_profile/presentation/widgets/health_messages.dart';
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
    context.read<HealthProfileCubit>().load();
  }

  void _open(HealthSectionSummary section) {
    if (section.opensRoute == HealthSectionRoute.mentalState) {
      context.push(AppRoutes.profileMentalState);
      return;
    }
    context.push(HealthProfileRoutes.sectionFor(section.code));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.healthProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(t.namespace_title, style: ProText.sectionTitle),
      ),
      body: BlocBuilder<HealthProfileCubit, HealthProfileState>(
        builder: (context, state) {
          return switch (state.status) {
            HealthProfileStatus.initial ||
            HealthProfileStatus.loading =>
              HealthLoadingMessage(message: t.list.loading),
            HealthProfileStatus.error => HealthErrorMessage(
                title: t.list.load_failed,
                reason: healthFailureReason(context, state.failure),
                onRetry: context.read<HealthProfileCubit>().load,
              ),
            HealthProfileStatus.ready => state.sections.isEmpty
                ? Center(
                    child: Text(
                      t.list.empty,
                      style: const TextStyle(color: Const.healthMutedText),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.sections.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final section = state.sections[index];
                      return _SectionRow(
                        title: section.title,
                        onTap: () => _open(section),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Const.borderSubtle),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: ProText.bodyStrong.copyWith(
                      fontSize: 15,
                      color: Const.primaryTextColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Const.healthMutedText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
