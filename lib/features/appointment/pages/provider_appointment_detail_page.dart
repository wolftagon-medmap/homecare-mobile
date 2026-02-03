import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_detail_cubit.dart';
import 'package:m2health/features/appointment/pages/screening_report_submission_page.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/home_health_screening/presentation/widgets/screening_appointment_detail_action_buttons.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/prepare_smoking_cessation_plan_button.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/smoking_habit_assessment_card.dart';
import 'package:m2health/route/app_routes.dart';
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
            final appointment = state.appointment;
            return _buildAppointmentDetails(context, appointment);
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

          // Determine which action buttons to show based on appointment type
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
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<ProviderAppointmentDetailCubit>()
            .fetchProviderAppointmentById(appointment.id!);
      },
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _PatientCardHeader(appointment: appointment),
          const SizedBox(height: 24),
          _AppointmentSchedule(appointment: appointment),
          const SizedBox(height: 24),
          _PatientInfoTable(appointment: appointment),
          if (appointment.type == 'screening')
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              _buildSectionTitle(
                  context.l10n.appointment_detail_lab_test_title),
              _ScreeningRequestInfo(appointment: appointment),
            ])
          else
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              _PersonalCaseInfo(appointment: appointment),
            ]),
          if (appointment.type == 'pharmacy' &&
              appointment.pharmacyCase?.serviceType == 'smoking_cessation') ...[
            const SizedBox(height: 24),
            _buildSectionTitle("Smoking Cessation Assessment"),
            SmokingHabitAssessmentCard(
              smokingForm: appointment.pharmacyCase!.smokingCessationForm!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

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
    final hour = '$startHour - $endHour';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.appointment_detail_schedule_title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _InfoRow(icon: Icons.calendar_today_outlined, text: date),
        _InfoRow(icon: Icons.access_time_outlined, text: hour),
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
      case 'upcoming':
        return context.l10n.appointment_status_upcoming;
      case 'pending':
        return context.l10n.appointment_status_pending;
      case 'waiting_approval':
        return context.l10n.appointment_status_waiting_approval;
      case 'accepted':
        return context.l10n.appointment_status_accepted;
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
              (patient.avatar != null) ? NetworkImage(patient.avatar!) : null,
          child: (patient.avatar == null)
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
                    fontSize: 12,
                  ),
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
        )
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
        if (patient.address != null)
          _buildAddressMap(context, patient.address!),
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

  Widget _buildAddressMap(BuildContext context, Address address) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            address.latitude,
            address.longitude,
          ),
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

class _ScreeningRequestInfo extends StatelessWidget {
  final AppointmentEntity appointment;
  const _ScreeningRequestInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final screeningData = appointment.screeningRequestData;
    if (screeningData == null) {
      return Text(context.l10n.common_no_data);
    }
    final reports = screeningData.reports;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.common_status,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Const.aqua.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                screeningData.status.replaceAll('_', ' ').toTitleCase(),
                style: const TextStyle(
                  color: Const.aqua,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${context.l10n.appointment_detail_service_requested}: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...screeningData.services.asMap().entries.map(
          (entry) {
            final index = entry.key + 1;
            final service = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '$index. ${service.name}',
                style: const TextStyle(fontSize: 14),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        if (reports.isNotEmpty && screeningData.status == 'report_ready') ...[
          Text(
            context.l10n.appointment_detail_report(reports.length),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...reports.map((report) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200)),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                        report.file.extname == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.insert_drive_file,
                        color: Colors.red),
                  ),
                  title: Text(
                    'Report #${report.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(report.file.extname.toUpperCase()),
                  trailing: IconButton(
                    icon: const Icon(
                        Icons.visibility), // Changed icon to visibility
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileViewerPage(
                            url: report.file.url,
                            title: 'Lab Report #${report.id}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ))
        ]
      ],
    );
  }
}

class _PersonalCaseInfo extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PersonalCaseInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    List<String>? servicesList;
    List<PersonalIssue>? issues;

    if (appointment.type == 'nursing') {
      final personalCase = appointment.nursingCase;
      servicesList = personalCase?.addOnServices.map((e) => e.name).toList();
      issues = personalCase?.issues;
    } else if (appointment.type == 'pharmacy') {
      final personalCase = appointment.pharmacyCase;
      servicesList = personalCase?.addOnServices.map((e) => e.name).toList();
      issues = personalCase?.issues;
    } else if (appointment.type == 'homecare') {
      final personalCase = appointment.homecareRequestData;
      servicesList = personalCase?.services;
    } else if (appointment.type == 'physiotherapy') {
      final physiotherapyData = appointment.physiotherapyRequestData;
      if (physiotherapyData != null) {
        servicesList = [physiotherapyData.service.name];
      }
    }

    // sort issues by updatedAt descending
    issues?.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.appointment_detail_service_requested,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (servicesList != null && servicesList.isNotEmpty) ...[
          ...servicesList.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final name = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '$index. $name',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            );
          }),
        ] else
          const Text(
            'None',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        const SizedBox(height: 24),
        if (issues != null && issues.isNotEmpty) ...[
          Text(
            context.l10n.appointment_detail_patient_problem_title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (issues.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: issues.length,
              itemBuilder: (context, issueIndex) {
                final issue = issues![issueIndex];
                final images = issue.imageUrls;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${issueIndex + 1}. ${issue.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.common_description,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      issue.description,
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 4),
                    if (images.isNotEmpty)
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, imageIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () =>
                                    _showFullImage(context, images[imageIndex]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(images[imageIndex]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.created_on(DateFormat.yMMMd()
                              .add_jm()
                              .format(issue.createdAt!.toLocal())),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            )
        ]
      ],
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileViewerPage(
          url: imageUrl,
          title: 'Issue Image',
        ),
      ),
    );
  }
}

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
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(listState.message ?? 'Appointment updated successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          refreshCallback();
        } else if (listState is ProviderAppointmentError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(listState.message)),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Builder(builder: (context) {
        final status = appointment.status.toLowerCase();
        final appointmentId = appointment.id!;

        if (status == 'pending') {
          return _buildForPendingStatus(context, appointmentId);
        } else if (status == 'accepted') {
          return _buildForAcceptedStatus(context, appointmentId);
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
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: Text(context.l10n.appointment_arrange_video_consultation),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDeclineAppointmentDialog(context, appointmentId);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Color(0xFFED3443)),
                    foregroundColor: const Color(0xFFED3443),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: Text(context.l10n.appointment_decline_btn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9DCEFF),
                        Color(0xFF35C5CF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showAcceptAppointmentDialog(context, appointment.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    child: Text(context.l10n.appointment_accept_btn),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildForAcceptedStatus(BuildContext context, int appointmentId) {
    return BottomAppBar(
      child: ElevatedButton(
        onPressed: () async {
          showCompleteAppointmentDialog(context, appointment.id!);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: Text(context.l10n.appointment_mark_complete_btn),
      ),
    );
  }

  Widget _buildForCompletedStatus(BuildContext context, int appointmentId) {
    if (appointment.type == 'pharmacy' &&
        appointment.pharmacyCase?.serviceType == 'smoking_cessation') {
      return BottomAppBar(
        child: PrepareSmokingCessationPlanButton(appointment: appointment),
      );
    }
    return const SizedBox.shrink();
  }
}
