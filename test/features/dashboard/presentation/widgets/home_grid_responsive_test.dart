import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/presentation/responsive/responsive.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_layout.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid.dart';
import 'package:m2health/i18n/translations.g.dart';

const _screenWidths = [320.0, 375.0, 393.0, 430.0, 744.0, 834.0, 1024.0];
const _textScales = [1.0, 1.15, 1.3, 2.0];
const _gutter = 16.0;

Future<void> _loadPoppins() async {
  final loader = FontLoader('Poppins');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(rootBundle.load('assets/fonts/Poppins-$weight.ttf'));
  }
  await loader.load();
}

Future<void> _pumpGrid(WidgetTester tester, double width, double scale) async {
  tester.view.physicalSize = Size(width, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    TranslationProvider(
      child: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 1600),
          textScaler: TextScaler.linear(scale),
        ),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Poppins'),
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: _gutter),
              child: TextScaleCap(
                child: Builder(
                  builder: (context) {
                    final services = homeServiceViews(context);
                    final inner = (width - _gutter * 2)
                        .clamp(0.0, DashboardLayout.maxContentWidth);
                    return ServiceGrid(
                      services: services,
                      columns:
                          DashboardLayout.columnsFor(inner, services.length),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _expectTitlesKeepWholeWords(WidgetTester tester, String label) {
  final titles = find.byType(AutoSizeText);
  expect(titles, findsWidgets);

  for (final element in titles.evaluate()) {
    final title = (element.widget as AutoSizeText).data!;
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.byWidget(element.widget),
        matching: find.byType(RichText),
      ),
    );

    expect(paragraph.didExceedMaxLines, isFalse,
        reason: '$label: "$title" was cut off');

    final style = (paragraph.text as TextSpan).style;
    for (final word in title.split(' ')) {
      final painter = TextPainter(
        text: TextSpan(text: word, style: style),
        textScaler: paragraph.textScaler,
        textDirection: TextDirection.ltr,
      )..layout();
      expect(painter.width, lessThanOrEqualTo(paragraph.size.width + 0.5),
          reason: '$label: "$word" in "$title" breaks mid-word');
      painter.dispose();
    }
  }
}

void main() {
  setUpAll(_loadPoppins);

  for (final width in _screenWidths) {
    for (final scale in _textScales) {
      final label = '${width.toInt()}dp at ${scale}x';

      testWidgets('home grid holds together at $label', (tester) async {
        await _pumpGrid(tester, width, scale);

        expect(tester.takeException(), isNull, reason: label);
        _expectTitlesKeepWholeWords(tester, label);
      });
    }
  }
}
