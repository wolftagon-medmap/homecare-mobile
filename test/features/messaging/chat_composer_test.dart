import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/messaging/presentation/widgets/chat_composer.dart';
import 'package:m2health/i18n/translations.g.dart';

Widget _host(Widget child) => TranslationProvider(
      child: MaterialApp(home: Scaffold(bottomNavigationBar: child)),
    );

void main() {
  testWidgets('actions live behind the + rather than in a row of pills',
      (tester) async {
    var raised = false;

    await tester.pumpWidget(_host(ChatComposer(
      onSend: (_) {},
      actions: [
        ComposerAction(
          icon: Icons.event_repeat,
          label: 'Suggest another time',
          onTap: () => raised = true,
        ),
      ],
    )));

    // Nothing on the bar itself — the label only exists inside the sheet.
    expect(find.text('Suggest another time'), findsNothing);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Suggest another time'), findsOneWidget);

    await tester.tap(find.text('Suggest another time'));
    await tester.pumpAndSettle();
    expect(raised, isTrue);
  });

  testWidgets('a role with no actions gets no + at all', (tester) async {
    await tester.pumpWidget(_host(ChatComposer(onSend: (_) {})));

    expect(find.byIcon(Icons.add_rounded), findsNothing);
  });

  testWidgets('a picked opener fills the field instead of sending',
      (tester) async {
    var sent = 0;

    await tester.pumpWidget(_host(
      ChatComposer(onSend: (_) => sent++),
    ));
    await tester.pumpWidget(_host(
      ChatComposer(onSend: (_) => sent++, draft: 'When would suit you?'),
    ));
    await tester.pump();

    expect(find.text('When would suit you?'), findsOneWidget);
    expect(sent, 0);
  });
}
