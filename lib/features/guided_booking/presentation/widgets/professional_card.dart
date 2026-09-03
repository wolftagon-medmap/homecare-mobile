import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_avatar.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_profile_view.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_stats.dart';
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
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
        decoration: BoxDecoration(
          color: selected ? Const.tosca.withValues(alpha: 0.06) : Colors.white,
          border: Border.all(
            color: selected ? Const.tosca : const Color(0xFFE0E0E0),
            width: selected ? 1.6 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfessionalAvatar(professional: professional),
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
                      ProfessionalStats(professional: professional),
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
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => showProfessionalProfile(
                  context,
                  professional: professional,
                  category: category,
                  onSelect: onTap,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Const.tosca,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  t.view_profile,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
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
