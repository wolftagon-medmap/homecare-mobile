import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/presentation/view/profile_summary.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/guidance_sheet.dart';
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
          title: 'Language Proficiency',
          icon: Icons.translate,
          guide: const _ScaleGuide(
            LevelScale.language,
            'How well this professional speaks each language they have added.',
          ),
          items: [
            for (final e in summary.languages)
              '${e.label} · ${LevelScale.language.labelFor(e.level)}',
          ],
          emptyText: 'No languages listed.',
        ),
        _ChipSection(
          title: 'Experienced with',
          icon: Icons.favorite_outline,
          guide: const _ScaleGuide(
            LevelScale.experience,
            'How much hands-on experience this professional has with each '
            'condition.',
          ),
          items: [
            for (final e in summary.conditions) e.badge(LevelScale.experience),
          ],
          emptyText: 'No condition experience listed.',
        ),
        _ChipSection(
          title: 'Clinical & Service Skills',
          icon: Icons.medical_services_outlined,
          guide: const _ScaleGuide(
            LevelScale.proficiency,
            'How much expertise this professional claims in each service they '
            'offer.',
          ),
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
          _ServiceAreaSection(
            areas: summary.serviceAreas,
            countryCode: summary.countryCode,
          ),
      ],
    );
  }
}

/// How many chips a section shows before collapsing the rest behind "show all".
const int _kVisibleChips = 5;

/// The seeded markets. Country names belong beside the area catalogue on the
/// server; this stands in until they are served, and falls back to the code.
const Map<String, String> _kCountryNames = {
  'SG': 'Singapore',
  'MY': 'Malaysia',
  'ID': 'Indonesia',
  'CN': 'China',
};

/// What an `(i)` next to a levelled section explains. Only levelled sections
/// get one -- an icon elsewhere promises a scale that does not exist.
class _ScaleGuide {
  const _ScaleGuide(this.scale, this.intro);

  final LevelScale scale;
  final String intro;

  /// Labels come from the scale itself, so the sheet and the chips cannot
  /// disagree about what a level means.
  List<String> get points => [
        intro,
        for (var level = LevelScaleX.minLevel;
            level <= LevelScaleX.maxLevel;
            level++)
          '${scale.prefix}$level — ${scale.labelFor(level)}',
      ];
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon, this.guide});

  final String title;
  final IconData icon;
  final _ScaleGuide? guide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Const.tosca),
        const SizedBox(width: 8),
        Flexible(child: Text(title, style: ProText.sectionTitle)),
        if (guide != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showGuidanceSheet(
              context,
              title: title,
              points: guide!.points,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: Const.contentTextColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _ShowAllToggle extends StatelessWidget {
  const _ShowAllToggle({
    required this.expanded,
    required this.total,
    required this.onTap,
  });

  final bool expanded;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          expanded ? 'Show less' : 'Show all $total',
          style: const TextStyle(
            color: Const.aqua,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// A titled block of chips that collapses past [_kVisibleChips].
class _ChipSection extends StatefulWidget {
  const _ChipSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.emptyText,
    this.guide,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final String emptyText;
  final _ScaleGuide? guide;

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
          _SectionHeader(
            title: widget.title,
            icon: widget.icon,
            guide: widget.guide,
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
            _ShowAllToggle(
              expanded: _expanded,
              total: widget.items.length,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
        ],
      ),
    );
  }
}

/// Districts read as a flat wall of names, so they are grouped under the
/// country and the region above them.
class _ServiceAreaSection extends StatefulWidget {
  const _ServiceAreaSection({required this.areas, required this.countryCode});

  final List<ServiceArea> areas;
  final String countryCode;

  @override
  State<_ServiceAreaSection> createState() => _ServiceAreaSectionState();
}

class _ServiceAreaSectionState extends State<_ServiceAreaSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasMore = widget.areas.length > _kVisibleChips;
    final shown = _expanded || !hasMore
        ? widget.areas
        : widget.areas.take(_kVisibleChips).toList();
    final country = widget.countryCode.isEmpty
        ? null
        : _kCountryNames[widget.countryCode.toUpperCase()] ??
            widget.countryCode.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Service Area', icon: Icons.map_outlined),
          const SizedBox(height: 10),
          if (country != null) ...[
            Text(country, style: ProText.bodyStrong),
            const SizedBox(height: 8),
          ],
          for (final region in _byRegion(shown))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (region.key.isNotEmpty) ...[
                    Text(region.key, style: ProText.hint),
                    const SizedBox(height: 6),
                  ],
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final area in region.value)
                        ProfileChip(label: area.name, filled: true)
                    ],
                  ),
                ],
              ),
            ),
          if (hasMore)
            _ShowAllToggle(
              expanded: _expanded,
              total: widget.areas.length,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
        ],
      ),
    );
  }

  /// Areas with no parent fall into one unnamed group, kept last.
  static List<MapEntry<String, List<ServiceArea>>> _byRegion(
    List<ServiceArea> areas,
  ) {
    final groups = <String, List<ServiceArea>>{};
    for (final area in areas) {
      groups.putIfAbsent(area.parentName ?? '', () => []).add(area);
    }

    return groups.entries.toList()
      ..sort((a, b) {
        if (a.key.isEmpty) return 1;
        if (b.key.isEmpty) return -1;
        return a.key.compareTo(b.key);
      });
  }
}

/// Care DNA is the thing that tells two nurses apart, but it is long. The
/// header carries a preview so the row is not a blind door.
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
    final chips = widget.summary.summaryChips(perCategory: 1)
      ..remove(widget.summary.role);
    final preview = chips.take(3).join(' · ');
    final remaining = chips.length - 3;

    return Container(
      decoration: BoxDecoration(
        color: Const.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.fingerprint, size: 20, color: Const.tosca),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Care DNA', style: ProText.bodyStrong),
                        if (preview.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            remaining > 0
                                ? '$preview  +$remaining more'
                                : preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ProText.hint,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 22,
                    color: Const.tosca,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            const SizedBox(height: 12),
            ProfileHighlightSections(summary: widget.summary),
          ],
        ],
      ),
    );
  }
}
