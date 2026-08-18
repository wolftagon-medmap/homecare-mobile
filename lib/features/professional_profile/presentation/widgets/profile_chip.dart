import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// Read-only chip used on both the Care DNA card and the patient-facing
/// profile. Filled when it carries a level, outlined when it is a plain tag.
class ProfileChip extends StatelessWidget {
  const ProfileChip({
    super.key,
    required this.label,
    this.filled = false,
    this.dense = false,
  });

  final String label;
  final bool filled;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: filled ? Const.aqua.withValues(alpha: 0.12) : Colors.transparent,
        border: Border.all(
          color:
              filled ? Const.aqua.withValues(alpha: 0.5) : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: dense ? 11 : 12.5,
          fontWeight: filled ? FontWeight.w600 : FontWeight.w500,
          color: filled ? Const.tosca : Colors.grey.shade700,
        ),
      ),
    );
  }
}
