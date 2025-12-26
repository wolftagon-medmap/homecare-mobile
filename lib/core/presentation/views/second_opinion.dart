import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/core/presentation/views/teleradiology.dart';

class OpinionMedical extends StatefulWidget {
  const OpinionMedical({super.key});

  @override
  State<OpinionMedical> createState() => _OpinionMedicalState();
}

class _OpinionMedicalState extends State<OpinionMedical> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummyTenders = [
      {
        'title': context.l10n.second_opinion_teleradiology_title,
        'description': context.l10n.second_opinion_teleradiology_desc,
        'imagePath': 'assets/images/ilu_teleradiology.png',
        'color': '9AE1FF',
        'opacity': '0.33',
      },
      {
        'title': context.l10n.second_opinion_telepathology_title,
        'description': context.l10n.second_opinion_telepathology_desc,
        'imagePath': 'assets/images/ilu_telepathology.png',
        'color': 'B28CFF',
        'opacity': '0.2',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.second_opinion_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: dummyTenders.length,
                itemBuilder: (context, index) {
                  final tender = dummyTenders[index];
                  return PharmaCard(
                    pharma: tender,
                    onTap: () {
                      String route;
                      switch (index) {
                        case 0:
                          // navbarVisibility(true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeleradiologyDetail(),
                            ),
                          ).then((_) {
                            // Show the bottom navigation bar when returning
                            // navbarVisibility(false);
                          });
                          return;
                        case 1:
                          // navbarVisibility(true);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MedicalStorePage(),
                          //   ),
                          // ).then((_) {
                          //   // Show the bottom navigation bar when returning
                          //   // navbarVisibility(false);
                          // });
                          return;
                        case 2:
                          route = AppRoutes.home;
                          break;
                        case 3:
                          route = AppRoutes.home;
                          break;
                        default:
                          route = AppRoutes.home;
                      }
                      Navigator.pushNamed(context, route);
                    },
                    color: Color(int.parse('0xFF${tender['color']}'))
                        .withOpacity(tender['opacity'] != null
                            ? double.parse(tender['opacity']!)
                            : 1.0),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PharmaCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const PharmaCard(
      {super.key,
      required this.pharma,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 357,
        height: 280,
        padding: const EdgeInsets.all(16.0),
        color:
            color.withOpacity(0.1), // Set the background color with 10% opacity
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pharma['title']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${pharma['description']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400, // Light font weight
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        context.l10n.common_book_now,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
            Positioned(
              bottom: -25,
              right: -20,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0), // Adjust the padding as needed
                  child: Image.asset(
                    pharma['imagePath']!,
                    width: 185,
                    height: 139,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
