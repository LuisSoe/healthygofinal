import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthygo/main.dart';

void main() {
  testWidgets('App loads and shows welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(HealthyGoApp());
    expect(find.text('Welcome to HealthyGo!'), findsOneWidget);
  });
}
