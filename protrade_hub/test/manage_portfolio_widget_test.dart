import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/widgets/manage_portfolio_widget.dart';

void main() {
  testWidgets('ManagePortfolioWidget adds and deletes portfolio items',
      (WidgetTester tester) async {
    final mockPortfolio = <Map<String, dynamic>>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ManagePortfolioWidget(
          portfolio: mockPortfolio,
          onPortfolioAdded: (item) => mockPortfolio.add(item),
          onPortfolioDeleted: (index) => mockPortfolio.removeAt(index),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify initial state
    expect(mockPortfolio, isEmpty);

    // Add portfolio item
    await tester.tap(find.text('Add Portfolio Item'));
    await tester.pumpAndSettle();

    expect(mockPortfolio, isNotEmpty);

    // Delete portfolio item
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    expect(mockPortfolio, isEmpty);
  });
}
