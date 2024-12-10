import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protrade_hub/screens/contractor_profile.dart';

// Custom HttpOverrides to intercept network requests during tests
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true
      ..addRequestModifier((HttpClientRequest request) async {
        if (request.uri.host == 'via.placeholder.com') {
          // Mock response for placeholder images
          return HttpClientResponseMock();
        }
        return request;
      });
  }
}

class HttpClientResponseMock extends HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => HttpHeaders();

  @override
  Stream<List<int>> get where => Stream.value(<int>[]);

  // Provide an empty stream for the response body
  @override
  Stream<List<int>> handleData(data, Function callback) => const Stream.empty();
}

void main() {
  setUpAll(() {
    // Apply the custom HttpOverrides for all tests
    HttpOverrides.global = TestHttpOverrides();
  });

  tearDownAll(() {
    // Reset the HttpOverrides after tests
    HttpOverrides.global = null;
  });

  group('ContractorProfilePage Tests', () {
    testWidgets('Page loads with all necessary elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContractorProfilePage(),
        ),
      );

      // Verify the AppBar title
      expect(find.text('Contractor Profile'), findsOneWidget);

      // Verify the BottomNavigationBar items by their keys
      expect(find.byIcon(Icons.person), findsOneWidget); // Overview icon
      expect(find.byIcon(Icons.build), findsOneWidget);  // Specializations icon
      expect(find.byIcon(Icons.schedule), findsOneWidget); // Availability icon
      expect(find.byIcon(Icons.photo_album), findsOneWidget); // Portfolio icon
      expect(find.byIcon(Icons.edit), findsOneWidget); // Manage Portfolio icon
    });

    testWidgets('Tapping on bottom navigation changes the page', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContractorProfilePage(),
        ),
      );

      // Tap the Specializations tab using the icon instead of ambiguous text
      await tester.tap(find.byIcon(Icons.build));
      await tester.pumpAndSettle();
      expect(find.text('Manage Specializations'), findsOneWidget);

      // Tap the Availability tab using the icon
      await tester.tap(find.byIcon(Icons.schedule));
      await tester.pumpAndSettle();
      expect(find.text('Manage Availability'), findsOneWidget);
    });
  });
}
