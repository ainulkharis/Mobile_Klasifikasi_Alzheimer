import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_alzaimer/auth/login_screen.dart';
import 'package:e_alzaimer/auth/signup_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('Widget rendering and navigation', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Ensure initial widgets are rendered
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Trigger navigation to SignUpScreen
      await tester.tap(find.text('Belum punya akun? Daftar disini'));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byType(SignupScreen), findsOneWidget);
    });

    // Add more widget tests for different UI interactions
  });
}
