import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/messaging/thread_ref.dart';
import 'package:m2health/core/presentation/widgets/messaging/message_action_button.dart';

import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/appointment/bloc/care_task_detail_cubit.dart';
import 'package:m2health/features/appointment/data/models/patient_care_task_detail.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/core/presentation/widgets/buttons/gradient_button.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/route/appointment_routes.dart';

/// Detail page for a pre-acceptance booking (v2 care task) — the patient-side
/// mirror of the appointment detail page. Once the booking is accepted it
/// materializes into an appointment, so this page bounces to the appointment
/// detail when that has happened.
class CareTaskDetailPage extends StatelessWidget {
  final int careTaskId;

  const CareTaskDetailPage({super.key, required this.careTaskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CareTaskDetailCubit(sl<Dio>())..fetchDetail(careTaskId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.appointment_detail_title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<CareTaskDetailCubit, CareTaskDetailState>(
          listener: (context, state) {
            // Accepted while we were looking — the appointment is the real
            // detail now.
            if (state is CareTaskDetailLoaded &&
                state.detail.appointmentId != null) {
              context.pushReplacement(
                  AppointmentRoutes.detailPath(state.detail.appointmentId!));
            }
          },
          builder: (context, state) {
            if (state is CareTaskDetailLoading ||
                state is CareTaskDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CareTaskDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is CareTaskDetailLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<CareTaskDetailCubit>()
                      .fetchDetail(careTaskId);
                },
                child: _Content(detail: state.detail),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          height: 80,
          child: Builder(
            // The assistant and the professional are two different
            // conversations. Putting them side by side is the clearest way to
            // say so.
            builder: (context) => Row(
              children: [
                MessageActionButton(
                  threadRef: ThreadRef.forCareTask(careTaskId),
                  style: MessageActionStyle.icon,
                ),
                Expanded(
                  child: GradientButton(
                    text: 'Continue in AI Chat',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF35C5CF), Color(0xFF9DCEFF)],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    onPressed: () async {
                      await GoRouter.of(context).push(AppRoutes.intakeBooking);
                      if (context.mounted) {
                        context
                            .read<CareTaskDetailCubit>()
                            .fetchDetail(careTaskId);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final PatientCareTaskDetail detail;
  const _Content({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProviderCard(detail: detail),
          const SizedBox(height: 16),
          _ScheduleSection(detail: detail),
          const SizedBox(height: 16),
          _PatientSection(detail: detail),
          if (detail.chiefComplaint != null &&
              detail.chiefComplaint!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ComplaintSection(complaint: detail.chiefComplaint!),
          ],
          const SizedBox(height: 16),
          _EstimateSection(detail: detail),
        ],
      ),
    );
  }
}

/// The offered professional, or a "finding a professional" placeholder while
/// matching is still under way.
class _ProviderCard extends StatelessWidget {
  final PatientCareTaskDetail detail;
  const _ProviderCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final provider = detail.provider;

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
                (provider?.avatar != null && provider!.avatar!.isNotEmpty)
                    ? NetworkImage(provider.avatar!)
                    : null,
            child: (provider?.avatar == null || provider!.avatar!.isEmpty)
                ? Icon(provider == null ? Icons.person_search : Icons.person,
                    size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider?.name ?? detail.serviceLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(provider != null
                    ? (provider.jobTitle ?? detail.serviceLabel)
                    : 'We are finding the right professional for you'),
                const SizedBox(height: 8),
                _StatusTag(label: detail.statusLabel, status: detail.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleSection extends StatelessWidget {
  final PatientCareTaskDetail detail;
  const _ScheduleSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, AppLocale>(
      builder: (context, locale) {
        String date;
        String hour;
        if (detail.scheduledStart != null) {
          final localStart = detail.scheduledStart!.toLocal();
          date = DateFormat.yMMMMEEEEd(locale.languageCode).format(localStart);
          final startHour =
              DateFormat.jm(locale.languageCode).format(localStart);
          final localEnd = detail.scheduledEnd?.toLocal();
          hour = localEnd != null
              ? '$startHour - ${DateFormat.jm(locale.languageCode).format(localEnd)}'
              : startHour;
        } else {
          date = detail.preferredDate ?? 'To be confirmed';
          hour = detail.preferredTime ?? 'To be confirmed';
        }

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

class _PatientSection extends StatelessWidget {
  final PatientCareTaskDetail detail;
  const _PatientSection({required this.detail});

  @override
  Widget build(BuildContext context) {
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
          _InfoRow(
            label: context.l10n.full_name,
            text: detail.patientName ?? context.l10n.none,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: context.l10n.address,
            text: detail.location ?? context.l10n.none,
            isFlexible: true,
          ),
        ],
      ),
    );
  }
}

class _ComplaintSection extends StatelessWidget {
  final String complaint;
  const _ComplaintSection({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chief Complaint',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(complaint, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class _EstimateSection extends StatelessWidget {
  final PatientCareTaskDetail detail;
  const _EstimateSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appointment_detail_estimated_budget,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: context.l10n.services,
            text: detail.serviceLabel,
            isFlexible: true,
          ),
          const Divider(height: 16),
          Row(
            children: [
              Text(
                context.l10n.appointment_detail_total_label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              Text(
                '\$${detail.estimatedPrice.toStringAsFixed(2)}',
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
  final String label;
  final String status;
  const _StatusTag({required this.label, required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'pending':
      case 'matched':
        return const Color(0xFFE59500);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: _color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
