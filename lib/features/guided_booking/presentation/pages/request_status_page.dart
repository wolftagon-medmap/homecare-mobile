import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/usecases/guided_booking_usecases.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// Display only. `time_proposed` is A2's state machine — this screen renders
/// the four tones and never transitions one.
class RequestStatusPage extends StatefulWidget {
  const RequestStatusPage({super.key, required this.requestId});

  final int requestId;

  @override
  State<RequestStatusPage> createState() => _RequestStatusPageState();
}

class _RequestStatusPageState extends State<RequestStatusPage> {
  late Future<SubmittedRequest?> _request;

  @override
  void initState() {
    super.initState();
    _request = _load();
  }

  Future<SubmittedRequest?> _load() async {
    final result = await sl<GetBookingRequest>()(widget.requestId);
    return result.fold((_) => null, (request) => request);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.status;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<SubmittedRequest?>(
        future: _request,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const BookingLoadingState();
          }
          final request = snapshot.data;
          if (request == null) {
            return BookingErrorState(
              onRetry: () => setState(() => _request = _load()),
            );
          }
          return _StatusBody(request: request);
        },
      ),
    );
  }
}

class _StatusBody extends StatelessWidget {
  const _StatusBody({required this.request});

  final SubmittedRequest request;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.status;
    final name = request.professionalName ?? '';
    final format = DateFormat('EEE d MMM, HH:mm');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.reference(id: request.id),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            StatusPill(tone: _tone),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          t.submitted(date: format.format(request.submittedAt)),
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 18),
        Text(
          _body(context, name),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 22),
        if (request.preferredAt != null)
          _TimeRow(
            label: t.preferred,
            value: format.format(request.preferredAt!),
          ),
        if (request.proposedAt != null)
          _TimeRow(
            label: t.proposed,
            value: format.format(request.proposedAt!),
            highlight: true,
          ),
      ],
    );
  }

  BookingStatusTone get _tone => switch (request.status) {
        BookingRequestStatus.pendingApproval => BookingStatusTone.pending,
        BookingRequestStatus.confirmed => BookingStatusTone.confirmed,
        BookingRequestStatus.alternativeProposed => BookingStatusTone.proposed,
        BookingRequestStatus.cancelled => BookingStatusTone.cancelled,
      };

  String _body(BuildContext context, String name) {
    final t = context.t.guidedBooking.status;
    return switch (request.status) {
      BookingRequestStatus.pendingApproval => t.pending_body(name: name),
      BookingRequestStatus.confirmed => t.confirmed_body(name: name),
      BookingRequestStatus.alternativeProposed => t.proposed_body(name: name),
      BookingRequestStatus.cancelled => t.cancelled_body,
    };
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? Const.tosca.withValues(alpha: 0.08)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
