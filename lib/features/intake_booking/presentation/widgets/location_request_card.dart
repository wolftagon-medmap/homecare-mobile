import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/intake_bubbles.dart';

/// Prompts the patient to pick the visit location on a map. Tapping opens the
/// picker; once a location is sent, the button collapses to a confirmation.
class LocationRequestCard extends StatelessWidget {
  final LocationRequestBlock block;
  final bool active;
  final bool resolved;
  final VoidCallback? onPick;

  const LocationRequestCard({
    super.key,
    required this.block,
    required this.active,
    required this.resolved,
    this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssistantBubble(text: block.text),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: resolved ? _done() : _pickButton(),
        ),
      ],
    );
  }

  Widget _done() {
    return const Row(
      children: [
        Icon(Icons.check_circle, size: 18, color: Const.aqua),
        SizedBox(width: 6),
        Text('Location set', style: TextStyle(color: Color(0xFF5A6485), fontSize: 13)),
      ],
    );
  }

  Widget _pickButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: active ? onPick : null,
        icon: const Icon(Icons.map_outlined, size: 18),
        label: const Text('Set location on map'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Const.aqua,
          side: const BorderSide(color: Const.aqua),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
