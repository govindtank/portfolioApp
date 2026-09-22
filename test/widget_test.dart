import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/screens/main_shell.dart';

void main() {
  testWidgets('Portfolio app loads and navigates to main shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Advance past splash delay
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byType(MainShell), findsOneWidget);
  });
}
