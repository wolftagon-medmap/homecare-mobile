import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/dna_chip.dart';

/// The Care DNA as a patient sees it.
///
/// Curated rather than exhaustive: a patient scanning for "speaks Hokkien,
/// knows dementia" should get that in the first screenful, so each section
/// shows its strongest few and hides the rest behind "show all".
class CareDnaPublicSections extends StatelessWidget {
  const CareDnaPublicSections({super.key, required this.dna});

  final CareDnaProfile dna;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChipSection(
          title: 'Speaks',
          icon: Icons.translate,
          items: [
            for (final t in dna.claimedLanguages)
              '${t.label} · ${LevelScale.language.labelFor(t.level)}',
          ],
          emptyText: 'No languages listed.',
        ),
        _ChipSection(
          title: 'Experienced with',
          icon: Icons.favorite_outline,
          items: [
            for (final t in dna.claimedConditions)
              '${t.label} ${LevelScale.experience.prefix}${t.level}',
          ],
          emptyText: 'No condition experience listed.',
        ),
        _ChipSection(
          title: 'Services & expertise',
          icon: Icons.medical_services_outlined,
          items: [
            for (final t in dna.ratedServices)
              '${t.label} ${LevelScale.proficiency.prefix}${t.level}',
          ],
          emptyText: 'No services rated yet.',
        ),
        _ChipSection(
          title: 'Care style',
          icon: Icons.handshake_outlined,
          items: dna.styleTraits,
          emptyText: 'No care style listed.',
        ),
        _ChipSection(
          title: 'Works with',
          icon: Icons.schedule,
          items: dna.preferences.publicHighlights,
          emptyText: 'No preferences listed.',
        ),
        if (dna.serviceAreas.isNotEmpty)
          _ChipSection(
            title: 'Covers',
            icon: Icons.map_outlined,
            items: dna.serviceAreas,
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
                for (final i in shown) DnaChip(label: i, filled: true)
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
class CareDnaStrip extends StatelessWidget {
  const CareDnaStrip({super.key, required this.dna});

  final CareDnaProfile dna;

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
              for (final c in dna.summaryChips(perCategory: 3))
                DnaChip(label: c, filled: true, dense: true),
            ],
          ),
        ],
      ),
    );
  }
}
