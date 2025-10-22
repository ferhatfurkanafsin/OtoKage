// This is a basic Flutter widget test for OtoKage app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';
import 'package:frontend/services/language_service.dart';

void main() {
  testWidgets('App smoke test - verifies app loads', (WidgetTester tester) async {
    // Create language service for testing
    final languageService = LanguageService();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(languageService: languageService));

    // Verify that the app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
