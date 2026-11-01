import 'package:dynamic_filter/domain/filter/implementations/leaf_filter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/filter_fixtures.dart';
import '../../fixtures/value_fixtures.dart';

void main() {
  test('should return correct values', () {
    final filter = equalTo5.or(higherThan6.and(lowerThan10));
    filter.toDeepString();
    final filteredValues = valuesFrom1To20.where(
      (e) => filter.isSatisfiedBy(e),
    );
    expect(
      filteredValues,
      allOf([
        hasLength(equals(4)),
        containsAllInOrder(const [5, 7, 8, 9]),
      ]),
    );
  });

  group('toString', () {
    test("should display a correct message without the filter's "
        "description", () {
      final filter = LeafFilter<int>((e) => e == 42);
      expect(filter.toString(), equals('LeafFilter<int>'));
    });

    test("should display a correct message with the filter's "
        "descriptions", () {
      final filter = equalTo5.or(higherThan6.and(lowerThan10));
      expect(filter.toString(), equals('(x = 5 || (x > 6 && x < 10))'));
    });
  });
}
