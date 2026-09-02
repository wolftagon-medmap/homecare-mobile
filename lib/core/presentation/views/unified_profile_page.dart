import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/features/profiles/presentation/pages/admin_profile_page.dart';
import 'package:m2health/features/profiles/presentation/pages/patient_profile_page.dart';
import 'package:m2health/features/professional_profile/presentation/pages/professional_profile_page.dart';
import 'package:m2health/utils.dart';

// Thin entry widget that resolves the logged-in role once and hands off to
// the matching role-specific page. Mirrors UnifiedAppointmentPage's pattern.
class UnifiedProfilePage extends StatefulWidget {
  const UnifiedProfilePage({super.key});

  @override
  State<UnifiedProfilePage> createState() => _UnifiedProfilePageState();
}

class _UnifiedProfilePageState extends State<UnifiedProfilePage> {
  late Future<Widget> _profileWidgetFuture;

  @override
  void initState() {
    super.initState();
    _profileWidgetFuture = _loadProfileWidget();
  }

  Future<Widget> _loadProfileWidget() async {
    final role = await Utils.getSpString(Const.ROLE);

    if (role == 'admin') {
      return const AdminProfilePage();
    }
    if (role != null && PROFESSIONAL_ROLES.map((r) => r.value).contains(role)) {
      return const ProfessionalProfilePage();
    }
    return const PatientProfilePage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _profileWidgetFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _profileWidgetFuture = _loadProfileWidget();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Scaffold(
            body: Center(child: Text('No profile data available')),
          );
        }
      },
    );
  }
}
