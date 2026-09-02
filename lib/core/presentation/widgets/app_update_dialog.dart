import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showAppUpdateDialog(
  BuildContext context, {
  required bool forced,
  required String updateUrl,
  required String currentVersion,
  required String latestVersion,
  String? message,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: !forced,
    barrierLabel: 'app-update',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => _AppUpdateDialog(
      forced: forced,
      updateUrl: updateUrl,
      currentVersion: currentVersion,
      latestVersion: latestVersion,
      message: message,
    ),
    transitionBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _AppUpdateDialog extends StatelessWidget {
  final bool forced;
  final String updateUrl;
  final String currentVersion;
  final String latestVersion;
  final String? message;

  const _AppUpdateDialog({
    required this.forced,
    required this.updateUrl,
    required this.currentVersion,
    required this.latestVersion,
    this.message,
  });

  Future<void> _openStore() async {
    final uri = Uri.parse(updateUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !forced,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 124,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8EF4E8), Const.aqua],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Decorative depth circle
              Positioned(
                right: 36,
                top: 16,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Icon medallion
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.system_update_alt_rounded,
                      color: Const.aqua,
                      size: 34,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (forced)
          Positioned(
            bottom: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Update required',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Const.tosca,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, forced ? 28 : 32, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            forced ? 'Time to update M2Health' : 'A new version is available',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF232F55),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message ??
                (forced
                    ? 'This version of M2Health is no longer supported. '
                        'Please update to keep using the app.'
                    : "We've added improvements and fixes. "
                        'Update now for the best experience.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Const.contentTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildVersionChip(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openStore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Update Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (!forced)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Maybe later',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Const.contentTextColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVersionChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Const.grayLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'v$currentVersion',
            style: const TextStyle(
              fontSize: 12,
              color: Const.contentTextColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.arrow_forward_rounded,
                size: 14, color: Const.contentTextColor),
          ),
          Text(
            'v$latestVersion',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Const.tosca,
            ),
          ),
        ],
      ),
    );
  }
}
