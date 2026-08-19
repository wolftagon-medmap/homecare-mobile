import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_profile_remote_datasource.dart';
import 'package:m2health/features/professional_profile/domain/entities/onboarding_status.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/admin_professional_detail_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/pages/edit_professional_profile.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/certificate_preview_page.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/reject_professional_dialog.dart';

class AdminProfessionalDetailPage extends StatelessWidget {
  final int professionalId;
  final String role;

  const AdminProfessionalDetailPage({
    super.key,
    required this.professionalId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProfessionalDetailCubit(
          GetIt.I<ProfessionalProfileRemoteDatasource>())
        ..loadDetail(professionalId, role),
      child: const _AdminProfessionalDetailView(),
    );
  }
}

class _AdminProfessionalDetailView extends StatefulWidget {
  const _AdminProfessionalDetailView();

  @override
  State<_AdminProfessionalDetailView> createState() =>
      _AdminProfessionalDetailViewState();
}

class _AdminProfessionalDetailViewState
    extends State<_AdminProfessionalDetailView> {
  bool _isLoadingAction = false;

  Widget _buildActions(
      BuildContext context, ProfessionalProfile profile, String role) {
    if (_isLoadingAction) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final cubit = context.read<AdminProfessionalDetailCubit>();

    switch (profile.verificationStatus) {
      case VerificationStatus.pending:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.aqua,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() => _isLoadingAction = true);
                  cubit.verifyProfessional(profile.id, role);
                },
                child: const Text("VERIFY THIS USER",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _openRejectDialog(context, profile),
                child: const Text("REJECT",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      case VerificationStatus.verified:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() => _isLoadingAction = true);
              cubit.revokeProfessional(profile.id, role);
            },
            child: const Text("REVOKE VERIFICATION",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      default:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            profile.verificationStatus == VerificationStatus.rejected
                ? "This submission was rejected. The professional must fix the issues and resubmit."
                : "This professional has not submitted for verification yet.",
            style: TextStyle(color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  void _openRejectDialog(BuildContext context, ProfessionalProfile profile) {
    final cubit = context.read<AdminProfessionalDetailCubit>();
    showDialog(
      context: context,
      builder: (_) => RejectProfessionalDialog(
        onSubmit: (category, note) {
          setState(() => _isLoadingAction = true);
          cubit.rejectProfessional(profile.id, category, note);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent =
        context.findAncestorWidgetOfExactType<AdminProfessionalDetailPage>();
    final String role = parent?.role ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Professional Detail",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<AdminProfessionalDetailCubit,
          AdminProfessionalDetailState>(
        listener: (context, state) {
          if (state is AdminProDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
            setState(() => _isLoadingAction = false);
          } else if (state is AdminProDetailVerified) {
            final isNowVerified = state.profile.isVerified;
            final message = isNowVerified
                ? "Professional Verified Successfully"
                : "Verification Revoked Successfully";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: isNowVerified ? Colors.green : Colors.orange,
              ),
            );
            setState(() => _isLoadingAction = false);
            // Go back and refresh list
            Navigator.pop(context, true);
          } else if (state is AdminProDetailRejected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Submission rejected"),
                backgroundColor: Colors.orange,
              ),
            );
            setState(() => _isLoadingAction = false);
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is AdminProDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = switch (state) {
            AdminProDetailLoaded s => s.profile,
            AdminProDetailVerified s => s.profile,
            AdminProDetailRejected s => s.profile,
            _ => null,
          };

          if (profile != null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: profile.avatar != null
                              ? NetworkImage(profile.avatar!)
                              : null,
                          child: profile.avatar == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.name ?? 'No Name',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        _StatusChip(status: profile.verificationStatus),
                        if (profile.submittedAt != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            "Submitted ${DateFormat('MMM dd, yyyy').format(profile.submittedAt!)}",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Details
                  _DetailRow(
                      icon: Icons.work,
                      label: "Job Title",
                      value: profile.jobTitle ?? '-'),
                  _DetailRow(
                      icon: Icons.history,
                      label: "Experience",
                      value: "${profile.experience ?? 0} Years"),
                  _DetailRow(
                      icon: Icons.access_time,
                      label: "Working Hours",
                      value: profile.workingHours ?? '-'),
                  _DetailRow(
                      icon: Icons.location_on,
                      label: "Workplace",
                      value: profile.workPlace ?? '-'),

                  const SizedBox(height: 24),
                  const Text("About",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(profile.about ?? "No description provided.",
                      style:
                          TextStyle(color: Colors.grey.shade700, height: 1.5)),

                  const SizedBox(height: 24),
                  const Text("Provided Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _ServicesList(services: profile.providedServices),

                  const SizedBox(height: 24),
                  const Text("Weekly Schedule",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _ScheduleList(availabilities: profile.weeklyAvailabilities),

                  const SizedBox(height: 24),
                  const Text("Certificates",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (profile.certificates.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange),
                          SizedBox(width: 12),
                          Text("No certificates uploaded."),
                        ],
                      ),
                    )
                  else
                    ...profile.certificates.map((cert) => InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CertificatePreviewPage(
                                imageUrl: cert.fileURL,
                                title: cert.title,
                              ),
                            ),
                          ),
                          child: CertificateCard(
                            certification: cert,
                            onEdit: () {}, // Read only
                            onRemove: () {}, // Read only
                            withActions: false,
                          ),
                        )),

                  const SizedBox(height: 40),
                  _buildActions(context, profile, role),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}

Widget _emptyNote(String text) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: Colors.grey.shade600)),
    );

class _StatusChip extends StatelessWidget {
  final VerificationStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (status) {
      VerificationStatus.verified => ("Verified Professional", Colors.green),
      VerificationStatus.pending => ("Verification Pending", Colors.orange),
      VerificationStatus.rejected => ("Rejected", Colors.red),
      _ => ("Not Submitted", Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _ServicesList extends StatelessWidget {
  final List<ServiceEntity> services;
  const _ServicesList({required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return _emptyNote("No services selected.");
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: services
          .map((s) => Chip(
                label: Text(s.name),
                backgroundColor: Const.aqua.withValues(alpha: 0.1),
                side: BorderSide(color: Const.aqua.withValues(alpha: 0.3)),
              ))
          .toList(),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<ProviderAvailability> availabilities;
  const _ScheduleList({required this.availabilities});

  static const _dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  Widget build(BuildContext context) {
    if (availabilities.isEmpty) return _emptyNote("No weekly schedule set.");

    final byDay = <int, List<ProviderAvailability>>{};
    for (final a in availabilities) {
      byDay.putIfAbsent(a.dayOfWeek, () => []).add(a);
    }
    final days = byDay.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: days.map((day) {
        final blocks = byDay[day]!
          ..sort((x, y) => x.startTime.compareTo(y.startTime));
        final ranges =
            blocks.map((b) => '${b.startTime} - ${b.endTime}').join(', ');
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(_dayNames[day],
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Expanded(child: Text(ranges)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Const.aqua.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Const.aqua, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
