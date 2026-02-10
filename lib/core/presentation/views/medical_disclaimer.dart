import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalDisclaimerPage extends StatelessWidget {
  const MedicalDisclaimerPage({super.key});

  Future<void> _launchTnC() async {
    final Uri url = Uri.parse(Const.TERMS_AND_CONDITIONS_URL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient at the top
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEAFBFC),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Top Icon and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Const.aqua.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.security_outlined,
                          color: Const.aqua,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Medical Safety Notice',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263257),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Disclaimer Cards
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildDisclaimerCard(
                        icon: Icons.error_outline,
                        title: 'Not a Diagnosis Tool',
                        description:
                            'This app does not provide medical advice or diagnosis.',
                      ),
                      const SizedBox(height: 16),
                      _buildDisclaimerCard(
                        icon: Icons.people_outline,
                        title: 'Connector Platform',
                        description:
                            'It is a platform to connect users with licensed healthcare providers.',
                      ),
                      const SizedBox(height: 16),
                      _buildDisclaimerCard(
                        icon: Icons.medical_services_outlined,
                        title: 'Seek Professional Help',
                        description:
                            'Please seek a doctor’s advice in addition to using this app and before making any medical decisions.',
                      ),
                    ],
                  ),
                ),
                // Footer Buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Utils.setSpBool(
                                Const.ONBOARDING_COMPLETED, true);
                            if (context.mounted) {
                              context.go(AppRoutes.dashboard);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Const.aqua,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 8,
                            shadowColor: Const.aqua.withValues(alpha: 0.3),
                          ),
                          child: const Text(
                            'I Understand & Agree',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            const TextSpan(
                                text:
                                    'By continuing, you also acknowledge our '),
                            TextSpan(
                              text: "Terms and Conditions",
                              style: const TextStyle(
                                color: Const.aqua,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _launchTnC,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF9FAFB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEFCFD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Const.aqua,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263257),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A8A),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
