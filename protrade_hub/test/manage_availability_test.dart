import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/widgets/manage_availability_widget.dart'; // Update path as needed

void main() {
  group('ManageAvailabilityWidget Tests', () {
    testWidgets('Add an availability slot', (WidgetTester tester) async {
      // Wrap the widget with MaterialApp and Scaffold
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManageAvailabilityWidget(),
          ),
        ),
      );

      // Verify "Your Availability" text is present
      expect(find.text('Your Availability'), findsOneWidget);

      // Select a day
      await tester.tap(find.byKey(const Key('dayDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monday').last); // Choose "Monday"
      await tester.pumpAndSettle();

      // Enter start and end times
      await tester.enterText(
          find.byKey(const Key('startTimeInput')), '09:00'); // Start time
      await tester.enterText(
          find.byKey(const Key('endTimeInput')), '17:00'); // End time

      // Add the availability
      await tester.tap(find.text('Add Time Slot'));
      await tester.pumpAndSettle();

      // Verify the availability appears in the list
      expect(find.text('From 09:00 to 17:00'), findsOneWidget);
    });
  });
}
