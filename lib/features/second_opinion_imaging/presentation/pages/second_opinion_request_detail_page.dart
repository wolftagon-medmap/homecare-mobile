import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/bloc/second_opinion_request_detail_cubit.dart';

class SecondOpinionRequestDetailPageParams {
  final AppointmentEntity appointment;
  final bool isProvider;

  SecondOpinionRequestDetailPageParams({
    required this.appointment,
    required this.isProvider,
  });
}

class SecondOpinionRequestDetailPage extends StatefulWidget {
  final SecondOpinionRequestDetailPageParams params;

  const SecondOpinionRequestDetailPage({
    super.key,
    required this.params,
  });

  @override
  State<SecondOpinionRequestDetailPage> createState() =>
      _SecondOpinionRequestDetailPageState();
}

class _SecondOpinionRequestDetailPageState
    extends State<SecondOpinionRequestDetailPage> {
  late TextEditingController _diagnosticController;
  late TextEditingController _recommendationController;

  AppointmentEntity get appointment => widget.params.appointment;
  bool get isProvider => widget.params.isProvider;

  @override
  void initState() {
    super.initState();
    final report = appointment.diagnosticReports
        .where((r) => r.type == 'second_opinion_imaging')
        .firstOrNull;
    _diagnosticController = TextEditingController(text: report?.conclusion);
    _recommendationController =
        TextEditingController(text: report?.recommendation);
  }

  @override
  void dispose() {
    _diagnosticController.dispose();
    _recommendationController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_diagnosticController.text.isEmpty ||
        _recommendationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all opinion fields")),
      );
      return;
    }

    context.read<SecondOpinionRequestDetailCubit>().submitFeedback(
          appointmentId: appointment.id!,
          diagnosticOpinion: _diagnosticController.text,
          recommendationOpinion: _recommendationController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final detail = appointment.serviceRequest?.detail;
    if (detail is! SecondOpinionDetail) {
      return Scaffold(
        appBar: AppBar(title: const Text("Request Detail")),
        body: const Center(child: Text("No request data found")),
      );
    }

    final report = appointment.diagnosticReports.firstOrNull;

    final bool canSubmitFeedback =
        isProvider && appointment.status.toLowerCase() == 'accepted';

    return BlocListener<SecondOpinionRequestDetailCubit,
        SecondOpinionRequestDetailState>(
      listener: (context, state) {
        log('state changed: $state', name: 'SecondOpinionRequestDetailPage');
        if (state.submissionStatus == ActionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Feedback submitted successfully")),
          );
          GoRouter.of(context).pop(true);
        } else if (state.submissionStatus == ActionStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Failed to submit")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${detail.serviceType == 'radiology' ? 'Radiology' : 'Pathology'} Detail"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Patient Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _InfoSection(label: "Disease Name", value: detail.diseaseName),
              _InfoSection(
                  label: "Disease History",
                  value: detail.diseaseHistory ?? "-"),
              _InfoSection(label: "Biomarker", value: detail.biomarker ?? "-"),
              const SizedBox(height: 24),
              Text(
                detail.serviceType == 'radiology'
                    ? "Radiology Images"
                    : "Digital Pathology Images",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _ImagesList(images: detail.images),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                "Medical Opinion",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (canSubmitFeedback) ...[
                _OpinionInput(
                  label: "Diagnostic Opinion",
                  controller: _diagnosticController,
                  hint: "Enter diagnostic opinion...",
                ),
                const SizedBox(height: 16),
                _OpinionInput(
                  label: "Recommendation Opinion",
                  controller: _recommendationController,
                  hint: "Enter recommendation opinion...",
                ),
                const SizedBox(height: 24),
                BlocBuilder<SecondOpinionRequestDetailCubit,
                    SecondOpinionRequestDetailState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.submissionStatus == ActionStatus.loading
                                ? null
                                : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Const.aqua,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: state.submissionStatus == ActionStatus.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text("Submit Medical Opinion",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
              ] else ...[
                _ReadOnlyOpinion(
                  label: "Diagnostic Opinion",
                  value: report?.conclusion,
                ),
                const SizedBox(height: 16),
                _ReadOnlyOpinion(
                  label: "Recommendation Opinion",
                  value: report?.recommendation,
                ),
                if (isProvider && appointment.status.toLowerCase() == 'pending')
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "* You must accept the appointment before providing medical opinion.",
                      style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String label;
  final String value;

  const _InfoSection({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          SelectableText(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _ImagesList extends StatelessWidget {
  final List<SecondOpinionImage> images;

  const _ImagesList({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Text("No images provided");
    }
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final img = images[index];
          final url = img.fileUrl;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: url != null
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FileViewerPage(
                                url: url,
                                title: img.imageType ?? "Image ${index + 1}",
                              ),
                            ),
                          )
                      : null,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: url != null
                        ? Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                color: Colors.grey),
                          )
                        : const Center(
                            child: Icon(Icons.hourglass_empty,
                                color: Colors.grey)),
                  ),
                ),
                if (img.imageType != null) ...[
                  const SizedBox(height: 4),
                  Text(img.imageType!, style: const TextStyle(fontSize: 12)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OpinionInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _OpinionInput({
    required this.label,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          minLines: 3,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyOpinion extends StatelessWidget {
  final String label;
  final String? value;

  const _ReadOnlyOpinion({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(label,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SelectableText(
            value != null && value!.isNotEmpty ? value! : "Not yet provided",
            style: TextStyle(
                fontStyle: value == null || value!.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
                color: value == null || value!.isEmpty
                    ? Colors.grey
                    : Colors.black),
          ),
        ),
      ],
    );
  }
}
