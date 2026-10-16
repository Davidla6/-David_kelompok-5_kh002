import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projek/main.dart';
import 'package:projek/widgets/app_button.dart';

void main() {
  testWidgets('HomePage renders elements correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Design System Demo'), findsOneWidget);
    expect(find.text('Universitas Esa Unggul'), findsOneWidget);
    expect(find.text('Pergi ke GMAPS'), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });

  testWidgets('AppButton renders label and calls onPressed', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Click Me',
            icon: Icons.touch_app,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
    expect(find.byIcon(Icons.touch_app), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(pressed, isTrue);
  });
}
