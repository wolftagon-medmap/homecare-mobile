import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_avatar.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_stats.dart';
import 'package:m2health/features/pricing/presentation/widgets/starting_from_price.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// The full detail page fetches by id, so it is only reachable when the list
/// itself came from the server. On fixtures those ids resolve to nothing, so
/// the sheet renders what the list already loaded.
Future<void> showProfessionalProfile(
  BuildContext context, {
  required BookingProfessional professional,
  required String category,
  required VoidCallback onSelect,
}) {
  if (AppFlags.remote(Feature.bookingProfessionals)) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => BlocProvider(
          create: (_) => ProfessionalDetailCubit(getProfessionalDetail: sl()),
          child: ProfessionalDetailsPage(
            professionalId: professional.id,
            role: professional.jobTitle ?? category,
            onButtonPressed: () {
              onSelect();
              Navigator.of(routeContext).pop();
            },
          ),
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => ProfessionalProfileSheet(
      professional: professional,
      category: category,
      onSelect: () {
        onSelect();
        Navigator.of(sheetContext).pop();
      },
    ),
  );
}

class ProfessionalProfileSheet extends StatelessWidget {
  const ProfessionalProfileSheet({
    super.key,
    required this.professional,
    required this.category,
    required this.onSelect,
  });

  final BookingProfessional professional;
  final String category;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Const.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfessionalAvatar(professional: professional, radius: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professional.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (professional.jobTitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          professional.jobTitle!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      ProfessionalStats(professional: professional),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            ProfessionalFromPrice(
              professionalId: professional.id,
              category: category,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: Const.aqua,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  t.select_cta,
                  style: const TextStyle(
                    fontSize: 15,
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
