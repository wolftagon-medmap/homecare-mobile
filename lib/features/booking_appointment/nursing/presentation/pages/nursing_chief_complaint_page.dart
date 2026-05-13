import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

class NursingChiefComplaintPage extends StatelessWidget {
  final AppointmentEntity appointment;
  const NursingChiefComplaintPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final detail = appointment.serviceRequest?.detail;
    final issues = detail is NursingDetail
        ? ([...detail.personalIssues]
          ..sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!)))
        : <PersonalIssue>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chief Complaint'),
      ),
      body: issues.isEmpty
          ? const Center(child: Text('No issues recorded'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: issues.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) =>
                  _PersonalIssueCard(issue: issues[index]),
            ),
    );
  }
}

class _PersonalIssueCard extends StatelessWidget {
  final PersonalIssue issue;
  const _PersonalIssueCard({required this.issue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          issue.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(issue.description, style: const TextStyle(height: 1.5)),
        if (issue.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: issue.imageUrls.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FileViewerPage(
                        url: issue.imageUrls[i],
                        title: issue.title,
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      issue.imageUrls[i],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (issue.createdAt != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                DateFormat.yMMMd().add_jm().format(issue.createdAt!.toLocal()),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
