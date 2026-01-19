import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/buttons/button_size.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final IconData? icon;
  final double? width;
  final ButtonSize size;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = Const.aqua,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.icon,
    this.width,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: size.height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          side: BorderSide(color: foregroundColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: size.iconSize),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: size.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
