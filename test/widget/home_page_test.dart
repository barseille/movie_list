import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasetest/views/home_page.dart'; // Assurez-vous d'importer le bon fichier de votre HomePage

void main() {
  testWidgets('HomePage affiche le titre', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    expect(find.text('Home'), findsOneWidget);
  });
}
