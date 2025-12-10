import 'package:flutter/material.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/house_cleaning_page.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/kitchen_bathroom_repair_page.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/living_security_page.dart';

class HomecareElderlyServicePage extends StatelessWidget {
  const HomecareElderlyServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.translate('homecare_for_elderly'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuCard(
                title: "House & Bedding Cleaning",
                description:
                    "Regular cleaning services to maintain a hygienic, comfortable, and safe living environment for the elderly.",
                imagePath: 'assets/illustration/house_n_bedding_cleaning.png',
                backgroundColor: const Color.fromRGBO(247, 158, 27, 0.1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HouseCleaningPage(),
                    ),
                  );
                },
              ),
              MenuCard(
                title: "Living Security & Safety",
                description:
                    "Safety checks and organization to reduce risks and create a secure living environment.",
                imagePath: 'assets/illustration/living_security_n_safety.png',
                backgroundColor: const Color.fromRGBO(178, 140, 255, 0.2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LivingSecurityPage(),
                    ),
                  );
                },
              ),
              MenuCard(
                title: "Kitchen & Bathroom Repair",
                description:
                    "On-demand minor repairs to maintain functionality and safety in key home areas.",
                imagePath: 'assets/illustration/kitchen_n_bathroom_repair.png',
                backgroundColor: const Color.fromRGBO(154, 225, 255, 0.33),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KitchenBathroomRepairPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 240),
        padding: const EdgeInsets.all(20.0),
        color: backgroundColor,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -16,
              right: -20,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  imagePath,
                  width: 160,
                  height: 120,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300, // Light font weight
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Book Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF35C5CF),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          'assets/icons/ic_play.png',
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
