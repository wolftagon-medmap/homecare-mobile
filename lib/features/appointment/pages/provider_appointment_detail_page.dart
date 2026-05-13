import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_detail_cubit.dart';
import 'package:m2health/features/appointment/widgets/appointment_type_detail_tile.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/features/home_health_screening/presentation/widgets/screening_appointment_detail_action_buttons.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/prepare_smoking_cessation_plan_button.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

class ProviderAppointmentDetailPage extends StatelessWidget {
  final int appointmentId;
  const ProviderAppointmentDetailPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderAppointmentDetailCubit(sl())
        ..fetchProviderAppointmentById(appointmentId),
      child: const ProviderAppointmentDetailView(),
    );
  }
}

class ProviderAppointmentDetailView extends StatelessWidget {
  const ProviderAppointmentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appointment_detail_title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: BlocBuilder<ProviderAppointmentDetailCubit,
          ProviderAppointmentDetailState>(
        builder: (context, state) {
          if (state is ProviderAppointmentDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProviderAppointmentDetailError) {
            return Center(
                child: Text(context.l10n.common_error(state.message)));
          }
          if (state is ProviderAppointmentDetailLoaded) {
            return _buildAppointmentDetails(context, state.appointment);
          }
          return Center(child: Text(context.l10n.common_no_data));
        },
      ),
      bottomNavigationBar: BlocBuilder<ProviderAppointmentDetailCubit,
          ProviderAppointmentDetailState>(
        builder: (context, state) {
          if (state is! ProviderAppointmentDetailLoaded) {
            return const SizedBox.shrink();
          }

          final appointment = state.appointment;
          void refreshPage() {
            context
                .read<ProviderAppointmentDetailCubit>()
                .fetchProviderAppointmentById(appointment.id!);
          }

          return switch (appointment.type) {
            'screening' => ScreeningAppointmentDetailActionButtons(
                appointment: appointment,
                refreshCallback: refreshPage,
              ),
            _ => _ActionButtons(
                appointment: appointment,
                refreshCallback: refreshPage,
              ),
          };
        },
      ),
    );
  }

  Widget _buildAppointmentDetails(
      BuildContext context, AppointmentEntity appointment) {
    void refresh() => context
        .read<ProviderAppointmentDetailCubit>()
        .fetchProviderAppointmentById(appointment.id!);

    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _PatientCardHeader(appointment: appointment),
          const SizedBox(height: 24),
          _AppointmentSchedule(appointment: appointment),
          if (appointment.status.toLowerCase() == 'cancelled') ...[
            const SizedBox(height: 24),
            _CancellationInfoCard(appointment: appointment),
          ],
          const SizedBox(height: 24),
          _PatientInfoTable(appointment: appointment),
          const SizedBox(height: 24),
          _RequestedServicesSection(detail: appointment.serviceRequest?.detail),
          AppointmentTypeDetailTile(
            appointment: appointment,
            isProvider: true,
            onRefreshNeeded: refresh,
          ),
        ],
      ),
    );
  }
}

// ─── Requested Services (inline service name list) ────────────────────────────

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
      HomecareDetail(:final services) => services,
      PhysiotherapyDetail(:final service) => [service.name],
      ScreeningDetail(:final services) => services.map((s) => s.name).toList(),
      SecondOpinionDetail() => <String>[],
      NutritionDetail() => <String>[],
      null => <String>[],
    };

    if (names.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.appointment_detail_service_requested,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...names.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('${e.key + 1}. ${e.value}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
            )),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Patient card + schedule ──────────────────────────────────────────────────

class _AppointmentSchedule extends StatelessWidget {
  final AppointmentEntity appointment;
  const _AppointmentSchedule({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final localStartTime = appointment.startDatetime.toLocal();
    final localEndTime = appointment.endDatetime!.toLocal();
    final date = DateFormat('EEEE, MMMM dd, yyyy').format(localStartTime);
    final startHour = DateFormat('hh:mm a').format(localStartTime);
    final endHour = DateFormat('hh:mm a').format(localEndTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.appointment_detail_schedule_title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _InfoRow(icon: Icons.calendar_today_outlined, text: date),
        _InfoRow(
            icon: Icons.access_time_outlined, text: '$startHour - $endHour'),
      ],
    );
  }
}

class _PatientCardHeader extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PatientCardHeader({required this.appointment});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'accepted':
        return const Color(0xFF18B23C);
      case 'pending':
        return const Color(0xFFE59500);
      case 'cancelled':
        return const Color(0xFFED3443);
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'waiting_for_payment':
        return 'Waiting for Payment';
      case 'upcoming':
        return context.l10n.appointment_status_upcoming;
      case 'pending':
        return context.l10n.appointment_status_pending;
      case 'waiting_approval':
        return context.l10n.appointment_status_waiting_approval;
      case 'completed':
        return context.l10n.appointment_status_completed;
      case 'cancelled':
        return context.l10n.appointment_status_cancelled;
      case 'missed':
        return context.l10n.appointment_status_missed;
      default:
        return status.toTitleCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);
    final patient = appointment.patientProfile!;
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          backgroundImage:
              patient.avatar != null ? NetworkImage(patient.avatar!) : null,
          child: patient.avatar == null
              ? const Icon(Icons.person, size: 30, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getLocalizedStatus(context, appointment.status),
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      patient.homeAddress ?? 'Unknown Location',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _PatientInfoTable extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PatientInfoTable({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final patient = appointment.patientProfile!;
    final gender = patient.gender != null
        ? patient.gender!.toTitleCase()
        : context.l10n.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.appointment_detail_patient_title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(context.l10n.full_name, patient.name),
        _buildInfoRow(context.l10n.age, patient.age.toString()),
        _buildInfoRow(context.l10n.gender, gender),
        _buildInfoRow(context.l10n.weight, '${patient.weight} kg'),
        _buildInfoRow(context.l10n.height, '${patient.height} cm'),
        _buildInfoRow(context.l10n.address, patient.homeAddress),
        if (patient.address != null) _buildAddressMap(patient.address!),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 90,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  Widget _buildAddressMap(Address address) {
    return Container(
      height: 150,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(address.latitude, address.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('patient_home_address'),
            position: LatLng(address.latitude, address.longitude),
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
          Text('Cancelled by: ${_formatCancelledBy(appointment.cancelledBy)}'),
          const SizedBox(height: 4),
          Text('Reason: ${appointment.cancellationReason ?? '-'}'),
        ],
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback refreshCallback;
  const _ActionButtons({
    required this.appointment,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderAppointmentCubit, ProviderAppointmentState>(
      listener: (context, listState) {
        if (listState is ProviderAppointmentChangeSucceed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(listState.message ?? 'Appointment updated successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ));
          refreshCallback();
        } else if (listState is ProviderAppointmentError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(listState.message)),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ));
        }
      },
      child: Builder(builder: (context) {
        final status = appointment.status.toLowerCase();
        final appointmentId = appointment.id!;

        if (status == 'pending') {
          return _buildForPendingStatus(context, appointmentId);
        } else if (status == 'accepted' || status == 'upcoming') {
          return _buildForUpcomingStatus(context, appointmentId);
        } else if (status == 'completed') {
          return _buildForCompletedStatus(context, appointmentId);
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildForPendingStatus(BuildContext context, int appointmentId) {
    return BottomAppBar(
      height: 148,
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Const.aqua),
              foregroundColor: Const.aqua,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            child: Text(context.l10n.appointment_arrange_video_consultation),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      showDeclineAppointmentDialog(context, appointmentId),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Color(0xFFED3443)),
                    foregroundColor: const Color(0xFFED3443),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  child: Text(context.l10n.appointment_decline_btn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9DCEFF), Color(0xFF35C5CF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        showAcceptAppointmentDialog(context, appointment.id!),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    child: Text(context.l10n.appointment_accept_btn),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForUpcomingStatus(BuildContext context, int appointmentId) {
    return BottomAppBar(
      child: ElevatedButton(
        onPressed: () =>
            showCompleteAppointmentDialog(context, appointment.id!),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        child: Text(context.l10n.appointment_mark_complete_btn),
      ),
    );
  }

  Widget _buildForCompletedStatus(BuildContext context, int appointmentId) {
    if (appointment.serviceRequest?.detail is PharmacySmokingCessationDetail) {
      return BottomAppBar(
        child: PrepareSmokingCessationPlanButton(appointment: appointment),
      );
    }
    return const SizedBox.shrink();
  }
}
