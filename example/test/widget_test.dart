import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('App loads with bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });
}
