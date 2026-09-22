import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:portfolio/core/theme/theme_provider.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/screens/splash_screen.dart';
import 'package:portfolio/screens/main_shell.dart';

void main() {
  testWidgets('Portfolio app smoke test & splash screen initial state', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('MainShell renders navigation tabs correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: MainShell(),
        ),
      ),
    );
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
  });
}
