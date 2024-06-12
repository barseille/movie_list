import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasetest/main.dart'; // Assurez-vous que l'import du fichier principal est correct

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construire le widget CounterApp
    await tester.pumpWidget(const MyApp());

    // Vérifiez la présence du texte '0'
    expect(find.text('0'), findsOneWidget);

    // Trouvez le FloatingActionButton et appuyez dessus
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Vérifiez la présence du texte '1'
    expect(find.text('1'), findsOneWidget);
  });
}
