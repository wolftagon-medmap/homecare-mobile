import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/pricing/presentation/widgets/starting_from_price.dart';
import 'package:m2health/i18n/translations.g.dart';

class ProfessionalCard extends StatelessWidget {
  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final BookingProfessional professional;
  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Const.tosca.withValues(alpha: 0.06) : Colors.white,
          border: Border.all(
            color: selected ? Const.tosca : const Color(0xFFE0E0E0),
            width: selected ? 1.6 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Const.aqua.withValues(alpha: 0.15),
              backgroundImage: professional.avatar == null
                  ? null
                  : NetworkImage(professional.avatar!),
              child: professional.avatar != null
                  ? null
                  : Text(
                      _initials(professional.name),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Const.tosca,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (professional.jobTitle != null)
                    Text(
                      professional.jobTitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        professional.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        t.reviews(count: professional.reviewCount),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          t.years(years: professional.yearsOfExperience),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ProfessionalFromPrice(
              professionalId: professional.id,
              category: category,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.take(1).toString();
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}';
  }
}
