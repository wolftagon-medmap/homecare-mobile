import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';
import 'package:m2health/features/health_profile/presentation/widgets/question_form.dart';
import 'package:m2health/i18n/translations.g.dart';

class HealthSectionPage extends StatefulWidget {
  const HealthSectionPage({super.key});

  @override
  State<HealthSectionPage> createState() => _HealthSectionPageState();
}

class _HealthSectionPageState extends State<HealthSectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<HealthSectionCubit>().load();
  }

  Future<bool> _confirmDiscard() async {
    final t = context.t.healthProfile;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.section.discard_title),
        content: Text(t.section.discard_body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.section.keep_editing),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.section.discard),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Future<void> _save() async {
    final cubit = context.read<HealthSectionCubit>();
    final t = context.t.healthProfile;
    final saved = await cubit.save();
    if (!mounted) return;

    if (saved == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(cubit.state.errorMessage ?? t.section.save_failed)),
      );
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.section.saved)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.healthProfile;

    return BlocBuilder<HealthSectionCubit, HealthSectionState>(
      builder: (context, state) {
        final cubit = context.read<HealthSectionCubit>();

        return PopScope(
          canPop: !state.isDirty,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop || !mounted) return;
            final router = GoRouter.of(context);
            if (await _confirmDiscard()) router.pop();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                state.section?.title ?? t.namespace_title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            body: switch (state.status) {
              HealthSectionStatus.initial ||
              HealthSectionStatus.loading =>
                BookingLoadingState(message: t.section.loading),
              HealthSectionStatus.error when state.section == null =>
                BookingErrorState(
                  message: state.errorMessage ?? t.section.error,
                  onRetry: cubit.load,
                ),
              _ => ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(
                        t.section.subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                    QuestionForm(cubit: cubit, state: state),
                  ],
                ),
            },
            bottomNavigationBar: StickyBottomCta(
              label: t.section.save,
              isLoading: state.status == HealthSectionStatus.saving,
              onPressed: state.canSave ? _save : null,
            ),
          ),
        );
      },
    );
  }
}
