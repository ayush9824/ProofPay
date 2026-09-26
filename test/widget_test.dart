// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proofpay/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ProofPayApp()));

    // Verify that the Splash Screen renders successfully.
    expect(find.text('ProofPay'), findsOneWidget);

    // Wait for the 2 second timer and navigation to complete
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the Onboarding Screen renders successfully.
    expect(find.text('Get paid.\\nWithout the chasing.'), findsOneWidget);
  });
}
