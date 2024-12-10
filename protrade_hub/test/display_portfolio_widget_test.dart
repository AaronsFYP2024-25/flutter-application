import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/widgets/display_portfolio_widget.dart';
import 'test_http_overrides.dart';
import 'dart:io';

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('DisplayPortfolioWidget shows portfolio items',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DisplayPortfolioWidget(
          portfolio: [
            {
              'title': 'Mock Title',
              'description': 'Mock Description',
              'images': ['https://via.placeholder.com/150'],
            },
          ],
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Mock Title'), findsOneWidget);
    expect(find.text('Mock Description'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
