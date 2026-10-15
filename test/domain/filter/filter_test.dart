import 'package:dynamic_filter/domain/filter/implementations/leaf_filter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/filter_fixtures.dart';

void main() {
  test('should return correct items', () {
    final filter = getEqualTo5().or(getHigherThan6().and(getLowerThan10()));
    final filteredItems = itemsFrom1To20.where((e) => filter.isSatisfiedBy(e));
    expect(
      filteredItems,
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
      final filter = getEqualTo5().or(getHigherThan6().and(getLowerThan10()));
      expect(filter.toString(), equals('(x = 5 || (x > 6 && x < 10))'));
    });
  });
}
