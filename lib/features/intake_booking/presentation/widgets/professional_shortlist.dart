import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';

/// The ranked professionals to choose from. Tapping "Select" echoes the
/// candidate's backend token. Once a choice is made, it's highlighted and the
/// rest are disabled.
class ProfessionalShortlist extends StatelessWidget {
  final ProfessionalShortlistBlock block;
  final bool active;
  final String? chosenSelectId;
  final ValueChanged<String>? onReply;

  const ProfessionalShortlist({
    super.key,
    required this.block,
    required this.active,
    this.chosenSelectId,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: block.candidates.map((c) {
          final resolved = chosenSelectId != null;
          return _ProfessionalCard(
            candidate: c,
            selected: chosenSelectId == c.selectId,
            dimmed: resolved && chosenSelectId != c.selectId,
            enabled: active,
            onSelect: () => onReply?.call(c.selectId),
          );
        }).toList(),
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final CandidateOption candidate;
  final bool selected;
  final bool dimmed;
  final bool enabled;
  final VoidCallback onSelect;

  const _ProfessionalCard({
    required this.candidate,
    required this.selected,
    required this.dimmed,
    required this.enabled,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Const.aqua : const Color(0xFFE6E9F2),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFF1F3F8),
              child: Icon(Icons.person, color: Const.aqua),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF232F55),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB020)),
                      const SizedBox(width: 2),
                      Text(
                        candidate.ratingAvg?.toStringAsFixed(1) ?? '—',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF5A6485)),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.place_outlined, size: 14, color: Color(0xFF8A96BC)),
                      const SizedBox(width: 2),
                      Text(
                        '${candidate.distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF5A6485)),
                      ),
                    ],
                  ),
                  if (candidate.languages.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      candidate.languages.join(', '),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF8A96BC)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            selected
                ? const _SelectedPill()
                : SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: enabled ? onSelect : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Select'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _SelectedPill extends StatelessWidget {
  const _SelectedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Const.aqua.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Const.aqua),
          SizedBox(width: 4),
          Text('Selected', style: TextStyle(color: Const.aqua, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
