import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// The persistent bottom action bar on every guided booking step.
///
/// Put it in `Scaffold.bottomNavigationBar` so it sizes itself and the
/// scrollable body keeps the rest of the screen. It adds the device's bottom
/// inset itself, so no `SafeArea` wrapper is needed.
class StickyBottomCta extends StatelessWidget {
  const StickyBottomCta({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.secondaryLabel,
    this.onSecondary,
    this.footer,
  });

  final String label;

  /// Null disables the button — that is how a step blocks on an empty
  /// selection.
  final VoidCallback? onPressed;
  final bool isLoading;

  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// Optional line above the buttons, usually the running estimate.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Const.borderSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (footer != null) ...[
            footer!,
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              if (secondaryLabel != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : onSecondary,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: Const.borderSubtle),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      secondaryLabel!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Const.primaryTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: secondaryLabel != null ? 2 : 1,
                child: ElevatedButton(
                  onPressed: enabled ? onPressed : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Const.aqua,
                    disabledBackgroundColor: Const.borderSubtle,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Const.placeholderTextColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
