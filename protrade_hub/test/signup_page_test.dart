import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/screens/signup_page.dart'; // Update with the actual file path

void main() {
  testWidgets('SignUpPage submits the form', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    // Fill out form
    await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'password123');

    // Submit form
    await tester.tap(find.byKey(Key('submitButton')));
    await tester.pumpAndSettle();

    // Verify success message
    expect(find.text('Signup successful'), findsOneWidget);
  });
}


// void main() {
//   group('SignUpPage Tests', () {
//     testWidgets('Toggle between Client and Contractor forms displays the correct form fields',
//         (WidgetTester tester) async {
//       // Load the SignUpPage widget
//       await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

//       // Verify that the Client form is displayed by default
//       expect(find.text('Name'), findsOneWidget); // Client-specific field
//       expect(find.text('Company Name'), findsNothing); // Contractor-specific field

//       // Tap on the "Contractor" toggle
//       await tester.tap(find.text('Contractor'));
//       await tester.pumpAndSettle();

//       // Verify that the Contractor form is displayed
//       expect(find.text('Company Name'), findsOneWidget); // Contractor-specific field
//       expect(find.text('Field X'), findsOneWidget); // Additional Contractor field
//     });

//     testWidgets('Form validation ensures required fields are filled before submission',
//         (WidgetTester tester) async {
//       // Load the SignUpPage widget
//       await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

//       // Attempt to submit the form without filling any fields
//       await tester.tap(find.byKey(const Key('signUpButton')));
//       await tester.pumpAndSettle();

//       // Verify that error messages are displayed for empty required fields
//       expect(find.text('Name is required'), findsWidgets);
//       expect(find.text('Email is required'), findsWidgets);
//     });

//     testWidgets('Successfully submitting the Client form displays a success message',
//         (WidgetTester tester) async {
//       // Load the SignUpPage widget
//       await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

//       // Fill out the Client form
//       await tester.enterText(find.byType(TextFormField).at(0), 'John Doe'); // Name
//       await tester.enterText(find.byType(TextFormField).at(1), 'johndoe@example.com'); // Email
//       await tester.enterText(find.byType(TextFormField).at(2), 'password123'); // Password
//       await tester.enterText(find.byType(TextFormField).at(3), '1234567890'); // Phone Number

//       // Submit the form
//       await tester.tap(find.byKey(const Key('signUpButton')));
//       await tester.pumpAndSettle();

//       // Verify that a success message is displayed
//       expect(find.text('Form Submitted Successfully'), findsOneWidget);
//     });

//     testWidgets('Successfully submitting the Contractor form displays a success message',
//         (WidgetTester tester) async {
//       // Load the SignUpPage widget
//       await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

//       // Switch to the Contractor form
//       await tester.tap(find.text('Contractor'));
//       await tester.pumpAndSettle();

//       // Fill out the Contractor form
//       await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe'); // Name
//       await tester.enterText(find.byType(TextFormField).at(1), 'Doe Enterprises'); // Company Name
//       await tester.enterText(find.byType(TextFormField).at(2), 'jane@example.com'); // Email
//       await tester.enterText(find.byType(TextFormField).at(3), 'securepassword'); // Password
//       await tester.enterText(find.byType(TextFormField).at(4), '0987654321'); // Phone Number
//       await tester.enterText(find.byType(TextFormField).at(5), 'INS-12345'); // Insurance Number
//       await tester.enterText(find.byType(TextFormField).at(6), 'Field X Value'); // Field X
//       await tester.enterText(find.byType(TextFormField).at(7), 'Field Y Value'); // Field Y

//       // Submit the form
//       await tester.tap(find.byKey(const Key('signUpButton')));
//       await tester.pumpAndSettle();

//       // Verify that a success message is displayed
//       expect(find.text('Form Submitted Successfully'), findsOneWidget);
//     });
//   });
// }

