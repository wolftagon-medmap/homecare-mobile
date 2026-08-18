import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/presentation/view/profile_summary.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/profile_chip.dart';

/// The Care DNA as a patient sees it.
///
/// Curated rather than exhaustive: a patient scanning for "speaks Hokkien,
/// knows dementia" should get that in the first screenful, so each section
/// shows its strongest few and hides the rest behind "show all".
class ProfileHighlightSections extends StatelessWidget {
  const ProfileHighlightSections({super.key, required this.summary});

  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChipSection(
          title: 'Speaks',
          icon: Icons.translate,
          items: [
            for (final e in summary.languages)
              '${e.label} · ${LevelScale.language.labelFor(e.level)}',
          ],
          emptyText: 'No languages listed.',
        ),
        _ChipSection(
          title: 'Experienced with',
          icon: Icons.favorite_outline,
          items: [
            for (final e in summary.conditions) e.badge(LevelScale.experience),
          ],
          emptyText: 'No condition experience listed.',
        ),
        _ChipSection(
          title: 'Services & expertise',
          icon: Icons.medical_services_outlined,
          items: [
            for (final e in summary.services) e.badge(LevelScale.proficiency),
          ],
          emptyText: 'No services rated yet.',
        ),
        _ChipSection(
          title: 'Care style',
          icon: Icons.handshake_outlined,
          items: summary.styleTraits,
          emptyText: 'No care style listed.',
        ),
        _ChipSection(
          title: 'Works with',
          icon: Icons.schedule,
          items: summary.preferenceHighlights,
          emptyText: 'No preferences listed.',
        ),
        if (summary.serviceAreas.isNotEmpty)
          _ChipSection(
            title: 'Covers',
            icon: Icons.map_outlined,
            items: summary.serviceAreas,
            emptyText: '',
          ),
      ],
    );
  }
}

/// How many chips a section shows before collapsing the rest behind "show all".
const int _kVisibleChips = 5;

/// A titled block of chips that collapses past [_kVisibleChips].
class _ChipSection extends StatefulWidget {
  const _ChipSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.emptyText,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final String emptyText;

  @override
  State<_ChipSection> createState() => _ChipSectionState();
}

class _ChipSectionState extends State<_ChipSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.emptyText.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasMore = widget.items.length > _kVisibleChips;
    final shown = _expanded || !hasMore
        ? widget.items
        : widget.items.take(_kVisibleChips).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 18, color: Const.tosca),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.items.isEmpty)
            Text(
              widget.emptyText,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final i in shown) ProfileChip(label: i, filled: true)
              ],
            ),
          if (hasMore)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Show less' : 'Show all ${widget.items.length}',
                  style: const TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The one-line identity strip: the PRD's Care DNA summary, patient-facing.
class ProfileHighlightStrip extends StatelessWidget {
  const ProfileHighlightStrip({super.key, required this.summary});

  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Const.aqua.withValues(alpha: 0.10),
            Const.tosca.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Const.aqua.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fingerprint, size: 16, color: Const.tosca),
              const SizedBox(width: 6),
              Text(
                'CARE DNA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: Const.tosca.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final c in summary.summaryChips(perCategory: 3))
                ProfileChip(label: c, filled: true, dense: true),
            ],
          ),
        ],
      ),
    );
  }
}

/// A patient scanning a profile wants the strip, not forty chips. The detail
/// stays one tap away rather than on the page by default.
class CollapsibleProfileHighlights extends StatefulWidget {
  const CollapsibleProfileHighlights({super.key, required this.summary});

  final ProfileSummary summary;

  @override
  State<CollapsibleProfileHighlights> createState() =>
      _CollapsibleProfileHighlightsState();
}

class _CollapsibleProfileHighlightsState
    extends State<CollapsibleProfileHighlights> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Care DNA details',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
                Text(
                  _expanded ? 'Hide' : 'Show',
                  style: const TextStyle(fontSize: 13, color: Const.tosca),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: Const.tosca,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ProfileHighlightSections(summary: widget.summary),
      ],
    );
  }
}
