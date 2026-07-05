import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/provider_inbox_cubit.dart';
import 'package:m2health/features/appointment/data/models/inbox_item.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';

/// The provider Pending tab (ADR-0006): the unified inbox of v1 pending
/// appointments + v2 care-task offers. Accepted/completed/cancelled stay on the
/// v1 appointment tabs.
class ProviderInboxTab extends StatelessWidget {
  const ProviderInboxTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderInboxCubit, ProviderInboxState>(
      listener: (context, state) {
        if (state is ProviderInboxActionSucceed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ));
          // An accepted offer materializes an appointment — refresh the other tabs.
          context.read<ProviderAppointmentCubit>().fetchProviderAppointments();
        } else if (state is ProviderInboxError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ));
        }
      },
      builder: (context, state) {
        if (state is ProviderInboxLoading || state is ProviderInboxInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProviderInboxError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<ProviderInboxCubit>().fetchInbox(),
          );
        }
        final items =
            state is ProviderInboxLoaded ? state.items : const <InboxItem>[];
        return RefreshIndicator(
          onRefresh: () => context.read<ProviderInboxCubit>().fetchInbox(),
          backgroundColor: Colors.white,
          color: Const.aqua,
          child: items.isEmpty
              ? _EmptyView()
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 64, top: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      _InboxCard(item: items[index]),
                ),
        );
      },
    );
  }
}

class _InboxCard extends StatelessWidget {
  final InboxItem item;
  const _InboxCard({required this.item});

  String get _date => item.scheduledStart == null
      ? ''
      : DateFormat('EEE, dd MMM yyyy').format(item.scheduledStart!.toLocal());

  String get _timeRange {
    final start = item.scheduledStart;
    if (start == null) return '';
    final startLabel = DateFormat('hh:mm a').format(start.toLocal());
    final end = item.scheduledEnd;
    if (end == null) return startLabel;
    return '$startLabel - ${DateFormat('hh:mm a').format(end.toLocal())}';
  }

  String? get _expiryLabel {
    final exp = item.expiresAt;
    if (exp == null) return null;
    final diff = exp.toLocal().difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    final minutes = diff.inMinutes;
    if (minutes < 60) return 'Expires in ${minutes}m';
    return 'Expires in ${diff.inHours}h ${minutes % 60}m';
  }

  @override
  Widget build(BuildContext context) {
    final accept = item.actionOfKind('accept');
    final decline = item.actionOfKind('decline');

    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, size: 28, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.serviceLabel,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      if (item.summary.patientLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.summary.patientLabel!,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
                _OriginBadge(isOffer: item.isOffer, risk: item.summary.risk),
              ],
            ),
            const SizedBox(height: 12),
            if (_date.isNotEmpty)
              _IconLine(icon: Icons.calendar_today, text: _date),
            if (_timeRange.isNotEmpty)
              _IconLine(icon: Icons.access_time, text: _timeRange),
            if (item.summary.location != null)
              _IconLine(icon: Icons.location_on_outlined, text: item.summary.location!),
            if (item.summary.service != null &&
                item.summary.service!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.summary.service!,
                    style: const TextStyle(fontSize: 14)),
              ),
            ],
            if (_expiryLabel != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 16, color: Colors.deepOrange),
                  const SizedBox(width: 4),
                  Text(
                    _expiryLabel!,
                    style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                item.estimatedIncome != null
                    ? Text(
                        'Est. income: \$${item.estimatedIncome!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF35C5CF),
                        ),
                      )
                    : const SizedBox.shrink(),
                Row(
                  children: [
                    if (decline != null)
                      ElevatedButton(
                        onPressed: () => _onDecline(context, decline),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 36),
                        ),
                        child: const Text('Decline'),
                      ),
                    if (accept != null) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _onAccept(context, accept),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Const.aqua,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 36),
                        ),
                        child: const Text('Accept'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onAccept(BuildContext context, InboxAction action) {
    _confirm(
      context,
      title: 'Accept this request?',
      confirmLabel: 'Accept',
      confirmColor: Const.aqua,
      onConfirm: () => context.read<ProviderInboxCubit>().respond(item, action),
    );
  }

  void _onDecline(BuildContext context, InboxAction action) {
    if (action.requiresReason) {
      showDialog(
        context: context,
        builder: (_) => CancelAppoinmentDialog(
          title: 'Are you sure you want to decline this request?',
          subtitle: 'This action cannot be undone.',
          onPressYes: (selection) {
            context.read<ProviderInboxCubit>().respond(
                  item,
                  action,
                  cancellationReason: selection.cancellationReason,
                  otherReason: selection.otherReason,
                );
          },
        ),
      );
    } else {
      _confirm(
        context,
        title: 'Decline this request?',
        confirmLabel: 'Decline',
        confirmColor: Colors.red,
        onConfirm: () =>
            context.read<ProviderInboxCubit>().respond(item, action),
      );
    }
  }

  void _confirm(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}

class _OriginBadge extends StatelessWidget {
  final bool isOffer;
  final String? risk;
  const _OriginBadge({required this.isOffer, this.risk});

  @override
  Widget build(BuildContext context) {
    final highRisk = risk == 'high';
    final color = highRisk ? Colors.red : (isOffer ? Const.aqua : Colors.orange);
    final label = highRisk ? 'High risk' : (isOffer ? 'AI offer' : 'Request');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('No pending requests',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
