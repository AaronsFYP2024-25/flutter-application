import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/screens/contractor_profile.dart'; // Update this path as needed

void main() {
  group('ContractorProfilePage Tests', () {
    testWidgets('Page loads with all necessary elements',
        (WidgetTester tester) async {
      // Load the ContractorProfilePage
      await tester.pumpWidget(const MaterialApp(home: ContractorProfilePage()));

      // Verify AppBar title
      expect(find.text('Contractor Profile'), findsOneWidget);

      // Verify bottom navigation bar icons
      expect(find.byIcon(Icons.person), findsOneWidget); // Profile tab
      expect(find.byIcon(Icons.build), findsOneWidget); // Specializations tab
      expect(find.byIcon(Icons.schedule), findsOneWidget); // Availability tab
    });
  });
}
