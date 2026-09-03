import 'package:flutter/material.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/i18n/translations.g.dart';

class ProfessionalStats extends StatelessWidget {
  const ProfessionalStats({
    super.key,
    required this.professional,
    this.showExperience = true,
  });

  final BookingProfessional professional;
  final bool showExperience;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;
    const muted = TextStyle(fontSize: 12, color: Colors.black45);

    return Row(
      children: [
        const Icon(Icons.star, size: 14, color: Colors.amber),
        const SizedBox(width: 3),
        Text(
          professional.rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 2),
        Text(t.reviews(count: professional.reviewCount), style: muted),
        if (showExperience) ...[
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              t.years(years: professional.yearsOfExperience),
              overflow: TextOverflow.ellipsis,
              style: muted,
            ),
          ),
        ],
      ],
    );
  }
}
