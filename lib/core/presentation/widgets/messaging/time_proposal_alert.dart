import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';

/// The inbox-card form of a time proposal.
///
/// The same record as the `time_proposal` chat card, answered from the list
/// rather than from the conversation — accepting a time is a decision, and a
/// decision should not require reading a thread first. Both routes write to the
/// same proposal.
class TimeProposalAlert extends StatelessWidget {
  final DateTime? proposedStart;
  final DateTime? proposedEnd;
  final DateTime? originalStart;
  final DateTime? expiresAt;
  final String? reason;
  final String? professionalName;
  final VoidCallback onAccept;
  final VoidCallback onChooseAnother;

  const TimeProposalAlert({
    super.key,
    required this.proposedStart,
    required this.proposedEnd,
    required this.originalStart,
    required this.expiresAt,
    required this.reason,
    required this.professionalName,
    required this.onAccept,
    required this.onChooseAnother,
  });

  @override
  Widget build(BuildContext context) {
    if (proposedStart == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Const.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Const.primaryBlue.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event_repeat, size: 17, color: Const.primaryBlue),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Alternative time proposed',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Const.primaryTextColor,
                  ),
                ),
              ),
              StatusPill(tone: BookingStatusTone.proposed, dense: true),
            ],
          ),
          const SizedBox(height: 10),
          if (originalStart != null)
            Text(
              _format(originalStart!),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
            ),
          Text(
            _format(proposedStart!, end: proposedEnd),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Const.primaryTextColor,
            ),
          ),
          if (reason != null && reason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '"${reason!}"'
              '${professionalName != null ? ' — $professionalName' : ''}',
              style: TextStyle(
                  fontSize: 12, color: Colors.grey[700], height: 1.35),
            ),
          ],
          if (_expiry != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_outlined,
                    size: 14, color: Colors.deepOrange),
                const SizedBox(width: 4),
                Text(
                  _expiry!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onChooseAnother,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Const.tosca),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Choose Another',
                    style: TextStyle(
                        color: Const.tosca,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Const.aqua,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? get _expiry {
    if (expiresAt == null) return null;
    final left = expiresAt!.difference(DateTime.now());
    if (left.isNegative) return 'This suggestion has expired';
    if (left.inMinutes < 60) return 'Held for ${left.inMinutes} more minutes';
    return 'Held for ${left.inHours}h ${left.inMinutes % 60}m';
  }

  static String _format(DateTime start, {DateTime? end}) {
    final local = start.toLocal();
    final range = end == null
        ? DateFormat('HH:mm').format(local)
        : '${DateFormat('HH:mm').format(local)} - '
            '${DateFormat('HH:mm').format(end.toLocal())}';
    return '${DateFormat('EEE, d MMM').format(local)}  ·  $range';
  }
}
