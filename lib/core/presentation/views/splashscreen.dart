import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:m2health/const.dart'; // Import constants
import 'package:m2health/core/presentation/widgets/buttons/button_size.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/route/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/icon_heart.png', // Ganti dengan path ikon kustom Anda
              width: 30, // Sesuaikan ukuran ikon
              height: 30, // Sesuaikan ukuran ikon
            ),
            const SizedBox(width: 10),
            const Text(
              'M2Health Care',
              style: TextStyle(fontWeight: FontWeight.w700, color: Const.aqua),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Simplify Homecare Bookings with Expert Healthcare Specialists at Your Fingertips!',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color(0xFF263257),
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/illustration/splash.png', // Ganti dengan path ilustrasi Anda
                width: 380,
                height: 380,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 128,
        child: Column(
          children: [
            PrimaryButton(
              text: 'Get Started',
              size: ButtonSize.large,
              onPressed: () {
                context.pushNamed(AppRoutes.medicalDisclaimer);
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Handle tap
              },
              child: const Text(
                'Powered by MedMap',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
