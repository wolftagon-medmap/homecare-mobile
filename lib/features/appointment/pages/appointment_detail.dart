import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/order_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/appointment_detail_cubit.dart';
import 'package:m2health/features/appointment/widgets/appointment_type_detail_tile.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/core/presentation/widgets/buttons/gradient_button.dart';

class DetailAppointmentPage extends StatefulWidget {
  final int appointmentId;

  const DetailAppointmentPage({super.key, required this.appointmentId});

  @override
  State<DetailAppointmentPage> createState() => _DetailAppointmentPageState();
}

class _DetailAppointmentPageState extends State<DetailAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentDetailCubit(sl<AppointmentService>())
        ..fetchAppointmentDetail(widget.appointmentId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.appointment_detail_title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<AppointmentDetailCubit, AppointmentDetailState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AppointmentDetailLoading ||
                state is AppointmentDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is AppointmentDetailLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<AppointmentDetailCubit>()
                      .fetchAppointmentDetail(widget.appointmentId);
                },
                child: _buildContent(context, state.appointment),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
        bottomNavigationBar:
            BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
          builder: (context, state) {
            if (state is AppointmentDetailLoaded) {
              return _buildActionButtons(context, state.appointment);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppointmentEntity appointment) {
    void refresh() => context
        .read<AppointmentDetailCubit>()
        .fetchAppointmentDetail(appointment.id!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProviderCard(
              provider: appointment.provider!, status: appointment.status),
          const SizedBox(height: 16),
          _ScheduleCard(appointment: appointment),
          if (appointment.status.toLowerCase() == 'cancelled') ...[
            const SizedBox(height: 16),
            _CancellationInfoCard(appointment: appointment),
          ],
          const SizedBox(height: 16),
          _PatientInfoSection(profile: appointment.patientProfile!),
          const SizedBox(height: 16),
          _RequestedServicesSection(detail: appointment.serviceRequest?.detail),
          _HomecareTasksSection(appointment: appointment),
          _PhysiotherapySection(appointment: appointment),
          AppointmentTypeDetailTile(
            appointment: appointment,
            isProvider: false,
            onRefreshNeeded: refresh,
          ),
          const SizedBox(height: 16),
          _PaymentSummarySection(appointment: appointment),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, AppointmentEntity appointment) {
    final status = appointment.status.toLowerCase();
    bool isHorizontalLayout = true;

    Widget payButton = ElevatedButton(
      onPressed: () {
        GoRouter.of(context).pushNamed(AppRoutes.payment, extra: appointment);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF35C5CF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        context.l10n.appointment_pay_btn,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    Widget cancelButton = ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CancelAppoinmentDialog(
              onPressYes: (selection) {
                context.read<AppointmentCubit>().cancelAppointment(
                      appointment.id!,
                      cancellationReason: selection.cancellationReason,
                      otherReason: selection.otherReason,
                    );
                context.pop();
              },
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        context.l10n.appointment_cancel_booking_btn,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );

    Widget rescheduleButton = GradientButton(
      text: context.l10n.appointment_reschedule_btn,
      gradient: const LinearGradient(
        colors: [Color(0xFF35C5CF), Color(0xFF9DCEFF)],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ),
      onPressed: () async {
        await GoRouter.of(context).pushNamed(
          AppRoutes.scheduleAppoointment,
          extra: ScheduleAppointmentPageData(
            professional: appointment.provider!,
            currentAppointment: appointment,
          ),
        );
        context
            .read<AppointmentDetailCubit>()
            .fetchAppointmentDetail(appointment.id!);
      },
    );

    Widget bookAgainButton = GradientButton(
      text: context.l10n.appointment_book_again_btn,
      onPressed: () {},
    );

    Widget rateButton = OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Const.tosca),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        context.l10n.appointment_rating_btn,
        style: const TextStyle(color: Const.tosca, fontWeight: FontWeight.bold),
      ),
    );

    List<Widget> buttons;
    switch (status) {
      case 'waiting_for_payment':
        buttons = [cancelButton, payButton];
        break;
      case 'pending':
        if (!(appointment.order?.isPaid ?? false)) {
          buttons = [payButton, cancelButton];
          isHorizontalLayout = false;
        } else {
          buttons = [cancelButton, rescheduleButton];
        }
        break;
      case 'upcoming':
        buttons = [cancelButton, rescheduleButton];
        break;
      case 'completed':
        buttons = [rateButton, bookAgainButton];
        break;
      case 'cancelled':
        buttons = [bookAgainButton];
        break;
      default:
        buttons = [];
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return BottomAppBar(
      color: Colors.white,
      height: isHorizontalLayout ? 80 : 132,
      child: isHorizontalLayout
          ? Row(
              spacing: 16,
              children:
                  buttons.map((button) => Expanded(child: button)).toList(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: buttons,
            ),
    );
  }
}

// ─── Card Widgets ─────────────────────────────────────────────────────────────

class _ProviderCard extends StatelessWidget {
  final ProfessionalEntity provider;
  final String status;

  const _ProviderCard({required this.provider, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                provider.avatar != null ? NetworkImage(provider.avatar!) : null,
            child: provider.avatar == null
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(provider.jobTitle ?? provider.role),
                const SizedBox(height: 8),
                _StatusTag(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final AppointmentEntity appointment;
  const _ScheduleCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, AppLocale>(
      builder: (context, locale) {
        final localStartTime = appointment.startDatetime.toLocal();
        final localEndTime = appointment.endDatetime?.toLocal();
        final date =
            DateFormat.yMMMMEEEEd(locale.languageCode).format(localStartTime);
        final startHour =
            DateFormat.jm(locale.languageCode).format(localStartTime);
        final endHour = localEndTime != null
            ? DateFormat.jm(locale.languageCode).format(localEndTime)
            : null;
        final hour = endHour != null ? '$startHour - $endHour' : startHour;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.appointment_detail_schedule_title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              _InfoRow(icon: Icons.calendar_today, text: date),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.access_time, text: hour),
            ],
          ),
        );
      },
    );
  }
}

class _PatientInfoSection extends StatelessWidget {
  final Profile profile;
  const _PatientInfoSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final gender = profile.gender != null
        ? profile.gender!.toTitleCase()
        : 'Not specified';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_patient_title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _InfoRow(label: context.l10n.full_name, text: profile.name),
          const SizedBox(height: 12),
          _InfoRow(
              label: context.l10n.age,
              text: context.l10n.age_years_old(profile.age!)),
          const SizedBox(height: 12),
          _InfoRow(label: context.l10n.gender, text: gender),
          const SizedBox(height: 12),
          _InfoRow(
            label: context.l10n.address,
            text: profile.homeAddress ?? context.l10n.none,
            isFlexible: true,
          ),
          if (profile.address != null)
            Container(
              height: 150,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      profile.address!.latitude, profile.address!.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('patient_${profile.id}_home_address'),
                    position: LatLng(
                        profile.address!.latitude, profile.address!.longitude),
                  ),
                },
                liteModeEnabled: true,
                zoomControlsEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
              ),
            ),
        ],
      ),
    );
  }
}

class _CancellationInfoCard extends StatelessWidget {
  final AppointmentEntity appointment;
  const _CancellationInfoCard({required this.appointment});

  String _formatCancelledBy(String? cancelledBy) {
    if (cancelledBy == null || cancelledBy.isEmpty) return '-';
    switch (cancelledBy.toLowerCase()) {
      case 'patient':
        return 'Patient';
      case 'provider':
        return 'Provider';
      default:
        return cancelledBy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cancellation details',
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
          ),
          const SizedBox(height: 8),
          _InfoRow(
              label: 'Cancelled by',
              text: _formatCancelledBy(appointment.cancelledBy)),
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Reason',
            text: appointment.cancellationReason ?? '-',
            isFlexible: true,
          ),
        ],
      ),
    );
  }
}

/// Brief inline service names for nursing, pharmacy, and smoking cessation.
/// Types that navigate to sub-pages (screening, second opinion, homecare, physio)
/// are excluded — their context is provided by [AppointmentTypeDetailTile] or
/// the dedicated inline sections below.
class _RequestedServicesSection extends StatelessWidget {
  final ServiceRequestDetail? detail;
  const _RequestedServicesSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final names = switch (detail) {
      NursingDetail(:final services) => services.map((s) => s.name).toList(),
      PharmacyGeneralDetail(:final services) =>
        services.map((s) => s.name).toList(),
      PharmacySmokingCessationDetail(:final services) =>
        services.map((s) => s.name).toList(),
      _ => <String>[],
    };

    if (names.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_service_requested,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ...names.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${e.key + 1}. ${e.value}',
                    style: const TextStyle(fontSize: 14)),
              )),
        ],
      ),
    );
  }
}

class _HomecareTasksSection extends StatelessWidget {
  final AppointmentEntity appointment;
  const _HomecareTasksSection({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final detail = appointment.serviceRequest?.detail;
    if (detail is! HomecareDetail) return const SizedBox.shrink();
    final tasks = detail.services;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_requested_homecare_task,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          if (tasks.isNotEmpty)
            ...tasks.map((task) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Const.aqua, size: 20),
                      const SizedBox(width: 8),
                      Text(task),
                    ],
                  ),
                ))
          else
            Text(context.l10n.appointment_detail_requested_homecare_task_empty),
        ],
      ),
    );
  }
}

class _PhysiotherapySection extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PhysiotherapySection({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final detail = appointment.serviceRequest?.detail;
    if (detail is! PhysiotherapyDetail) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Detail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Service Name',
            text: detail.service.name,
            isFlexible: true,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Duration',
            text: '${detail.duration} Minutes',
          ),
        ],
      ),
    );
  }
}

class _PaymentSummarySection extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PaymentSummarySection({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final order = appointment.order;
    final isPaid = order?.isPaid ?? false;
    final isFullyCovered = order?.isFullyCovered ?? false;
    final lineItems = order?.lineItems ?? const <OrderLineItem>[];
    final total = order?.total ?? 0.0;

    return BlocBuilder<LocaleCubit, AppLocale>(
      builder: (context, locale) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPaid
                    ? context.l10n.appointment_detail_payment_details
                    : context.l10n.appointment_detail_estimated_budget,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              if (isFullyCovered) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text('Fully covered by subscription',
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (lineItems.isNotEmpty) ...[
                Text(
                  context.l10n.services,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...lineItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.description)),
                        const SizedBox(width: 16),
                        Text('\$${item.amount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 16),
              ],
              Row(
                children: [
                  Text(
                    context.l10n.appointment_detail_total_label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Const.aqua),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Shared small widgets ──────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? label;
  final bool isFlexible;

  const _InfoRow({
    required this.text,
    this.icon,
    this.label,
    this.isFlexible = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(text, style: const TextStyle(fontSize: 14));

    return Row(
      crossAxisAlignment:
          isFlexible ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Const.aqua, size: 20),
          const SizedBox(width: 16),
        ],
        if (label != null) ...[
          SizedBox(width: 80, child: Text(label!)),
          const SizedBox(width: 8, child: Text(':')),
          const SizedBox(width: 2),
        ],
        isFlexible ? Flexible(child: textWidget) : textWidget,
      ],
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String status;
  const _StatusTag({required this.status});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      case 'upcoming':
        return const Color(0xFFE59500);
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status, BuildContext context) {
    switch (status) {
      case 'waiting_for_payment':
        return 'Waiting for Payment';
      case 'upcoming':
        return context.l10n.appointment_status_upcoming;
      case 'pending':
        return context.l10n.appointment_status_pending;
      case 'completed':
        return context.l10n.appointment_status_completed;
      case 'cancelled':
        return context.l10n.appointment_status_cancelled;
      case 'missed':
        return context.l10n.appointment_status_missed;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getStatusLabel(status, context),
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
