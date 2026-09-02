import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// A tappable chip for single or multi-select choices — sub-categories on step
/// 1b, issues on step 2.
class SelectionChip extends StatelessWidget {
  const SelectionChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final foreground = switch ((enabled, selected)) {
      (false, _) => Const.placeholderTextColor,
      (true, true) => Colors.white,
      (true, false) => Const.primaryTextColor,
    };

    return Material(
      color: switch ((enabled, selected)) {
        (false, _) => Const.surfaceMuted,
        (true, true) => Const.aqua,
        (true, false) => Colors.white,
      },
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected && enabled ? Const.aqua : Const.borderSubtle,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                label,
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
    );
  }
}
