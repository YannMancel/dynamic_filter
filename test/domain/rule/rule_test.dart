import 'package:dynamic_filter/domain/rule/rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/filter_fixtures.dart';

void main() {
  group('toString', () {
    test("should display a correct message without the rule's next", () {
      final rule = Rule<int>(filter: equalTo5);
      expect(
        rule.toString(),
        equals(
          'Rule<int>{filter: x = 5,'
          ' next: null}',
        ),
      );
    });

    test("should display a correct message with the rule's next", () {
      final rule = Rule<int>(
        filter: equalTo5,
        next: Rule<int>(filter: higherThan6),
      );
      expect(
        rule.toString(),
        equals(
          'Rule<int>{filter: x = 5,'
          ' next: Rule<int>{filter: x > 6,'
          ' next: null}}',
        ),
      );
    });
  });
}
