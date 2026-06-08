import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('Pair', () {
    test('constructs with values', () {
      final pair = Pair(1, 'hello');
      expect(pair.first, 1);
      expect(pair.second, 'hello');
    });

    test('equality - same values', () {
      expect(Pair(1, 'a'), Pair(1, 'a'));
    });

    test('equality - different values', () {
      expect(Pair(1, 'a') == Pair(1, 'b'), isFalse);
    });

    test('equality - different types', () {
      expect(Pair(1, 'a') == Pair(2, 'a'), isFalse);
    });

    test('equality - identical', () {
      final pair = Pair(1, 'a');
      expect(pair == pair, isTrue);
    });

    test('equality - different runtime type', () {
      expect(Pair(1, 'a').runtimeType == Pair(1, 'a').runtimeType, isTrue);
    });

    test('hashCode - consistent', () {
      final pair = Pair(1, 'a');
      expect(pair.hashCode, pair.hashCode);
    });

    test('hashCode - equal objects have equal hashCodes', () {
      expect(Pair(1, 'a').hashCode, Pair(1, 'a').hashCode);
    });

    test('const constructor', () {
      const pair = Pair(1, 'hello');
      expect(pair.first, 1);
      expect(pair.second, 'hello');
    });

    test('works with different types', () {
      final pair = Pair('key', 42);
      expect(pair.first, 'key');
      expect(pair.second, 42);
    });
  });
}
