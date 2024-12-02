import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/widgets/manage_specializations_widget.dart'; // Update path as needed

void main() {
  group('ManageSpecializationsWidget Tests', () {
    testWidgets('Add a specialization', (WidgetTester tester) async {
      // Wrap the widget with MaterialApp and Scaffold
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManageSpecializationsWidget(),
          ),
        ),
      );

      // Verify "Your Specializations" text is present
      expect(find.text('Your Specializations'), findsOneWidget);

      // Add a specialization
      await tester.enterText(
          find.byType(TextField).first, 'Plumber'); // Input "Plumber"
      await tester.tap(find.byIcon(Icons.add)); // Press the add button
      await tester.pumpAndSettle();

      // Verify the specialization appears as a chip
      expect(find.text('Plumber'), findsOneWidget);
    });
  });
}
