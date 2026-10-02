import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';

/// One tappable answer. The patient's own answers are choices too, shown
/// selected, and tapping one removes it.
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
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: Const.borderSubtle),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChoiceRow(
              choice: choice,
              single: single,
              onTap: () => onTap(choice.value),
            ),
          ),
        ],
      ],
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.choice,
    required this.single,
    required this.onTap,
  });

  final Choice choice;
  final bool single;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = choice.selected;

    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: single,
      button: true,
      excludeSemantics: true,
      label: choice.label,
      child: Material(
        color: selected ? Const.healthSelectedSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? Const.healthAction : Const.borderSubtle,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    _indicator(single: single, selected: selected),
                    size: 22,
                    color:
                        selected ? Const.healthAction : Const.healthMutedText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      choice.label,
                      style: ProText.body.copyWith(
                        color: selected
                            ? Const.healthSelectedText
                            : Const.primaryTextColor,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _indicator({required bool single, required bool selected}) {
    if (single) {
      return selected ? Icons.radio_button_checked : Icons.radio_button_off;
    }
    return selected ? Icons.check_box : Icons.check_box_outline_blank;
  }
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
          Semantics(
            selected: choice.selected,
            inMutuallyExclusiveGroup: single,
            button: true,
            excludeSemantics: true,
            label: choice.label,
            child: Material(
              color:
                  choice.selected ? Const.healthSelectedSurface : Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                  color:
                      choice.selected ? Const.healthAction : Const.borderSubtle,
                ),
              ),
              child: InkWell(
                onTap: () => onTap(choice.value),
                customBorder: const StadiumBorder(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            choice.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: choice.selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: choice.selected
                                  ? Const.healthSelectedText
                                  : Const.primaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                child: _GridTile(
                  choice: choice,
                  single: single,
                  onTap: () => onTap(choice.value),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.choice,
    required this.single,
    required this.onTap,
  });

  final Choice choice;
  final bool single;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = choice.selected;
    final foreground =
        selected ? Const.healthSelectedText : Const.primaryTextColor;
    final icon = optionIconData(choice.icon);

    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: single,
      button: true,
      excludeSemantics: true,
      label: choice.label,
      child: Material(
        color: selected ? Const.healthSelectedSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? Const.healthAction : Const.borderSubtle,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24, color: foreground),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    choice.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

IconData? optionIconData(HealthOptionIcon? icon) => switch (icon) {
      HealthOptionIcon.walk => Icons.directions_walk,
      HealthOptionIcon.gym => Icons.fitness_center,
      HealthOptionIcon.run => Icons.directions_run,
      HealthOptionIcon.swim => Icons.pool,
      HealthOptionIcon.bike => Icons.directions_bike,
      null => null,
    };
