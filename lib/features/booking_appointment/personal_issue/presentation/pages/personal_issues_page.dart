import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/issue_form_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/personal_issue_detail_page.dart';
import 'package:m2health/i18n/translations.g.dart';

class PersonalIssuesPage extends StatefulWidget {
  final Function(List<PersonalIssue>) onIssuesSelected;
  final List<PersonalIssue>? initialSelectedIssues;

  const PersonalIssuesPage({
    super.key,
    required this.onIssuesSelected,
    this.initialSelectedIssues,
  });

  @override
  State<PersonalIssuesPage> createState() => _PersonalIssuesPageState();
}

class _PersonalIssuesPageState extends State<PersonalIssuesPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedIssues != null) {
      context
          .read<PersonalIssuesCubit>()
          .setSelectedIssues(widget.initialSelectedIssues!);
    }
    _loadData();
  }

  void _loadData() {
    context.read<PersonalIssuesCubit>().loadNursingIssues();
  }

  void _onClickNext(BuildContext context, List<PersonalIssue> issues) {
    widget.onIssuesSelected(issues);
  }

  String getTitle(BuildContext context) {
    final serviceType = context.read<PersonalIssuesCubit>().state.serviceType;
    switch (serviceType) {
      case 'nursing':
        return context.t.booking.issue.nurse_page_title;
      case 'pharmacy':
        return context.t.booking.issue.pharmacy_page_title;
      case 'radiology':
        return context.t.booking.issue.radiology_page_title;
      default:
        return context.t.booking.issue.default_page_title;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int issueId) {
    final cubit = context.read<PersonalIssuesCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.t.booking.issue.delete_dialog.title),
          content: Text(context.t.booking.issue.delete_dialog.content),
          actions: <Widget>[
            TextButton(
              child: Text(context.t.global.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(context.t.global.delete,
                  style: const TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cubit.deleteIssue(issueId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitle(context),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 0.0),
            Column(
              children: [
                Center(
                  child: Text(
                    context.t.booking.issue.fill_complaint_instruction,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Const.aqua,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: BlocBuilder<PersonalIssuesCubit, PersonalIssuesState>(
                builder: (context, state) {
                  if (state.loadStatus == ActionStatus.loading ||
                      state.loadStatus == ActionStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.loadStatus == ActionStatus.error) {
                    return Center(
                        child: Text(
                            '${context.t.global.error}: ${state.loadErrorMessage ?? ''}'));
                  }

                  if (state.loadStatus == ActionStatus.success) {
                    final issues = state.issues;
                    log('Loaded Issues: ${issues}', name: 'PersonalIssuesPage');
                    return RefreshIndicator(
                      color: Const.aqua,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        _loadData();
                      },
                      child: issues.isEmpty
                          ? Center(
                              child: Text(
                                context.t.booking.issue.empty_issue,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: issues.length,
                              itemBuilder: (context, index) {
                                final issue = issues[index];
                                final isSelected =
                                    state.selectedIssueIds.contains(issue.id);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PersonalIssueDetailPage(
                                          issue: issue,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Transform.scale(
                                              scale: 1.2,
                                              child: Checkbox(
                                                value: isSelected,
                                                activeColor: Const.aqua,
                                                visualDensity:
                                                    VisualDensity.comfortable,
                                                onChanged: (bool? value) {
                                                  context
                                                      .read<
                                                          PersonalIssuesCubit>()
                                                      .toggleIssueSelection(
                                                          issue.id!);
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        issue.title,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    PopupMenuButton<String>(
                                                      color: Colors.white,
                                                      onSelected: (value) {
                                                        if (value == 'edit') {
                                                          final issuesCubit =
                                                              context.read<
                                                                  PersonalIssuesCubit>();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BlocProvider
                                                                      .value(
                                                                value:
                                                                    issuesCubit,
                                                                child: IssueFormPage(
                                                                    issue:
                                                                        issue),
                                                              ),
                                                            ),
                                                          );
                                                        } else if (value ==
                                                            'delete') {
                                                          _showDeleteConfirmationDialog(
                                                              context,
                                                              issue.id!);
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        PopupMenuItem<String>(
                                                          value: 'edit',
                                                          child: Text(
                                                            context.t.global
                                                                .modify,
                                                          ),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'delete',
                                                          child: Text(
                                                            context.t.global
                                                                .delete,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.access_time,
                                                        size: 16,
                                                        color:
                                                            Colors.grey[600]),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      context.t.booking.issue
                                                          .updated_on(
                                                              date: DateFormat(
                                                                      'MMM d, y, HH:mm')
                                                                  .format(issue
                                                                      .updatedAt!)),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(issue.description),
                                                const SizedBox(height: 8),
                                                if (issue.imageUrls.isNotEmpty)
                                                  Wrap(
                                                    spacing: 8.0,
                                                    runSpacing: 8.0,
                                                    children:
                                                        // Render remote images
                                                        issue.imageUrls
                                                            .map((imageUrl) {
                                                      return Image.network(
                                                        imageUrl,
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            'assets/images/no_img.jpg',
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      );
                                                    }).toList(),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  }
                  // Fallback
                  return const Center(child: Text('Error: Unknown error'));
                },
              ),
            ),
            BlocBuilder<PersonalIssuesCubit, PersonalIssuesState>(
              builder: (context, state) {
                final bool canProceed = state.selectedIssueIds.isNotEmpty;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () {
                          final issuesCubit =
                              context.read<PersonalIssuesCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: issuesCubit,
                                child: const IssueFormPage(),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF35C5CF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          context.t.booking.issue.add_issue_button,
                          style:
                              const TextStyle(color: Const.aqua, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: canProceed
                            ? () {
                                final selectedIssues = state.issues
                                    .where((issue) => state.selectedIssueIds
                                        .contains(issue.id))
                                    .toList();
                                _onClickNext(context, selectedIssues);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              canProceed ? Const.aqua : const Color(0xFFB2B2B2),
                          disabledBackgroundColor: const Color(0xFFB2B9C4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          context.t.global.next,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
