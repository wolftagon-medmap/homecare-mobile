import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/diagnostic_report_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/screening_appointment_action_cubit.dart';
import 'package:m2health/features/home_health_screening/presentation/widgets/screening_appointment_detail_action_buttons.dart';

class HomeScreeningAppointmentDetailPage extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isProvider;

  const HomeScreeningAppointmentDetailPage({
    super.key,
    required this.appointment,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreeningAppointmentActionCubit,
        ScreeningAppointmentActionState>(
      listener: (context, state) {
        if (state is ScreeningAppointmentActionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(children: [
                const Icon(Icons.check, color: Colors.white),
                const SizedBox(width: 8),
                Text(state.message ?? 'Updated successfully'),
              ]),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ));
          Navigator.of(context).pop(true);
        } else if (state is ScreeningAppointmentActionError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(state.message)),
              ]),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Lab Tests & Reports')),
        body: _ScreeningDetailBody(
          appointment: appointment,
          isProvider: isProvider,
        ),
        bottomNavigationBar: isProvider
            ? ScreeningAppointmentDetailActionButtons(
                appointment: appointment,
                // The BlocListener above handles snackbars and pop — no-op here.
                refreshCallback: () {},
              )
            : null,
      ),
    );
  }
}

class _ScreeningDetailBody extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isProvider;

  const _ScreeningDetailBody({
    required this.appointment,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    final status = appointment.serviceRequest?.status ?? 'request_submitted';
    final detail = appointment.serviceRequest?.detail;
    final services = detail is ScreeningDetail ? detail.services : const [];
    final reports = appointment.diagnosticReports
        .where((r) => r.type == 'screening')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusRow(status: status),
          const SizedBox(height: 16),
          if (services.isNotEmpty) ...[
            const Text(
              'Requested Services',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...services.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${e.key + 1}. ${e.value.name}',
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
            const SizedBox(height: 16),
          ],
          if (!isProvider &&
              reports.isNotEmpty &&
              status == 'report_ready') ...[
            Text(
              'Reports (${reports.length})',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ..._buildReportCards(context, reports),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildReportCards(
      BuildContext context, List<DiagnosticReportEntity> reports) {
    return reports.map((report) {
      final file = report.file;
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200)),
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: file != null
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    file.extname == 'pdf'
                        ? Icons.picture_as_pdf
                        : Icons.insert_drive_file,
                    color: Colors.red,
                  ),
                )
              : const Icon(Icons.description),
          title: Text('Report #${report.id}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: file != null
              ? Text(file.extname.toUpperCase())
              : Text(report.conclusion ?? ''),
          trailing: file != null
              ? IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FileViewerPage(
                        url: file.url,
                        title: 'Lab Report #${report.id}',
                      ),
                    ),
                  ),
                )
              : null,
        ),
      );
    }).toList();
  }
}

class _StatusRow extends StatelessWidget {
  final String status;
  const _StatusRow({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Status',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Const.aqua.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status.replaceAll('_', ' ').toTitleCase(),
            style:
                const TextStyle(color: Const.aqua, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
