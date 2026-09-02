import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:url_launcher/url_launcher.dart';

/// A bottom-sheet-style consent modal for AI chat features.
///
/// Displays data sharing, privacy, and medical disclaimer information.
/// The user must explicitly accept or decline before using the AI chat.
class AiDataConsentModal extends StatelessWidget {
  const AiDataConsentModal({super.key});

  /// Shows the AI consent modal as a non-dismissible bottom sheet.
  ///
  /// Returns `true` if the user accepted, `false` if declined.
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AiDataConsentModal(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _ConsentHeader(),
              const SizedBox(height: 20),
              const _ConsentDescription(),
              const SizedBox(height: 20),
              const _ConsentInfoCard(
                icon: Icons.shield_outlined,
                iconBackgroundColor: Color(0xFFEEFCFD),
                iconColor: Const.aqua,
                title: 'Data Shared',
                description:
                    'Your messages, reported symptoms, and relevant health '
                    'metrics from your profile are transmitted to our '
                    'AI provider for processing.',
              ),
              const SizedBox(height: 12),
              const _ConsentInfoCard(
                icon: Icons.lock_outline,
                iconBackgroundColor: Color(0xFFEEFCFD),
                iconColor: Const.aqua,
                title: 'Privacy & Retention',
                description: 'Conversations are processed and stored securely.'
                    'Your data is not used to train public AI models.',
                boldSegment: 'processed and stored securely',
              ),
              const SizedBox(height: 12),
              const _ConsentInfoCard(
                icon: Icons.warning_amber_rounded,
                iconBackgroundColor: Color(0xFFFFF8EC),
                iconColor: Color(0xFFF59E0B),
                title: 'Medical Disclaimer',
                description:
                    'AI-generated insights are for informational purposes '
                    'only and are not a substitute for professional medical '
                    'diagnosis or advice.',
                boldSegment:
                    'not a substitute for professional medical diagnosis or advice',
              ),
              const SizedBox(height: 20),
              const _PrivacyPolicyLink(),
              const SizedBox(height: 20),
              _ConsentActions(
                onDecline: () => Navigator.of(context).pop(false),
                onAccept: () async {
                  await Utils.setAiConsentAccepted(true);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentHeader extends StatelessWidget {
  const _ConsentHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEAFBFC), Color(0xFFD4F4F7)],
            ),
          ),
          child: const Icon(
            Icons.chat_rounded,
            color: Const.aqua,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'AI Chat Assistant',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF263257),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ConsentDescription extends StatelessWidget {
  const _ConsentDescription();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'To provide health insights, this feature utilizes a third-party '
      'AI service provider. By continuing, you acknowledge the following:',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFF6B7280),
        height: 1.625,
      ),
    );
  }
}

/// A card that displays a consent information section.
class _ConsentInfoCard extends StatelessWidget {
  const _ConsentInfoCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.description,
    this.boldSegment,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String description;

  /// If provided, this substring within [description] will be rendered bold.
  final String? boldSegment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263257),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                _buildDescription(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    const baseStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF8A8A8A),
      height: 1.625,
    );

    const boldStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFF263257),
      height: 1.625,
    );

    if (boldSegment == null || !description.contains(boldSegment!)) {
      return Text(description, style: baseStyle);
    }

    final parts = description.split(boldSegment!);
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: parts[0]),
          TextSpan(text: boldSegment, style: boldStyle),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}

class _PrivacyPolicyLink extends StatelessWidget {
  const _PrivacyPolicyLink();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9CA3AF),
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'Full details are available in our '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              color: Const.aqua,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse(Const.PRIVACY_POLICY_URL));
              },
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class _ConsentActions extends StatelessWidget {
  const _ConsentActions({
    required this.onDecline,
    required this.onAccept,
  });

  final VoidCallback onDecline;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Decline',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: const Color(0x4D35C5CF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Accept & Continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
