import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_sessions_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_sessions_state.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

class AssistantSessionsPage extends StatelessWidget {
  const AssistantSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    return Scaffold(
      backgroundColor: AssistantPalette.canvas,
      appBar: AppBar(
        backgroundColor: AssistantPalette.surface,
        surfaceTintColor: AssistantPalette.surface,
        elevation: 0,
        title: Text(
          t.historyTitle,
          style: const TextStyle(
            color: AssistantPalette.navy,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AssistantPalette.navy),
      ),
      body: BlocBuilder<AssistantSessionsCubit, AssistantSessionsState>(
        builder: (context, state) => switch (state) {
          AssistantSessionsLoading() => const Center(
              child: CircularProgressIndicator(
                color: AssistantPalette.primary,
              ),
            ),
          AssistantSessionsFailed() => _Failed(message: t.historyError),
          AssistantSessionsLoaded(:final sessions) => sessions.isEmpty
              ? Center(
                  child: Text(
                    t.historyEmpty,
                    style: const TextStyle(color: AssistantPalette.muted),
                  ),
                )
              : ListView.separated(
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final current =
                        context.read<AssistantSessionsCubit>().currentSessionId;
                    return _SessionTile(
                      session: session,
                      isCurrent: session.id == current,
                      onTap: () =>
                          Navigator.pop<AssistantSession>(context, session),
                      onDelete: () => context
                          .read<AssistantSessionsCubit>()
                          .delete(session.id),
                    );
                  },
                ),
        },
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  final String message;

  const _Failed({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AssistantPalette.body),
          ),
          TextButton(
            onPressed: () => context.read<AssistantSessionsCubit>().load(),
            child: Text(
              context.t.chatbot.retry,
              style: const TextStyle(
                color: AssistantPalette.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final AssistantSession session;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionTile({
    required this.session,
    required this.isCurrent,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    final tile = ListTile(
      tileColor: AssistantPalette.surface,
      title: Text(
        session.preview ?? t.sessionUntitled,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AssistantPalette.navy,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isCurrent ? t.sessionActive : t.sessionReadOnly,
        style: TextStyle(
          color: isCurrent ? AssistantPalette.primary : AssistantPalette.muted,
          fontSize: 12,
          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: Text(
        _date,
        style: const TextStyle(color: AssistantPalette.muted, fontSize: 12),
      ),
      onTap: onTap,
    );

    if (isCurrent) return tile;

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

  String get _date {
    final local = session.updatedAt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final t = context.t.chatbot;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.deleteTitle),
        content: Text(t.deleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
