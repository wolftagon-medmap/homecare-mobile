import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';
import 'package:m2health/features/health_profile/presentation/widgets/choice_views.dart';
import 'package:m2health/features/health_profile/presentation/widgets/own_answer_field.dart';
import 'package:m2health/i18n/translations.g.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.question,
    required this.state,
    required this.cubit,
  });

  final HealthQuestion question;
  final HealthSectionState state;
  final HealthSectionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            question.text,
            style: ProText.bodyStrong.copyWith(
              fontSize: 15,
              color: Const.primaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (question.type == HealthQuestionType.longText)
          _LongTextField(
            key: ValueKey(question.code),
            initialValue: state.text(question.code),
            hint: question.hint,
            onChanged: (value) => cubit.setText(question, value),
          )
        else
          _ChoiceQuestion(question: question, state: state, cubit: cubit),
      ],
    );
  }
}

class _ChoiceQuestion extends StatelessWidget {
  const _ChoiceQuestion({
    required this.question,
    required this.state,
    required this.cubit,
  });

  final HealthQuestion question;
  final HealthSectionState state;
  final HealthSectionCubit cubit;

  @override
  Widget build(BuildContext context) {
    final single = question.type == HealthQuestionType.singleChoice;
    final selected = state.selection(question.code);
    final own = selected.where(question.isCustomValue);

    final choices = [
      for (final option in question.options.where((o) => !o.exclusive))
        _choiceFor(option, selected),
      for (final value in own)
        Choice(value: value, label: value, selected: true),
      for (final option in question.options.where((o) => o.exclusive))
        _choiceFor(option, selected),
    ];

    void onTap(String value) {
      if (question.isCustomValue(value)) {
        cubit.removeValue(question, value);
      } else if (single) {
        cubit.selectOne(question, value);
      } else {
        cubit.toggleMany(question, value);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        switch (question.layout) {
          HealthQuestionLayout.rows =>
            ChoiceRows(choices: choices, single: single, onTap: onTap),
          HealthQuestionLayout.chips =>
            ChoiceChips(choices: choices, single: single, onTap: onTap),
          HealthQuestionLayout.grid =>
            ChoiceGrid(choices: choices, single: single, onTap: onTap),
        },
        if (question.allowsCustom)
          OwnAnswerField(
            label: question.customLabel ??
                context.t.healthProfile.section.add_other,
            enabled: cubit.canAddCustomValue(question),
            onSubmitted: (value) => cubit.addCustomValue(question, value),
          ),
      ],
    );
  }

  Choice _choiceFor(HealthOption option, List<String> selected) => Choice(
        value: option.code,
        label: option.label,
        selected: selected.contains(option.code),
        exclusive: option.exclusive,
        icon: option.icon,
      );
}

class _LongTextField extends StatefulWidget {
  const _LongTextField({
    super.key,
    required this.initialValue,
    required this.hint,
    required this.onChanged,
  });

  final String initialValue;
  final String? hint;
  final ValueChanged<String> onChanged;

  @override
  State<_LongTextField> createState() => _LongTextFieldState();
}

class _LongTextFieldState extends State<_LongTextField> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void didUpdateWidget(covariant _LongTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A save returns the stored text; only adopt it when it differs, so the
    // cursor does not jump while typing.
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      minLines: 3,
      maxLines: 6,
      maxLength: maxLongTextLength,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Const.healthMutedText),
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Const.healthAction),
        ),
      ),
    );
  }
}
