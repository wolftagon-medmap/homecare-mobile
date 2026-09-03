import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/domain/repositories/intake_repository.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/block_view.dart';
import 'package:m2health/service_locator.dart';

/// Read-only transcript of a previous booking conversation. No SSE, no
/// composer; interactive blocks render inert (isLast is never true).
class IntakeSessionViewerPage extends StatefulWidget {
  final String sessionId;

  const IntakeSessionViewerPage({super.key, required this.sessionId});

  @override
  State<IntakeSessionViewerPage> createState() =>
      _IntakeSessionViewerPageState();
}

class _IntakeSessionViewerPageState extends State<IntakeSessionViewerPage> {
  late Future<List<Block>> _history;

  @override
  void initState() {
    super.initState();
    _history = sl<IntakeRepository>().fetchHistory(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Previous Conversation',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<Block>>(
        future: _history,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Const.aqua),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load this conversation.'),
                  TextButton(
                    onPressed: () => setState(() {
                      _history =
                          sl<IntakeRepository>().fetchHistory(widget.sessionId);
                    }),
                    child: const Text('Retry',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }
          final blocks = snapshot.data ?? const <Block>[];
          if (blocks.isEmpty) {
            return const Center(
              child: Text('This conversation is empty.',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: const Text(
                  'Read-only — this conversation has ended.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: blocks.length,
                  itemBuilder: (context, index) =>
                      BlockView(block: blocks[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
