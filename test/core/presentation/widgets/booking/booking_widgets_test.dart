import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The shared widgets read chrome strings from the sharedBooking namespace, so
/// they need a TranslationProvider above them — same as the real app.
Future<void> pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
}

void main() {
  group('PricePill', () {
    testWidgets('renders each variant', (tester) async {
      await pump(
        tester,
        const Column(
          children: [
            PricePill(amount: 80),
            PricePill(amount: 95, variant: PricePillVariant.from),
            PricePill(amount: 12.5, variant: PricePillVariant.exact),
          ],
        ),
      );

      expect(find.text(r'Starting from $80'), findsOneWidget);
      expect(find.text(r'from $95'), findsOneWidget);
      expect(find.text(r'$12.50'), findsOneWidget);
    });
  });

  group('BookingStepHeader', () {
    testWidgets('shows the title and the subtitle', (tester) async {
      await pump(
        tester,
        const BookingStepHeader(
          title: 'What can we help you with?',
          subtitle: 'Choose one or more.',
        ),
      );

      expect(find.text('What can we help you with?'), findsOneWidget);
      expect(find.text('Choose one or more.'), findsOneWidget);
    });

    testWidgets('carries no step counter', (tester) async {
      await pump(tester, const BookingStepHeader(title: 'Add-on services'));

      expect(find.text('Add-on services'), findsOneWidget);
      expect(find.textContaining('Step'), findsNothing);
    });
  });

  group('SelectionChip', () {
    testWidgets('reports taps and ignores them when disabled', (tester) async {
      var taps = 0;
      await pump(
        tester,
        Column(
          children: [
            SelectionChip(
              label: 'Medication Support',
              selected: true,
              onTap: () => taps++,
            ),
            const SelectionChip(label: 'Quit Smoking', selected: false),
          ],
        ),
      );

      await tester.tap(find.text('Medication Support'));
      await tester.tap(find.text('Quit Smoking'));

      expect(taps, 1);
    });
  });

  group('MultiSelectListTile', () {
    testWidgets('toggles from the row as well as the checkbox', (tester) async {
      bool? received;
      await pump(
        tester,
        MultiSelectListTile(
          title: 'Medication review',
          subtitle: 'A pharmacist checks everything you take',
          selected: false,
          onChanged: (value) => received = value,
          trailing: const PricePill(amount: 40, dense: true),
        ),
      );

      await tester.tap(find.text('Medication review'));
      expect(received, isTrue);
    });
  });

  group('StickyBottomCta', () {
    testWidgets('disables the primary action when onPressed is null',
        (tester) async {
      await pump(tester, const StickyBottomCta(label: 'Continue'));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('swaps the label for a spinner while loading', (tester) async {
      await pump(
        tester,
        StickyBottomCta(
          label: 'Send request',
          isLoading: true,
          onPressed: () {},
        ),
      );

      expect(find.text('Send request'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('StatusPill', () {
    testWidgets('labels every flow state', (tester) async {
      await pump(
        tester,
        const Column(
          children: [
            StatusPill(tone: BookingStatusTone.pending),
            StatusPill(tone: BookingStatusTone.confirmed),
            StatusPill(tone: BookingStatusTone.proposed),
            StatusPill(tone: BookingStatusTone.cancelled),
          ],
        ),
      );

      expect(find.text('Pending approval'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Alternative proposed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
    });
  });

  group('async states', () {
    testWidgets('empty and error fall back to shared copy', (tester) async {
      await pump(tester, const BookingEmptyState());
      expect(find.text('Nothing here yet'), findsOneWidget);

      await pump(tester, BookingErrorState(onRetry: () {}));
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('loading shows a spinner', (tester) async {
      await pump(tester, const BookingLoadingState(message: 'Finding nurses'));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Finding nurses'), findsOneWidget);
    });
  });
}
