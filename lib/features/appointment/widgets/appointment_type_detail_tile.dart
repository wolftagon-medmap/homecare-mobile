import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_chief_complaint_page.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/pharmacy_chief_complaint_page.dart';
import 'package:m2health/features/home_health_screening/presentation/pages/home_screening_appointment_detail_page.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/pages/second_opinion_request_detail_page.dart';
import 'package:m2health/features/smoking_cessation/presentation/pages/smoking_cessation_appointment_detail_page.dart';
import 'package:m2health/route/app_routes.dart';

/// Renders a navigation tile for appointment-type-specific content.
class AppointmentTypeDetailTile extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isProvider;

  /// Called after the sub-page pops with [true], signalling that the
  /// appointment data should be refreshed in the parent.
  final VoidCallback? onRefreshNeeded;

  const AppointmentTypeDetailTile({
    super.key,
    required this.appointment,
    required this.isProvider,
    this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {
    final detail = appointment.serviceRequest?.detail;
    if (detail == null) return const SizedBox.shrink();

    final entry = switch (detail) {
      NursingDetail() => (
          'Chief Complaint',
          NursingChiefComplaintPage(appointment: appointment) as Widget,
          false, // uses Navigator.push (not GoRouter)
        ),
      PharmacyGeneralDetail() => (
          'Chief Complaint',
          PharmacyChiefComplaintPage(appointment: appointment) as Widget,
          false,
        ),
      PharmacySmokingCessationDetail() => (
          'Smoking Cessation Details',
          SmokingCessationAppointmentDetailPage(
              appointment: appointment, isProvider: isProvider) as Widget,
          false,
        ),
      ScreeningDetail() => (
          'Lab Tests & Reports',
          HomeScreeningAppointmentDetailPage(
              appointment: appointment, isProvider: isProvider) as Widget,
          false,
        ),
      SecondOpinionDetail() => (
          'Request Detail',
          null as Widget?, // handled via GoRouter named route
          true, // uses GoRouter
        ),
      HomecareDetail() || PhysiotherapyDetail() || NutritionDetail() => null,
    };

    if (entry == null) return const SizedBox.shrink();

    final (label, page, usesGoRouter) = entry;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () async {
        bool? needsRefresh;
        if (usesGoRouter) {
          needsRefresh = await GoRouter.of(context).pushNamed<bool>(
            AppRoutes.secondOpinionRequestDetail,
            extra: SecondOpinionRequestDetailPageParams(
              appointment: appointment,
              isProvider: isProvider,
            ),
          );
        } else {
          needsRefresh = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => page!),
          );
        }
        if (needsRefresh == true) onRefreshNeeded?.call();
      },
    );
  }
}
