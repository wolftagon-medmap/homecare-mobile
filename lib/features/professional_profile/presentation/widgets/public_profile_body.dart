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
    final workplace = _workplace(professional);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(professional: professional),
        const SizedBox(height: 16),
        _Stats(professional: professional),
        const SizedBox(height: 20),
        CollapsibleProfileHighlights(summary: summary),
        const SizedBox(height: 24),
        _Section(
          title: 'About me',
          child: Text(
            (professional.about?.isNotEmpty ?? false)
                ? professional.about!
                : 'No description yet.',
            textAlign: TextAlign.justify,
            style: ProText.caption,
          ),
        ),
        _Section(
          title: 'Working Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconRow(
                icon: Icons.calendar_today_outlined,
                text: (professional.workingHours?.isNotEmpty ?? false)
                    ? professional.workingHours!
                    : 'Not specified',
              ),
              const SizedBox(height: 8),
              _IconRow(
                icon: Icons.location_on_outlined,
                text: workplace ?? 'Not specified',
                link: workplace != null,
              ),
            ],
          ),
        ),
        _Section(
          title: 'Professional Certificate',
          child: _Certificates(certificates: professional.certificates),
        ),
        _Section(
          title: 'Reviews',
          trailing: (professional.reviews?.isNotEmpty ?? false)
              ? TextButton(onPressed: () {}, child: const Text('SEE ALL'))
              : null,
          child: _Reviews(reviews: professional.reviews ?? const []),
        ),
      ],
    );
  }

  static String? _workplace(ProfessionalEntity professional) {
    final address = professional.workplaceAddress;
    if (address == null) return null;

    final parts = [address.name, address.formattedAddress]
        .where((p) => p != null && p.isNotEmpty)
        .join(', ');
    return parts.isEmpty ? null : parts;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.professional});

  final ProfessionalEntity professional;

  @override
  Widget build(BuildContext context) {
    final avatar = professional.avatar;

    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Const.aqua.withValues(alpha: 0.12),
                  child: (avatar != null && avatar.isNotEmpty)
                      ? Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person,
                                  size: 40, color: Const.tosca),
                        )
                      : const Icon(Icons.person, size: 40, color: Const.tosca),
                ),
              ),
              const Positioned(
                top: -6,
                right: -6,
                child: Icon(Icons.circle, color: Color(0xFF8EF4BC), size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(professional.name, style: ProText.pageTitle),
          Text(professional.jobTitle ?? professional.role,
              style: ProText.caption),
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
    final rating = professional.rating ?? 0;

    return Row(
      children: [
        _StatCard(
          value: '${professional.completedAppointmentsCount}+',
          label: 'Patient',
        ),
        _StatCard(
          value: '${professional.experience ?? 0}Y+',
          label: 'Experience',
        ),
        _StatCard(
          value: rating == 0 ? '—' : rating.toStringAsFixed(1),
          label: 'Rating',
          icon: Icons.star,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, this.icon});

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: const Color(0xFFFFC107)),
                    const SizedBox(width: 4),
                  ],
                  Text(value,
                      style: ProText.sectionTitle.copyWith(color: Const.tosca)),
                ],
              ),
              const SizedBox(height: 2),
              Text(label, style: ProText.hint),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: ProText.sectionTitle),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text, this.link = false});

  final IconData icon;
  final String text;
  final bool link;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Const.contentTextColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: link
                ? ProText.caption.copyWith(color: Const.primaryBlue)
                : ProText.caption,
          ),
        ),
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
      return const Text('No certificate listed.', style: ProText.caption);
    }

    return Column(
      children: [
        for (final cert in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  height: 76,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cert.title, style: ProText.bodyStrong),
                      const SizedBox(height: 2),
                      Text('ID Numbers: ${cert.registrationNumber}',
                          style: ProText.caption),
                      Text(
                        'Issued on ${cert.issuedOn}',
                        style: ProText.caption
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Const.surfaceMuted,
                      backgroundImage: review.reviewer.avatar.isNotEmpty
                          ? NetworkImage(review.reviewer.avatar)
                          : null,
                      child: review.reviewer.avatar.isNotEmpty
                          ? null
                          : const Icon(Icons.person,
                              size: 22, color: Const.contentTextColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child:
                          Text(review.reviewer.name, style: ProText.bodyStrong),
                    ),
                    const Icon(Icons.star, size: 16, color: Color(0xFFFFC107)),
                    const SizedBox(width: 4),
                    Text(review.score.toString(), style: ProText.caption),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review.description.isNotEmpty
                      ? review.description
                      : 'No comment provided.',
                  style: ProText.caption,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
