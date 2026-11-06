import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worker_marketplace/screens/auth_screen.dart';

void main() {
  testWidgets('auth screen renders sign in and sign up options', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Create account'), findsAtLeastNWidgets(1));
  });
}
