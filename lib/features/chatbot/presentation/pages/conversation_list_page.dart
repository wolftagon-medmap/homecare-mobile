import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/conversation.dart';
import 'package:m2health/features/chatbot/presentation/bloc/conversation_list_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/conversation_list_state.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationListCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations History'),
      ),
      body: BlocBuilder<ConversationListCubit, ConversationListState>(
        builder: (context, state) {
          switch (state) {
            case ConversationListLoading():
              return const Center(
                child: CircularProgressIndicator(color: Const.aqua),
              );
            case ConversationListError(:final message):
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () =>
                          context.read<ConversationListCubit>().load(),
                      child: const Text('Retry',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            case ConversationListLoaded(:final conversations):
              if (conversations.isEmpty) {
                return const Center(
                  child: Text(
                    'No conversations yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return _ConversationTile(
                    conversation: conversations[index],
                    onTap: () => context.pop<int>(conversations[index].id),
                    onDelete: () => context
                        .read<ConversationListCubit>()
                        .delete(conversations[index].id),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationSummary conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        title: Text(
          conversation.title ?? 'Untitled conversation',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: conversation.preview != null
            ? Text(
                conversation.preview!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: conversation.lastMessageAt != null
            ? Text(
                _formatDate(conversation.lastMessageAt!),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            : null,
        onTap: onTap,
      ),
    );
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

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }
}
