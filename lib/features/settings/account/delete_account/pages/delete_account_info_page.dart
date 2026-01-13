import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import 'package:m2health/route/app_routes.dart';

class DeleteAccountInfoPage extends StatelessWidget {
  const DeleteAccountInfoPage({super.key});

  static const List<String> deletionConsequences = [
    'Permanently delete all your information, including personal data, appointment history, medical records, lab test results, payment information and other data without the ability to recover them in the future',
    'Cancel all active subscriptions or appointments',
    'Stop receiving all promotional messages, and marketing communications permanently',
    'Immediately logged out and lose access to the platform',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete My Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Const.aqua,
                ),
              ),
              const Text(
                'Step 1 of 3',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              const Text(
                'If you delete your account, you will:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              for (var consequence in deletionConsequences)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Const.aqua,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(consequence),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color(0xFFF8F9FF),
                ),
                child: const Text(
                  "By clicking the button below, you agree with our data management according to our Privacy Policy and Terms of Use. Subject to applicable law, certain data may be retained in accordance with our retention policies.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 36.0),
        child: PrimaryButton(
          text: 'Continue',
          onPressed: () {
            context.pushNamed(AppRoutes.deleteAccountReason);
          },
        ),
      ),
    );
  }
}
