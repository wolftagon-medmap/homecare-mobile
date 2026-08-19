import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/reviewer.dart';
import 'package:m2health/features/professional_profile/domain/entities/certificate.dart';
import 'package:m2health/features/professional_profile/presentation/view/profile_summary.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/profile_highlights.dart';

/// The patient-facing professional profile. Rendered by the directory page and
/// by the professional's own preview, so the preview cannot drift from what a
/// patient actually sees.
class PublicProfileBody extends StatelessWidget {
  const PublicProfileBody({super.key, required this.professional});

  final ProfessionalEntity professional;

  @override
  Widget build(BuildContext context) {
    final summary = ProfileSummary.public(
      role: professional.jobTitle ?? professional.role,
      languages: professional.languages,
      conditions: professional.conditionExperience,
      services: professional.services,
      serviceProficiency: professional.serviceProficiency,
      careStyle: professional.careStyle,
      serviceAreas: professional.serviceAreas,
      preferenceHighlights: professional.preferenceHighlights,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Identity(professional: professional),
        const SizedBox(height: 20),
        ProfileHighlightStrip(summary: summary),
        const SizedBox(height: 12),
        _Stats(professional: professional),
        const SizedBox(height: 24),
        CollapsibleProfileHighlights(summary: summary),
        const SizedBox(height: 24),
        _Section(
          title: 'About',
          child: Text(
            (professional.about?.isNotEmpty ?? false)
                ? professional.about!
                : 'No description yet.',
            style: ProText.caption,
          ),
        ),
        _Section(
          title: 'Availability',
          child: _IconRow(
            icon: Icons.calendar_today_outlined,
            text: professional.workingHours?.isNotEmpty ?? false
                ? professional.workingHours!
                : 'Not specified',
          ),
        ),
        if (summary.serviceAreas.isNotEmpty)
          _Section(
            title: 'Covers',
            child: _IconRow(
              icon: Icons.location_on_outlined,
              text: summary.serviceAreas.join(', '),
            ),
          ),
        _Section(
          title: 'Credentials',
          child: _Certificates(certificates: professional.certificates),
        ),
        _Section(
          title: 'Reviews',
          child: _Reviews(reviews: professional.reviews ?? const []),
        ),
      ],
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.professional});

  final ProfessionalEntity professional;

  @override
  Widget build(BuildContext context) {
    final avatar = professional.avatar;

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Const.aqua.withValues(alpha: 0.15),
            backgroundImage: (avatar != null && avatar.isNotEmpty)
                ? NetworkImage(avatar)
                : null,
            child: (avatar != null && avatar.isNotEmpty)
                ? null
                : const Icon(Icons.person, size: 44, color: Const.tosca),
          ),
          const SizedBox(height: 10),
          Text(professional.name, style: ProText.pageTitle),
          const SizedBox(height: 2),
          Text(professional.jobTitle ?? professional.role,
              style: ProText.caption),
          const SizedBox(height: 8),
          // Only verified professionals are served by this endpoint, so the
          // badge states a fact rather than decorating one.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Const.tosca.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 14, color: Const.tosca),
                const SizedBox(width: 4),
                Text('Verified',
                    style: ProText.hint.copyWith(color: Const.tosca)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.professional});

  final ProfessionalEntity professional;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Const.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Stat(
            value: '${professional.completedAppointmentsCount}',
            label: 'Visits',
          ),
          const _StatDivider(),
          _Stat(
              value: '${professional.experience ?? 0}y+', label: 'Experience'),
          const _StatDivider(),
          _Stat(
            value: (professional.rating ?? 0) == 0
                ? '—'
                : professional.rating!.toStringAsFixed(1),
            label: 'Rating',
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: ProText.sectionTitle.copyWith(color: Const.tosca)),
          const SizedBox(height: 2),
          Text(label, style: ProText.hint),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: Const.borderSubtle);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: ProText.sectionTitle),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Const.contentTextColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: ProText.caption)),
      ],
    );
  }
}

class _Certificates extends StatelessWidget {
  const _Certificates({required this.certificates});

  final List<Certificate>? certificates;

  @override
  Widget build(BuildContext context) {
    final items = certificates ?? const <Certificate>[];
    if (items.isEmpty) {
      return const Text('No credentials listed.', style: ProText.caption);
    }

    return Column(
      children: [
        for (final cert in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 96,
                    height: 66,
                    child: Image.network(
                      cert.fileURL,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Const.surfaceMuted,
                        child: const Icon(Icons.description_outlined,
                            color: Const.contentTextColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cert.title, style: ProText.bodyStrong),
                      const SizedBox(height: 2),
                      Text('No. ${cert.registrationNumber}',
                          style: ProText.hint),
                      Text('Issued ${cert.issuedOn}', style: ProText.hint),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({required this.reviews});

  final List<ReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Text('No reviews yet.', style: ProText.caption);
    }

    return Column(
      children: [
        for (final review in reviews)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Const.surfaceMuted,
                      backgroundImage: review.reviewer.avatar.isNotEmpty
                          ? NetworkImage(review.reviewer.avatar)
                          : null,
                      child: review.reviewer.avatar.isNotEmpty
                          ? null
                          : const Icon(Icons.person,
                              size: 18, color: Const.contentTextColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                          Text(review.reviewer.name, style: ProText.bodyStrong),
                    ),
                    const Icon(Icons.star, size: 16, color: Color(0xFFFFC107)),
                    const SizedBox(width: 2),
                    Text(review.score.toString(), style: ProText.caption),
                  ],
                ),
                if (review.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(review.description, style: ProText.caption),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
