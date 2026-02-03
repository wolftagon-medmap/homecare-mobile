import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/appointment_detail_cubit.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/smoking_habit_assessment_card.dart';
import 'package:m2health/features/smoking_cessation/presentation/widgets/view_smoking_cessation_plan_button.dart';
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
          listener: (context, state) {
            // You can show SnackBars here on error if needed
          },
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProviderCard(appointment.provider!, appointment.status),
          const SizedBox(height: 16),
          _buildScheduleCard(appointment),
          const SizedBox(height: 16),
          _buildPatientInfo(appointment.patientProfile!),
          const SizedBox(height: 16),
          // Conditional rendering based on appointment type
          if (appointment.type == 'screening')
            _buildScreeningInfo(appointment)
          else if (appointment.type == 'homecare')
            _buildHomecareTaskInfo(appointment)
          else if (appointment.type == 'physiotherapy')
            _buildPhysiotherapyInfo(appointment)
          else if (appointment.type == 'pharmacy' &&
              appointment.pharmacyCase?.serviceType == 'smoking_cessation')
            _buildSmokingCessationInfo(appointment)
          else
            _buildConcernInfo(appointment),
          const SizedBox(height: 16),
          _buildPaymentSummary(appointment),
        ],
      ),
    );
  }

  Widget _buildPhysiotherapyInfo(AppointmentEntity appointment) {
    final physiotherapyData = appointment.physiotherapyRequestData;
    if (physiotherapyData == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Detail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Service Name',
            text: physiotherapyData.service.name,
            isFlexible: true,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Duration',
            text: '${physiotherapyData.duration} Minutes',
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProfessionalEntity? provider, String status) {
    if (provider == null) return const SizedBox.shrink();

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
            backgroundImage: (provider.avatar != null)
                ? NetworkImage(provider.avatar!)
                : null,
            child: (provider.avatar == null)
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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

  Widget _buildScheduleCard(AppointmentEntity appointment) {
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.calendar_today,
                text: date,
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.access_time,
                text: hour,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPatientInfo(Profile profile) {
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    profile.address!.latitude,
                    profile.address!.longitude,
                  ),
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

  Widget _buildScreeningInfo(AppointmentEntity appointment) {
    final screeningData = appointment.screeningRequestData;
    if (screeningData == null) return const SizedBox.shrink();
    if (appointment.payment == null) {
      // Hardcoded check for unpaid appointments
      return const SizedBox.shrink();
    }

    final reports = screeningData.reports;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_lab_test_title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Const.aqua.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  screeningData.status.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
      ),
    );
  }

  Widget _buildHomecareTaskInfo(AppointmentEntity appointment) {
    List<String>? tasks = appointment.homecareRequestData?.services;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_requested_homecare_task,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          if (tasks != null && tasks.isNotEmpty)
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

  Widget _buildSmokingCessationInfo(AppointmentEntity appointment) {
    final smokingForm = appointment.pharmacyCase?.smokingCessationForm;
    if (smokingForm == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smoking Cessation Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          SmokingHabitAssessmentCard(smokingForm: smokingForm),
          const SizedBox(height: 8),
          ViewSmokingCessationPlanButton(appointment: appointment),
        ],
      ),
    );
  }

  Widget _buildConcernInfo(AppointmentEntity appointment) {
    List<PersonalIssue>? issues;

    if (appointment.type == 'nursing') {
      issues = appointment.nursingCase?.issues;
    } else if (appointment.type == 'pharmacy') {
      issues = appointment.pharmacyCase?.issues;
    }

    // sort issues by updatedAt descending
    issues?.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_patient_problem_title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (issues != null && issues.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues![index];
                final images = issue.imageUrls;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        issue.description,
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 8),
                      if (images.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, imageIndex) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () => _showFullImage(
                                      context, images[imageIndex]),
                                  child: Image.network(
                                    images[imageIndex],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          BlocBuilder<LocaleCubit, AppLocale>(
                            builder: (context, locale) {
                              return Text(
                                context.l10n.created_on(DateFormat.yMMMd(
                                        locale.flutterLocale.languageCode)
                                    .add_jm()
                                    .format(issue.createdAt!.toLocal())),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            )
          else
            Text(context.l10n.appointment_detail_patient_problem_empty),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(AppointmentEntity appointment) {
    List<ServiceEntity> services = [];
    if (appointment.type == 'nursing') {
      final nursingCase = appointment.nursingCase;
      if (nursingCase != null && nursingCase.addOnServices.isNotEmpty) {
        services = nursingCase.addOnServices;
      }
    } else if (appointment.type == 'pharmacy') {
      final pharmacyCase = appointment.pharmacyCase;
      if (pharmacyCase != null && pharmacyCase.addOnServices.isNotEmpty) {
        services = pharmacyCase.addOnServices;
      }
    } else if (appointment.type == 'screening') {
      final screeningRequest = appointment.screeningRequestData;
      if (screeningRequest != null && screeningRequest.services.isNotEmpty) {
        services = screeningRequest.services;
      }
    } else if (appointment.type == 'physiotherapy') {
      final physiotherapyData = appointment.physiotherapyRequestData;
      if (physiotherapyData != null) {
        services = [physiotherapyData.service];
      }
    }

    final total = appointment.payTotal;
    final isPaid = appointment.payment != null;

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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              if (appointment.payment != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(context.l10n.appointment_detail_payment_date),
                    const Spacer(),
                    Text(DateFormat.yMMMd(locale.languageCode)
                        .add_jm()
                        .format(appointment.payment!.createdAt.toLocal())),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(context.l10n.appointment_detail_payment_method),
                    const Spacer(),
                    Text(appointment.payment!.method),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(context.l10n.appointment_detail_order_completed_date),
                    const Spacer(),
                    Text(DateFormat.yMMMd(locale.languageCode)
                        .add_jm()
                        .format(appointment.payment!.updatedAt.toLocal())),
                  ],
                ),
                const Divider(height: 20),
              ],
              if (services.isNotEmpty) ...[
                Text(
                  context.l10n.services,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...services.map(
                  (addOn) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(addOn.name)),
                        const SizedBox(width: 16),
                        Text('${addOn.price}'),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$$total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Const.aqua,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        context.l10n.appointment_pay_btn,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    Widget cancelButton = ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CancelAppoinmentDialog(
              onPressYes: () {
                context
                    .read<AppointmentCubit>()
                    .cancelAppointment(appointment.id!);
                Navigator.of(dialogContext).pop();
                context.pop();
              },
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        context.l10n.appointment_cancel_booking_btn,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
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
      onPressed: () {
        // TODO: Handle Book Again logic
      },
    );

    Widget rateButton = OutlinedButton(
      onPressed: () {
        // TODO: Handle Rating logic
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Const.tosca),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        context.l10n.appointment_rating_btn,
        style: const TextStyle(
          color: Const.tosca,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    List<Widget> buttons;
    switch (status) {
      case 'pending':
        if (appointment.payment == null) {
          buttons = [payButton, cancelButton];
          isHorizontalLayout = false;
        } else {
          buttons = [cancelButton, rescheduleButton];
        }
        break;
      case 'accepted':
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

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

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

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileViewerPage(
          url: imageUrl,
          title: 'Issue Image', // Optional: Custom title
        ),
      ),
    );
  }
}

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
          SizedBox(
            width: 80,
            child: Text(label!),
          ),
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
      case 'accepted':
        return const Color(0xFFE59500);
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status, BuildContext context) {
    switch (status) {
      case 'upcoming':
        return context.l10n.appointment_status_upcoming;
      case 'accepted':
        return context.l10n.appointment_status_accepted;
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
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
