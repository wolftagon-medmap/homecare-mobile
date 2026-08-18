import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';

/// The entry pattern for leveled catalogues.
///
/// The PRD asks a professional for roughly 66 leveled data points. Rendered as
/// 66 dropdowns nobody finishes the form, so this splits the work in two: tap
/// chips to claim the handful that apply (fast), then rate only those. Anything
/// unclaimed stays at level 0 and never needs to be touched.
class SelectThenRate extends StatelessWidget {
  const SelectThenRate({
    super.key,
    required this.tags,
    required this.scale,
    required this.onChanged,
    this.emptyHint = 'Nothing selected yet — tap above to add.',
  });

  final List<LeveledTag> tags;
  final LevelScale scale;
  final ValueChanged<List<LeveledTag>> onChanged;
  final String emptyHint;

  void _setLevel(String id, int level) {
    onChanged([
      for (final t in tags)
        if (t.id == id) t.copyWith(level: level) else t,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final claimed = tags.where((t) => t.isClaimed).toList();
    final available = tags.where((t) => !t.isClaimed).toList();
    final groups = <String?, List<LeveledTag>>{};
    for (final t in available) {
      groups.putIfAbsent(t.group, () => []).add(t);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in groups.entries) ...[
          if (entry.key != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                entry.key!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in entry.value)
                _AddChip(label: t.label, onTap: () => _setLevel(t.id, 3)),
            ],
          ),
          const SizedBox(height: 16),
        ],
        const Divider(height: 24),
        Text(
          'Your selection',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        if (claimed.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              emptyHint,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          )
        else
          for (final t in claimed)
            _RatedRow(
              tag: t,
              scale: scale,
              onLevel: (lvl) => _setLevel(t.id, lvl),
              onRemove: () => _setLevel(t.id, 0),
            ),
      ],
    );
  }
}

class _AddChip extends StatelessWidget {
  const _AddChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatedRow extends StatelessWidget {
  const _RatedRow({
    required this.tag,
    required this.scale,
    required this.onLevel,
    required this.onRemove,
  });

  final LeveledTag tag;
  final LevelScale scale;
  final ValueChanged<int> onLevel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tag.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Text(
                '${scale.prefix}${tag.level} · ${scale.labelFor(tag.level)}',
                style: const TextStyle(
                  color: Const.tosca,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close, size: 16),
                color: Colors.grey.shade500,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(left: 12),
                tooltip: 'Remove',
              ),
            ],
          ),
          const SizedBox(height: 6),
          LevelPills(level: tag.level, onChanged: onLevel),
        ],
      ),
    );
  }
}

/// A 1-5 selector sized for a thumb rather than a dropdown.
class LevelPills extends StatelessWidget {
  const LevelPills({super.key, required this.level, required this.onChanged});

  final int level;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                margin: EdgeInsets.only(right: i == 5 ? 0 : 6),
                height: 30,
                decoration: BoxDecoration(
                  color: i <= level ? Const.aqua : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: i <= level ? Const.aqua : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$i',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: i <= level ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Unleveled multi-select, used for style traits and service areas.
class TagMultiSelect extends StatelessWidget {
  const TagMultiSelect({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          GestureDetector(
            onTap: () {
              final next = [...selected];
              next.contains(o) ? next.remove(o) : next.add(o);
              onChanged(next);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected.contains(o) ? Const.aqua : Colors.transparent,
                border: Border.all(
                  color:
                      selected.contains(o) ? Const.aqua : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected.contains(o) ? Icons.check : Icons.add,
                    size: 14,
                    color: selected.contains(o)
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    o,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected.contains(o)
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selected.contains(o)
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
