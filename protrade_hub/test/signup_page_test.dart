import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/screens/signup_page.dart'; // Update with the actual file path

void main() {
  group('SignUpPage Tests', () {
    testWidgets('Toggle between Client and Contractor forms', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      // Verify Client form is initially displayed
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Company Name'), findsNothing);

      // Tap on Contractor toggle
      await tester.tap(find.text('Contractor'));
      await tester.pumpAndSettle();

      // Verify Contractor form is displayed
      expect(find.text('Company Name'), findsOneWidget);
      expect(find.text('Field X'), findsOneWidget);
    });

    testWidgets('Validate empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      // Attempt to submit without filling fields
      await tester.tap(find.byKey(const Key('signUpButton')));
      await tester.pumpAndSettle();

      // Verify error messages are displayed
      expect(find.text('Name is required'), findsWidgets);
      expect(find.text('Email is required'), findsWidgets);
    });

    testWidgets('Successful form submission for Client', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      // Fill out the Client form
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'johndoe@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), '1234567890');

      // Submit the form
      await tester.tap(find.byKey(const Key('signUpButton')));
      await tester.pumpAndSettle();

      // Verify success message is displayed
      expect(find.text('Form Submitted Successfully'), findsOneWidget);
    });
  });
}
