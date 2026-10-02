import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';
import 'package:m2health/features/health_profile/presentation/widgets/health_messages.dart';
import 'package:m2health/features/health_profile/presentation/widgets/question_view.dart';
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
    final t = context.t.healthProfile.section;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.discard_title),
        content: Text(t.discard_body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(foregroundColor: Const.healthAction),
            child: Text(t.keep_editing),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Const.healthAction),
            child: Text(t.discard),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Future<void> _save() async {
    final cubit = context.read<HealthSectionCubit>();
    final t = context.t.healthProfile.section;
    final saved = await cubit.save();
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    if (!saved) {
      messenger.showSnackBar(SnackBar(
        content: Text(
          '${t.save_failed} ${healthFailureReason(context, cubit.state.failure)}',
        ),
      ));
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(t.saved)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.healthProfile;

    return BlocBuilder<HealthSectionCubit, HealthSectionState>(
      builder: (context, state) {
        final cubit = context.read<HealthSectionCubit>();
        final section = state.section;

        return PopScope(
          canPop: !state.isDirty,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final router = GoRouter.of(context);
            if (await _confirmDiscard()) router.pop();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: _SectionTitle(
                title: section?.title ?? t.namespace_title,
                updatedAt: section?.updatedAt,
              ),
            ),
            body: switch (state.status) {
              HealthSectionStatus.initial ||
              HealthSectionStatus.loading =>
                HealthLoadingMessage(message: t.section.loading),
              HealthSectionStatus.loadFailed => HealthErrorMessage(
                  title: t.section.load_failed,
                  reason: healthFailureReason(context, state.failure),
                  onRetry: cubit.load,
                ),
              _ => _QuestionList(state: state, cubit: cubit),
            },
            bottomNavigationBar: section == null
                ? null
                : _SaveBar(
                    label: t.section.save,
                    saving: state.status == HealthSectionStatus.saving,
                    onPressed: state.canSave ? _save : null,
                  ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.updatedAt});

  final String title;
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    final updatedAt = this.updatedAt;
    final locale = TranslationProvider.of(context).locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: ProText.sectionTitle),
        if (updatedAt != null)
          Text(
            context.t.healthProfile.section.last_updated(
              date: DateFormat.yMMMd(locale).format(updatedAt),
            ),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Const.healthMutedText,
            ),
          ),
      ],
    );
  }
}

class _QuestionList extends StatelessWidget {
  const _QuestionList({required this.state, required this.cubit});

  final HealthSectionState state;
  final HealthSectionCubit cubit;

  @override
  Widget build(BuildContext context) {
    final questions = state.visibleQuestions;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final heading = _startsGroup(questions, index) ? question.group : null;

        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 8 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (heading != null) ...[
                Semantics(
                  header: true,
                  child: Text(heading, style: ProText.sectionTitle),
                ),
                const SizedBox(height: 8),
              ],
              QuestionView(
                key: ValueKey(question.code),
                question: question,
                state: state,
                cubit: cubit,
              ),
            ],
          ),
        );
      },
    );
  }

  bool _startsGroup(List<HealthQuestion> questions, int index) {
    final group = questions[index].group;
    if (group == null) return false;
    return index == 0 || questions[index - 1].group != group;
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.label,
    required this.saving,
    required this.onPressed,
  });

  final String label;
  final bool saving;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Const.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: FilledButton(
            onPressed: saving ? () {} : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Const.healthAction,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Const.borderSubtle,
              disabledForegroundColor: Const.primaryTextColor,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
