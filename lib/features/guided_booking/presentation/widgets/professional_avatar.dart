import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';

class ProfessionalAvatar extends StatelessWidget {
  const ProfessionalAvatar({
    super.key,
    required this.professional,
    this.radius = 26,
  });

  final BookingProfessional professional;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final avatar = professional.avatar;

    return CircleAvatar(
      radius: radius,
      backgroundColor: Const.aqua.withValues(alpha: 0.15),
      backgroundImage: avatar == null ? null : NetworkImage(avatar),
      child: avatar != null
          ? null
          : Text(
              _initials(professional.name),
              style: TextStyle(
                fontSize: radius * 0.62,
                fontWeight: FontWeight.w700,
                color: Const.tosca,
              ),
            ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.take(1).toString();
    return '${parts.first.characters.take(1)}${parts.last.characters.take(1)}';
  }
}
