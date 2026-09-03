import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The card only presents a professional. Choosing one happens by continuing
/// from their profile, so there is no selected state here.
class ProfessionalCard extends StatelessWidget {
  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.category,
    required this.onOpenProfile,
  });

  final BookingProfessional professional;
  final String category;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;
    final price =
        PriceTableCubit.of(context).professionalFrom(professional.id, category);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onOpenProfile,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Const.borderSubtle),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(professional: professional),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: Const.primaryTextColor,
                      ),
                    ),
                    if (professional.jobTitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        professional.jobTitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Const.contentTextColor,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    _RatingRow(professional: professional),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (price != null)
                          Expanded(
                            child: Text(
                              '\$${price.toStringAsFixed(0)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Const.primaryTextColor,
                              ),
                            ),
                          )
                        else
                          const Spacer(),
                        _ViewProfileButton(
                          label: t.view_profile,
                          onPressed: onOpenProfile,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.professional});

  final BookingProfessional professional;

  @override
  Widget build(BuildContext context) {
    final avatar = professional.avatar;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        width: 92,
        height: 92,
        child: avatar == null
            ? ColoredBox(
                color: Const.aqua.withValues(alpha: 0.15),
                child: Center(
                  child: Text(
                    _initials(professional.name),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Const.tosca,
                    ),
                  ),
                ),
              )
            : Image.network(
                avatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => ColoredBox(
                  color: Const.aqua.withValues(alpha: 0.15),
                  child: Center(
                    child: Text(
                      _initials(professional.name),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Const.tosca,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(1).toString();
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}';
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.professional});

  final BookingProfessional professional;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;
    const muted = TextStyle(fontSize: 14, color: Const.contentTextColor);

    return Row(
      children: [
        const Icon(Icons.star_half_rounded, size: 20, color: Color(0xFF8FDCA8)),
        const SizedBox(width: 5),
        Text(
          professional.rating.toStringAsFixed(1),
          style: muted,
        ),
        const SizedBox(width: 8),
        const Text('|', style: TextStyle(fontSize: 14, color: Colors.black26)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            t.years(years: professional.yearsOfExperience),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: muted,
          ),
        ),
      ],
    );
  }
}

class _ViewProfileButton extends StatelessWidget {
  const _ViewProfileButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF2F4F7),
        foregroundColor: Const.primaryTextColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
