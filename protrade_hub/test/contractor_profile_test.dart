import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/screens/contractor_profile.dart'; // Update the path

void main() {
  group('ContractorProfilePage Tests', () {
    testWidgets('Add and delete specializations', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ContractorProfilePage()));

      // Verify initial state
      expect(find.text('Your Specializations'), findsOneWidget);
      expect(find.byKey(const Key('specialization-Plumber')), findsNothing);

      // Add a specialization
      await tester.enterText(find.byKey(const Key('specializationInput')), 'Plumber');
      await tester.tap(find.byKey(const Key('addSpecializationButton')));
      await tester.pumpAndSettle();

      // Verify specialization added
      expect(find.byKey(const Key('specialization-Plumber')), findsOneWidget);

      // Delete the specialization
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify specialization deleted
      expect(find.byKey(const Key('specialization-Plumber')), findsNothing);
    });

    testWidgets('Filter jobs by specialization', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ContractorProfilePage()));

      // Add a specialization
      await tester.enterText(find.byKey(const Key('specializationInput')), 'Electrician');
      await tester.tap(find.byKey(const Key('addSpecializationButton')));
      await tester.pumpAndSettle();

      // Verify filtered job appears
      expect(find.byKey(const Key('job-Electrician')), findsOneWidget);
    });
  });
}
