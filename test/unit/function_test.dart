import 'package:flutter_test/flutter_test.dart';

// Exemple de fonction que tu veux tester
int add(int a, int b) {
  return a + b;
}

void main() {
  test('addition de deux nombres', () {
    expect(add(1, 2), 3);
    expect(add(-1, -1), -2);
    expect(add(0, 0), 0);
  });
}
