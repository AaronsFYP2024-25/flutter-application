import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/widgets/manage_specializations_widget.dart';

void main() {
  testWidgets('ManageSpecializationsWidget adds and removes specializations',
      (WidgetTester tester) async {
    final mockSpecializations = <String>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ManageSpecializationsWidget(
          specializations: mockSpecializations,
          onSpecializationAdded: (spec) => mockSpecializations.add(spec),
          onSpecializationRemoved: (spec) => mockSpecializations.remove(spec),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Add specialization
    await tester.enterText(find.byKey(Key('addSpecializationField')), 'Plumber');
    await tester.tap(find.byKey(Key('addSpecializationButton')));
    await tester.pumpAndSettle();

    expect(mockSpecializations, contains('Plumber'));

    // Remove specialization
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    expect(mockSpecializations, isEmpty);
  });
}


// void main() {
//   group('ManageSpecializationsWidget Tests', () {
//     testWidgets('Add a specialization', (WidgetTester tester) async {
//       final specializations = ['Plumber', 'Electrician'];

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: ManageSpecializationsWidget(
//               specializations: specializations,
//               onSpecializationAdded: (specialization) {
//                 if (!specializations.contains(specialization)) {
//                   specializations.add(specialization);
//                 }
//               },
//               onSpecializationRemoved: (specialization) {
//                 specializations.remove(specialization);
//               },
//             ),
//           ),
//         ),
//       );

//       // Add a new specialization
//       await tester.enterText(find.byKey(const Key('specializationInput')), 'Carpenter');
//       await tester.tap(find.byKey(const Key('addSpecializationButton')));
//       await tester.pumpAndSettle();

//       // Verify the specialization appears as a chip
//       expect(find.text('Carpenter'), findsOneWidget);
//       expect(specializations, contains('Carpenter'));
//     });

//     testWidgets('Remove a specialization', (WidgetTester tester) async {
//       final specializations = ['Plumber', 'Electrician'];

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: ManageSpecializationsWidget(
//               specializations: specializations,
//               onSpecializationAdded: (specialization) {
//                 if (!specializations.contains(specialization)) {
//                   specializations.add(specialization);
//                 }
//               },
//               onSpecializationRemoved: (specialization) {
//                 specializations.remove(specialization);
//               },
//             ),
//           ),
//         ),
//       );

//       // Remove a specialization
//       await tester.tap(find.byIcon(Icons.close).first);
//       await tester.pumpAndSettle();

//       // Verify the specialization is removed
//       expect(find.text('Plumber'), findsNothing);
//       expect(specializations, isNot(contains('Plumber')));
//     });
//   });
// }


