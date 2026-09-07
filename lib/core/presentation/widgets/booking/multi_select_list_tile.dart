import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class MultiSelectListTile extends StatelessWidget {
  const MultiSelectListTile({
    super.key,
    required this.title,
    required this.selected,
    this.onChanged,
    this.subtitle,
    this.trailing,
    this.onInfo,
  });

  final String title;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;

  /// Usually a [PricePill] on add-ons. Sits between the title and the info icon.
  final Widget? trailing;

  /// Only add-ons carry a description worth reading, so only they pass this and
  /// only they show the info icon.
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged!(!selected) : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Const.borderSubtle),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: selected,
                  onChanged:
                      enabled ? (value) => onChanged!(value ?? false) : null,
                  activeColor: Const.aqua,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: Const.borderSubtle, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: ProText.bodyStrong.copyWith(
                        height: 1.25,
                        color: enabled
                            ? Const.primaryTextColor
                            : Const.placeholderTextColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: ProText.hint.copyWith(height: 1.35),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                trailing!,
              ],
              if (onInfo != null) ...[
                const SizedBox(width: 6),
                IconButton(
                  onPressed: onInfo,
                  icon: const Icon(Icons.info_outline_rounded),
                  iconSize: 20,
                  color: Colors.grey,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
