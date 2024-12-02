import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/widgets/manage_availability_widget.dart';

void main() {
  group('ManageAvailabilityWidget Tests', () {
    testWidgets('Add an availability slot for an existing day', (WidgetTester tester) async {
      final Map<String, List<Map<String, String>>> availability = {
        'Monday': [],
        'Tuesday': [],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManageAvailabilityWidget(
              availability: availability,
              onAvailabilityAdded: (day, slot) {
                availability[day] ??= [];
                availability[day]!.add(slot);
              },
              onAvailabilityRemoved: (day, slot) {
                availability[day]?.remove(slot);
              },
              onNewDayAdded: (day) {
                availability[day] = [];
              },
            ),
          ),
        ),
      );

      // Select a day
      await tester.tap(find.byKey(const Key('dayDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monday').last); // Choose "Monday"
      await tester.pumpAndSettle();

      // Enter start and end times
      await tester.enterText(find.byKey(const Key('startTimeInput')), '09:00');
      await tester.enterText(find.byKey(const Key('endTimeInput')), '17:00');

      // Add the availability
      await tester.tap(find.byKey(const Key('addAvailabilityButton')));
      await tester.pumpAndSettle();

      // Verify the availability appears in the list
      expect(find.text('From 09:00 to 17:00'), findsOneWidget);
      expect(availability['Monday'], contains({'start': '09:00', 'end': '17:00'}));
    });

    testWidgets('Add an availability slot for a new day', (WidgetTester tester) async {
      final Map<String, List<Map<String, String>>> availability = {
        'Monday': [],
        'Tuesday': [],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ManageAvailabilityWidget(
              availability: availability,
              onAvailabilityAdded: (day, slot) {
                availability[day] ??= [];
                availability[day]!.add(slot);
              },
              onAvailabilityRemoved: (day, slot) {
                availability[day]?.remove(slot);
              },
              onNewDayAdded: (day) {
                availability[day] = [];
              },
            ),
          ),
        ),
      );

      // Simulate adding a new day
      await tester.tap(find.byKey(const Key('addNewDayButton'))); // Button to add a new day
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('newDayInput')), 'Wednesday');
      await tester.tap(find.text('Add')); // Confirm adding new day
      await tester.pumpAndSettle();

      // Select the new day
      await tester.tap(find.byKey(const Key('dayDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wednesday').last); // Choose "Wednesday"
      await tester.pumpAndSettle();

      // Enter start and end times
      await tester.enterText(find.byKey(const Key('startTimeInput')), '10:00');
      await tester.enterText(find.byKey(const Key('endTimeInput')), '18:00');

      // Add the availability
      await tester.tap(find.byKey(const Key('addAvailabilityButton')));
      await tester.pumpAndSettle();

      // Verify the availability appears in the list
      expect(find.text('From 10:00 to 18:00'), findsOneWidget);
      expect(availability['Wednesday'], contains({'start': '10:00', 'end': '18:00'}));
    });
  });
}