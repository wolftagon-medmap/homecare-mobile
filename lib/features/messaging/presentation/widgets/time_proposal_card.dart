import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';

import '../../domain/entities/time_proposal.dart';

/// The `time_proposal` action card.
///
/// It renders a record, it does not hold one. Buttons appear only while the
/// proposal is genuinely open and only for the patient — the professional who
/// raised it sees the same card with its current status and nothing to press.
class TimeProposalCard extends StatefulWidget {
  final TimeProposal proposal;

  /// Patients act on a proposal; the professional who made it watches it.
  final bool canRespond;
  final VoidCallback? onAccept;
  final VoidCallback? onChooseAnother;
  final bool busy;

  const TimeProposalCard({
    super.key,
    required this.proposal,
    required this.canRespond,
    this.onAccept,
    this.onChooseAnother,
    this.busy = false,
  });

  @override
  State<TimeProposalCard> createState() => _TimeProposalCardState();
}

class _TimeProposalCardState extends State<TimeProposalCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // The TTL is the whole point of the card — a countdown that only moves on
    // rebuild would quietly lie about how long is left.
    if (widget.proposal.isOpen) {
      _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proposal = widget.proposal;
    final open = proposal.isOpen;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: open ? Const.aqua : Const.borderSubtle),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_repeat, size: 18, color: Const.aqua),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Alternative time proposed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Const.primaryTextColor,
                  ),
                ),
              ),
              _StatusTag(proposal: proposal),
            ],
          ),
          const SizedBox(height: 14),
          if (proposal.originalStart != null) ...[
            _SlotLine(
              label: 'You asked for',
              start: proposal.originalStart!,
              end: proposal.originalEnd,
              strikethrough: true,
            ),
            const SizedBox(height: 6),
          ],
          _SlotLine(
            label: 'Proposed',
            start: proposal.proposedStart,
            end: proposal.proposedEnd,
            emphasise: true,
          ),
          if (proposal.reason != null && proposal.reason!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Const.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                proposal.reason!,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey[800], height: 1.35),
              ),
            ),
          ],
          if (open && proposal.timeLeft != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer_outlined,
                    size: 15, color: Colors.deepOrange),
                const SizedBox(width: 5),
                Text(
                  context.t.messaging.timeProposal
                      .answerBy(when: _deadline(context, proposal.expiresAt!)),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (open && widget.canRespond) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.busy ? null : widget.onChooseAnother,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Const.tosca),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                    onPressed: widget.busy ? null : widget.onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Const.aqua,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Accept',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// The slot is only held briefly; the proposal itself stands until the time
  /// it proposes, which can be days away. So this is a deadline, not a
  /// countdown — a ticking clock would misrepresent both.
  static String _deadline(BuildContext context, DateTime at) {
    final t = context.t.messaging.timeProposal;
    final local = at.toLocal();
    final clock = DateFormat('HH:mm').format(local);

    final today = DateTime.now();
    final midnight = DateTime(today.year, today.month, today.day);
    final days = DateTime(local.year, local.month, local.day)
        .difference(midnight)
        .inDays;

    if (days == 0) return '${t.today} $clock';
    if (days == 1) return '${t.tomorrow} $clock';
    return '${DateFormat('EEE d MMM').format(local)} $clock';
  }
}

class _SlotLine extends StatelessWidget {
  final String label;
  final DateTime start;
  final DateTime? end;
  final bool strikethrough;
  final bool emphasise;

  const _SlotLine({
    required this.label,
    required this.start,
    this.end,
    this.strikethrough = false,
    this.emphasise = false,
  });

  @override
  Widget build(BuildContext context) {
    final local = start.toLocal();
    final range = end == null
        ? DateFormat('HH:mm').format(local)
        : '${DateFormat('HH:mm').format(local)} - '
            '${DateFormat('HH:mm').format(end!.toLocal())}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            '${DateFormat('EEE, d MMM').format(local)}  ·  $range',
            style: TextStyle(
              fontSize: emphasise ? 15 : 13,
              fontWeight: emphasise ? FontWeight.w700 : FontWeight.w500,
              color: strikethrough ? Colors.grey[500] : Const.primaryTextColor,
              decoration: strikethrough ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusTag extends StatelessWidget {
  final TimeProposal proposal;

  const _StatusTag({required this.proposal});

  @override
  Widget build(BuildContext context) {
    if (proposal.isOpen) {
      return const StatusPill(tone: BookingStatusTone.proposed, dense: true);
    }
    final (label, tone) = switch (proposal.status) {
      TimeProposalStatus.accepted => ('Accepted', BookingStatusTone.confirmed),
      TimeProposalStatus.declined => ('Declined', BookingStatusTone.info),
      TimeProposalStatus.withdrawn => ('Withdrawn', BookingStatusTone.info),
      TimeProposalStatus.expired => ('Expired', BookingStatusTone.cancelled),
      TimeProposalStatus.pending => ('Expired', BookingStatusTone.cancelled),
    };
    return StatusPill(tone: tone, label: label, dense: true);
  }
}
