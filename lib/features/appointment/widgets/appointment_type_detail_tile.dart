import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_chief_complaint_page.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/pharmacy_chief_complaint_page.dart';
import 'package:m2health/features/home_health_screening/presentation/pages/home_screening_appointment_detail_page.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/pages/second_opinion_request_detail_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/nutrition_appointment_overview_page.dart';
import 'package:m2health/features/smoking_cessation/presentation/pages/smoking_cessation_appointment_detail_page.dart';
import 'package:m2health/route/app_routes.dart';

/// Renders a styled navigation card for appointment-type-specific content.
/// Returns [SizedBox.shrink] for types whose detail stays inline (homecare,
/// physiotherapy, nutrition).
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

    final config = switch (detail) {
      NursingDetail() => _TileConfig(
          label: 'Chief Complaint',
          subtitle: 'Personal issues reported by the patient',
          icon: Icons.healing_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF35C5CF), Color(0xFF00B0A7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          page: NursingChiefComplaintPage(appointment: appointment),
          usesGoRouter: false,
        ),
      PharmacyGeneralDetail() => _TileConfig(
          label: 'Chief Complaint',
          subtitle: 'Personal issues reported by the patient',
          icon: Icons.local_pharmacy_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF35C5CF), Color(0xFF00B0A7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          page: PharmacyChiefComplaintPage(appointment: appointment),
          usesGoRouter: false,
        ),
      PharmacySmokingCessationDetail() => _TileConfig(
          label: 'Smoking Cessation Details',
          subtitle: 'Intake assessment & care plan',
          icon: Icons.smoking_rooms_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF4894FE), Color(0xFF35C5CF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          page: SmokingCessationAppointmentDetailPage(
            appointment: appointment,
            isProvider: isProvider,
          ),
          usesGoRouter: false,
        ),
      ScreeningDetail() => _TileConfig(
          label: 'Lab Tests & Reports',
          subtitle: 'Workflow status and diagnostic reports',
          icon: Icons.biotech_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF9DCEFF), Color(0xFF4894FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          page: HomeScreeningAppointmentDetailPage(
            appointment: appointment,
            isProvider: isProvider,
          ),
          usesGoRouter: false,
        ),
      SecondOpinionDetail() => const _TileConfig(
          label: 'Request Detail',
          subtitle: 'Images, disease info & medical opinion',
          icon: Icons.document_scanner_rounded,
          gradient: LinearGradient(
            colors: [Color(0xFF9354B9), Color(0xFF4894FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          page: null,
          usesGoRouter: true,
        ),
      NutritionDetail() => _TileConfig(
          label: 'Nutrition Overview',
          subtitle: 'Assessment & nutrition plan',
          icon: Icons.restaurant_menu_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF56AB2F), Const.aqua],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          page: NutritionAppointmentOverviewPage(
            appointment: appointment,
            isProvider: isProvider,
          ),
          usesGoRouter: false,
        ),
      HomecareDetail() || PhysiotherapyDetail() => null,
    };

    if (config == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _DetailCard(
        config: config,
        onTap: () async {
          bool? needsRefresh;
          if (config.usesGoRouter) {
            needsRefresh = await GoRouter.of(context).pushNamed<bool>(
              AppRoutes.secondOpinionRequestDetail,
              extra: SecondOpinionRequestDetailPageParams(
                appointment: appointment,
                isProvider: isProvider,
              ),
            );
          } else {
            needsRefresh = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => config.page!),
            );
          }
          if (needsRefresh == true) onRefreshNeeded?.call();
        },
      ),
    );
  }
}

// ─── Internal data class ──────────────────────────────────────────────────────

class _TileConfig {
  final String label;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final Widget? page;
  final bool usesGoRouter;

  const _TileConfig({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.page,
    required this.usesGoRouter,
  });
}

// ─── Card Widget ──────────────────────────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  final _TileConfig config;
  final VoidCallback onTap;

  const _DetailCard({required this.config, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Gradient icon badge
              Container(
                width: 64,
                height: 72,
                decoration: BoxDecoration(
                  gradient: config.gradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Icon(config.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              // Text content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        config.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A7282),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Arrow indicator
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Const.aqua.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Const.aqua,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
