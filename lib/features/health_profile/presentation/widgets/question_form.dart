import 'package:flutter/material.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';
import 'package:m2health/features/health_profile/presentation/widgets/attachment_field.dart';
import 'package:m2health/features/health_profile/presentation/widgets/custom_value_field.dart';
import 'package:m2health/features/health_profile/presentation/widgets/section_text_field.dart';
import 'package:m2health/features/health_profile/presentation/widgets/single_choice_field.dart';
import 'package:m2health/i18n/translations.g.dart';

class QuestionForm extends StatelessWidget {
  const QuestionForm({super.key, required this.cubit, required this.state});

  final HealthSectionCubit cubit;
  final HealthSectionState state;

  @override
  Widget build(BuildContext context) {
    final questions = state.visibleQuestions;
    final headings = _groupHeadings(questions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, question) in questions.indexed) ...[
          if (headings[index] != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                headings[index]!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: Colors.black54,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text(
              question.text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _QuestionField(
              cubit: cubit,
              state: state,
              question: question,
            ),
          ),
        ],
      ],
    );
  }

  List<String?> _groupHeadings(List<HealthQuestion> questions) {
    String? previous;
    return [
      for (final question in questions)
        if (question.group != null && question.group != previous)
          previous = question.group
        else
          null,
    ];
  }
}

class _QuestionField extends StatelessWidget {
  const _QuestionField({
    required this.cubit,
    required this.state,
    required this.question,
  });

  final HealthSectionCubit cubit;
  final HealthSectionState state;
  final HealthQuestion question;

  @override
  Widget build(BuildContext context) {
    return switch (question.type) {
      HealthQuestionType.singleChoice => _single(context),
      HealthQuestionType.multiChoice => _multi(context),
      HealthQuestionType.chipMultiChoice => _chips(context),
      HealthQuestionType.longText => _text(context),
    };
  }

  Widget _single(BuildContext context) {
    final selected = state.selection(question.code);
    final custom = selected.where(question.isCustomValue).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChoiceField(
          options: [
            for (final option in question.options)
              (code: option.code, label: option.label),
            for (final value in custom) (code: value, label: value),
          ],
          selected: selected.isEmpty ? null : selected.first,
          onSelected: (code) => cubit.selectOne(question, code),
        ),
        if (question.allowsCustom) _customField(context),
      ],
    );
  }

  Widget _multi(BuildContext context) {
    final selected = state.selection(question.code);
    final custom = selected.where(question.isCustomValue).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in question.options)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: MultiSelectListTile(
              title: option.label,
              selected: selected.contains(option.code),
              onChanged: (_) => cubit.toggleMany(question, option.code),
            ),
          ),
        for (final value in custom)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: MultiSelectListTile(
              title: value,
              selected: true,
              onChanged: (_) => cubit.removeValue(question, value),
            ),
          ),
        if (question.allowsCustom) _customField(context),
      ],
    );
  }

  Widget _chips(BuildContext context) {
    final selected = state.selection(question.code);
    final custom = selected.where(question.isCustomValue).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in question.options)
              SelectionChip(
                label: option.label,
                selected: selected.contains(option.code),
                onTap: () => cubit.toggleMany(question, option.code),
              ),
            for (final value in custom)
              SelectionChip(
                label: value,
                selected: true,
                onTap: () => cubit.removeValue(question, value),
              ),
          ],
        ),
        if (question.allowsCustom) _customField(context),
      ],
    );
  }

  Widget _text(BuildContext context) {
    final t = context.t.healthProfile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTextField(
          initialValue: state.text(question.code),
          hint: question.hint,
          onChanged: (value) => cubit.setText(question.code, value),
        ),
        if (question.allowsAttachments) ...[
          const SizedBox(height: 8),
          AttachmentField(
            attachmentIds: state.attachments(question.code),
            addLabel: t.section.add_attachment,
            itemLabel: (id) => t.section.attachment(n: id),
            uploading: state.uploading,
            onPicked: (path) => cubit.attach(question, path),
            onRemoved: (id) => cubit.removeAttachment(question, id),
          ),
        ],
      ],
    );
  }

  Widget _customField(BuildContext context) {
    return CustomValueField(
      label: question.customLabel ?? context.t.healthProfile.section.add_other,
      onSubmitted: (value) => cubit.addCustomValue(question, value),
    );
  }
}
