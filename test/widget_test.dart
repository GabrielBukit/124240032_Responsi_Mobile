import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_mobile_32/main.dart';

void main() {
  testWidgets('App starts at login page when not logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verify login page title
    expect(find.text('Shopedia'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
