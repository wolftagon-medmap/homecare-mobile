import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:m2health/features/appointment/widgets/booking_card.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';

Widget _host(Widget child) => BlocProvider(
      create: (_) => LocaleCubit(),
      child: MaterialApp(home: Scaffold(body: child)),
    );

Widget _card(String statusLabel) => BookingCard(
      title: 'Grace Tan',
      subtitle: 'Physiotherapist',
      statusLabel: statusLabel,
      statusColor: const Color(0xFFE59500),
      scheduledStart: DateTime(2026, 9, 10, 9),
      priceLabel: r'Est. $30.00',
      actions: [ElevatedButton(onPressed: () {}, child: const Text('Chat'))],
    );

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  /// A narrow phone, so the subtitle and the status have to share one line.
  void useNarrowPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('the longest status does not squeeze out the subtitle',
      (tester) async {
    useNarrowPhone(tester);

    await tester.pumpWidget(_host(_card('Pending')));
    final roomy = tester.getSize(find.text('Physiotherapist')).width;

    await tester.pumpWidget(_host(_card('No professional available')));
    final tight = tester.getSize(find.text('Physiotherapist')).width;

    expect(tester.takeException(), isNull);
    expect(find.text('No professional available'), findsOneWidget);
    // The status chip used to take the whole line and cut the job title down
    // to an ellipsis, so the two widths had to differ.
    expect(tight, roomy);
  });

  testWidgets('a card with no actions renders no action row', (tester) async {
    await tester.pumpWidget(_host(
      const BookingCard(
        title: 'Physiotherapy',
        statusLabel: 'Awaiting confirmation',
        statusColor: Color(0xFFE59500),
      ),
    ));

    expect(tester.takeException(), isNull);
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
