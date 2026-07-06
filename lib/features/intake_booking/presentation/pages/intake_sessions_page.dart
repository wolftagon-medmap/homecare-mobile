import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/domain/entities/session_summary.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_sessions_cubit.dart';

/// Booking-chat session history: the active session plus read-only previous
/// ones (swipe to delete). Pops the tapped [IntakeSessionSummary] so the chat
/// page decides how to open it.
class IntakeSessionsPage extends StatelessWidget {
  const IntakeSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation History')),
      body: BlocBuilder<IntakeSessionsCubit, IntakeSessionsState>(
        builder: (context, state) {
          switch (state) {
            case IntakeSessionsLoading():
              return const Center(
                child: CircularProgressIndicator(color: Const.aqua),
              );
            case IntakeSessionsError(:final message):
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () =>
                          context.read<IntakeSessionsCubit>().load(),
                      child: const Text('Retry',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            case IntakeSessionsLoaded(:final sessions):
              if (sessions.isEmpty) {
                return const Center(
                  child: Text(
                    'No conversations yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return ListView.separated(
                itemCount: sessions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return _SessionTile(
                    session: session,
                    onTap: () =>
                        Navigator.pop<IntakeSessionSummary>(context, session),
                    onDelete: () =>
                        context.read<IntakeSessionsCubit>().delete(session.id),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final IntakeSessionSummary session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionTile({
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: Text(
        session.preview ?? 'Booking conversation',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: session.active
          ? const Text('Active',
              style: TextStyle(
                  color: Const.aqua, fontSize: 12, fontWeight: FontWeight.w600))
          : const Text('Read-only',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: _date != null
          ? Text(
              _date!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
          : null,
      onTap: onTap,
    );

    // The active session cannot be deleted — no swipe action for it.
    if (session.active) return tile;

    return Dismissible(
      key: ValueKey(session.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: tile,
    );
  }

  String? get _date {
    final at = session.lastMessageAt ?? session.createdAt;
    if (at == null) return null;
    final local = at.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete conversation'),
        content: const Text(
            'Are you sure you want to delete this conversation? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
