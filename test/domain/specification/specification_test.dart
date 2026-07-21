import 'package:dynamic_filter/domain/specification/impl/leaf_specification.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/specification_fixtures.dart';

void main() {
  test('should return correct items', () async {
    final specification = equalTo5.or(higherThan6.and(lowerThan10));
    final filteredItems = itemsFrom1To10.where(
      (e) => specification.isSatisfiedBy(e),
    );
    expect(
      filteredItems,
      allOf([
        hasLength(equals(4)),
        containsAllInOrder(const [5, 7, 8, 9]),
      ]),
    );
  });

  group('toString', () {
    test("should display a correct message without the specification's "
        "description", () async {
      final specification = LeafSpecification<int>((e) => e == 42);
      expect(
        specification.toString(),
        equals('LeafSpecification{predicate: Closure: (int) => bool}'),
      );
    });

    test("should display a correct message with the specification's "
        "descriptions", () async {
      final specification = equalTo5.or(higherThan6.and(lowerThan10));
      expect(specification.toString(), equals('(x == 5 || (x > 6 && x < 10))'));
    });
  });
}
