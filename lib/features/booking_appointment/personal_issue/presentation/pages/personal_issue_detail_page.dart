import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/i18n/translations.g.dart';

class PersonalIssueDetailPage extends StatelessWidget {
  final PersonalIssue issue;

  const PersonalIssueDetailPage({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          issue.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConcernCard(context),
              const SizedBox(height: 32),
              // _buildRelatedSymptomsSection(context),
              // const SizedBox(height: 32),
              _buildImagesSection(context),
              const SizedBox(height: 32),
              // _buildNotes(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConcernCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xffeef9fe),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFBFE8FF),
          width: 2,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              issue.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.booking.issue.form.complaint_label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("\"${issue.description}\""),
              ],
            ),
            const SizedBox(height: 12),
            if (issue.updatedAt != null)
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    context.t.booking.issue.updated_on(
                        date: DateFormat('EEEE, MMM d, y, HH:mm')
                            .format(issue.updatedAt!)),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection(BuildContext context) {
    final allImages = [...issue.imageUrls, ...issue.images];

    if (allImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(context.t.booking.issue.images,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      const SizedBox(height: 18),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 images per row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: allImages.length,
        itemBuilder: (context, index) {
          final imageItem = allImages[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: imageItem is String
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileViewerPage(url: imageItem),
                        ),
                      );
                    },
                    child: Image.network(
                      imageItem, // Remote image URL
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error));
                      },
                    ),
                  )
                : Image.file(
                    imageItem as File, // Local image File
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error));
                    },
                  ),
          );
        },
      ),
    ]);
  }

  // ignore: unused_element
  Widget _buildNoteCard(
      {required String title, required List<dynamic> points}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color(0xfffff4e8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xfffee9d5), // Border color
          width: 1.5,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: points.map((pointData) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pointData['point'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (pointData['description'].isNotEmpty)
                              Text(
                                pointData['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
