import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';

/// One tappable answer. The patient's own answers are choices too.
class Choice {
  final String value;
  final String label;
  final bool selected;
  final bool exclusive;
  final HealthOptionIcon? icon;

  const Choice({
    required this.value,
    required this.label,
    required this.selected,
    this.exclusive = false,
    this.icon,
  });
}

class ChoiceRows extends StatelessWidget {
  const ChoiceRows({
    super.key,
    required this.choices,
    required this.single,
    required this.onTap,
  });

  final List<Choice> choices;
  final bool single;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final firstExclusive = choices.indexWhere((choice) => choice.exclusive);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, choice) in choices.indexed) ...[
          if (index == firstExclusive && index > 0)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(height: 1, color: Const.borderSubtle),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SelectableTile(
              choice: choice,
              single: single,
              onTap: onTap,
              shape: _rounded(14, choice.selected),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    _indicator(choice.selected),
                    size: 22,
                    color: choice.selected ? Const.aqua : Const.healthMutedText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _Label(choice)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _indicator(bool selected) => switch ((single, selected)) {
        (true, true) => Icons.radio_button_checked,
        (true, false) => Icons.radio_button_off,
        (false, true) => Icons.check_box,
        (false, false) => Icons.check_box_outline_blank,
      };
}

class ChoiceChips extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.choices,
    required this.single,
    required this.onTap,
  });

  final List<Choice> choices;
  final bool single;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final choice in choices)
          _SelectableTile(
            choice: choice,
            single: single,
            onTap: onTap,
            shape: StadiumBorder(side: _side(choice.selected)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: _Label(choice),
          ),
      ],
    );
  }
}

class ChoiceGrid extends StatelessWidget {
  const ChoiceGrid({
    super.key,
    required this.choices,
    required this.single,
    required this.onTap,
  });

  final List<Choice> choices;
  final bool single;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final columns = constraints.maxWidth < 300 ? 2 : 3;
        final tileWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final choice in choices)
              SizedBox(
                width: tileWidth,
                child: _SelectableTile(
                  choice: choice,
                  single: single,
                  onTap: onTap,
                  shape: _rounded(12, choice.selected),
                  minHeight: 72,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_iconFor(choice.icon) case final icon?) ...[
                        Icon(icon, size: 24, color: _foreground(choice)),
                        const SizedBox(height: 6),
                      ],
                      _Label(choice, center: true),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  IconData? _iconFor(HealthOptionIcon? icon) => switch (icon) {
        HealthOptionIcon.walk => Icons.directions_walk,
        HealthOptionIcon.gym => Icons.fitness_center,
        HealthOptionIcon.run => Icons.directions_run,
        HealthOptionIcon.swim => Icons.pool,
        HealthOptionIcon.bike => Icons.directions_bike,
        null => null,
      };
}

/// The shared shell: selected colours, tap target, and screen reader state.
class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.choice,
    required this.single,
    required this.onTap,
    required this.shape,
    required this.padding,
    required this.child,
    this.minHeight = 48,
  });

  final Choice choice;
  final bool single;
  final ValueChanged<String> onTap;
  final ShapeBorder shape;
  final EdgeInsets padding;
  final double minHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: choice.selected,
      inMutuallyExclusiveGroup: single,
      button: true,
      excludeSemantics: true,
      label: choice.label,
      child: Material(
        color: choice.selected ? Const.healthSelectedSurface : Colors.white,
        shape: shape,
        child: InkWell(
          onTap: () => onTap(choice.value),
          customBorder: shape,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.choice, {this.center = false});

  final Choice choice;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Text(
      choice.label,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: center ? 13 : 14,
        fontWeight: choice.selected ? FontWeight.w600 : FontWeight.w500,
        color: _foreground(choice),
      ),
    );
  }
}

Color _foreground(Choice choice) =>
    choice.selected ? Const.healthSelectedText : Const.primaryTextColor;

BorderSide _side(bool selected) =>
    BorderSide(color: selected ? Const.aqua : Const.borderSubtle);

RoundedRectangleBorder _rounded(double radius, bool selected) =>
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: _side(selected),
    );
