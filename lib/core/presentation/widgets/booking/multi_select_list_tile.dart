import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// A checkbox row for list-shaped multi-select — the issue catalogue on step 2
/// and the add-on side path, where each option carries a description or price
/// and chips would be too cramped.
class MultiSelectListTile extends StatelessWidget {
  const MultiSelectListTile({
    super.key,
    required this.title,
    required this.selected,
    this.onChanged,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;

  /// Usually a [PricePill] on add-ons. Sits left of the checkbox.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged!(!selected) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Const.borderSubtle)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: enabled
                            ? Const.primaryTextColor
                            : Const.placeholderTextColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Const.contentTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
              const SizedBox(width: 4),
              Checkbox(
                value: selected,
                onChanged:
                    enabled ? (value) => onChanged!(value ?? false) : null,
                activeColor: Const.aqua,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
