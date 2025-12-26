import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/musculoskeletal_physiotherapy_page.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/neurological_physiotherapy_page.dart';

class PhysiotherapyPage extends StatelessWidget {
  const PhysiotherapyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.physiotherapy_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                MenuCard(
                  title: context.l10n.physiotherapy_musculoskeletal_title,
                  description: context.l10n.physiotherapy_musculoskeletal_desc,
                  imagePath:
                      'assets/illustration/physiotherapy_musculoskeletal.png',
                  backgroundColor: const Color.fromRGBO(247, 158, 27, 0.1),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const MusculoskeletalPhysiotherapyPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  title: context.l10n.physiotherapy_neurological_title,
                  description: context.l10n.physiotherapy_neurological_desc,
                  imagePath:
                      'assets/illustration/physiotherapy_neurological.png',
                  backgroundColor: const Color.fromRGBO(178, 140, 255, 0.2),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const NeurologicalPhysiotherapyPage(),
                      ),
                    );
                  },
                ),
              ],
            )),
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
                        Text(
                          context.l10n.common_book_now,
                          style: const TextStyle(
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
