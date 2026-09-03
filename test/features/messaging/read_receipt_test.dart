import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/messaging/domain/entities/chat_message.dart';
import 'package:m2health/features/messaging/domain/entities/estimate_revision.dart';
import 'package:m2health/features/messaging/domain/entities/message_thread.dart';
import 'package:m2health/features/messaging/domain/entities/time_proposal.dart';
import 'package:m2health/features/messaging/domain/repositories/messaging_repository.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_cubit.dart';
import 'package:m2health/features/messaging/presentation/widgets/chat_bubble.dart';
import 'package:m2health/features/messaging/presentation/widgets/thread_view.dart';
import 'package:m2health/i18n/translations.g.dart';

const int _me = 900;
const int _them = 901;

ChatMessage _message(int id, int author) => ChatMessage(
      id: id,
      threadId: 1,
      kind: MessageKind.text,
      body: 'message $id',
      authorUserId: author,
      createdAt: DateTime(2026, 9, 4, 10, id),
    );

/// Three of mine and one of theirs, so "the last one I sent" is a real choice.
final _transcript = [
  _message(1, _me),
  _message(2, _them),
  _message(3, _me),
  _message(4, _me),
];

class _StubRepository implements MessagingRepository {
  final int? readUpTo;

  _StubRepository(this.readUpTo);

  @override
  Future<Either<Failure, ChatMessagePage>> loadMessages(int threadId) async =>
      Right(ChatMessagePage(
        messages: _transcript,
        readUpToMessageId: readUpTo,
      ));

  @override
  Future<Either<Failure, int>> markRead(
          int threadId, int lastMessageId) async =>
      const Right(0);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Future<List<int>> _markedBubbleIds(WidgetTester tester, int? readUpTo) async {
  tester.view.physicalSize = const Size(400, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (_) => ThreadCubit(_StubRepository(readUpTo), 1)..load(),
          child: const ThreadView(
            counterpartUserId: _them,
            canRespondToCards: true,
            counterpartName: 'Aisyah',
          ),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();

  return tester
      .widgetList<ChatBubble>(find.byType(ChatBubble))
      .where((b) => b.read)
      .map((b) => b.message.id)
      .toList();
}

void main() {
  testWidgets('only the last message I sent carries the marker',
      (tester) async {
    // They have read everything.
    expect(await _markedBubbleIds(tester, 4), [4]);
  });

  testWidgets('a cursor short of my last message marks nothing',
      (tester) async {
    // They read up to their own line, so my 3 and 4 are still unread. The
    // marker never lands on an earlier message of mine — it would read as
    // "they saw this one" about the wrong sentence.
    expect(await _markedBubbleIds(tester, 2), isEmpty);
  });

  testWidgets('nobody having read anything marks nothing', (tester) async {
    expect(await _markedBubbleIds(tester, null), isEmpty);
  });
}
