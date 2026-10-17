import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:nutrivision_capstone_project/features/splash/presentation/screens/splash_screen.dart';
import 'package:nutrivision_capstone_project/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:nutrivision_capstone_project/main.dart';

void main() {
  testWidgets('shows the NutriVision splash screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const NutriVisionApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('9:41'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Eat well. Feel good.'), findsOneWidget);
  });
}
