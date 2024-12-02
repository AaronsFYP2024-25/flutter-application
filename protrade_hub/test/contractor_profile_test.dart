import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/screens/contractor_profile.dart'; // Update the path

void main() {
  group('ContractorProfilePage Tests', () {
    testWidgets('Page loads with all necessary elements', (WidgetTester tester) async {
      // Load the ContractorProfilePage
      await tester.pumpWidget(const MaterialApp(home: ContractorProfilePage()));

      // Verify initial UI elements
      expect(find.text('Contractor Profile'), findsOneWidget); // AppBar title
      expect(find.byIcon(Icons.person), findsOneWidget); // Profile icon in bottom navigation
      expect(find.byIcon(Icons.build), findsOneWidget); // Specializations icon
      expect(find.byIcon(Icons.schedule), findsOneWidget); // Availability icon
    });

    testWidgets('Add a time and day for availability', (WidgetTester tester) async {
      // Load the ContractorProfilePage
      await tester.pumpWidget(const MaterialApp(home: ContractorProfilePage()));

      // Navigate to the "Availability" tab
      await tester.tap(find.byIcon(Icons.schedule));
      await tester.pumpAndSettle();

      // Verify "Your Availability" is present
      expect(find.text('Your Availability'), findsOneWidget);

      // Select a day
      await tester.tap(find.text('Select Day'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monday').last);
      await tester.pumpAndSettle();

      // Enter start and end times
      await tester.enterText(find.byType(TextField).at(0), '09:00'); // Start time
      await tester.enterText(find.byType(TextField).at(1), '17:00'); // End time

      // Add the availability
      await tester.tap(find.text('Add Time Slot'));
      await tester.pumpAndSettle();

      // Verify the availability slot is added
      expect(find.text('From 09:00 to 17:00'), findsOneWidget);
    });

    testWidgets('Add a specialization', (WidgetTester tester) async {
      // Load the ContractorProfilePage
      await tester.pumpWidget(const MaterialApp(home: ContractorProfilePage()));

      // Navigate to the "Specializations" tab
      await tester.tap(find.byIcon(Icons.build));
      await tester.pumpAndSettle();

      // Verify "Your Specializations" is present
      expect(find.text('Your Specializations'), findsOneWidget);

      // Add a specialization
      await tester.enterText(find.byKey(const Key('specializationInput')), 'Plumber');
      await tester.tap(find.byKey(const Key('addSpecializationButton')));
      await tester.pumpAndSettle();

      // Verify the specialization is added
      expect(find.byKey(const Key('specialization-Plumber')), findsOneWidget);
    });
  });
}
