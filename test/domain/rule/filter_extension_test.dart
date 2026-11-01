import 'package:dynamic_filter/domain/rule/filter_extension.dart';
import 'package:dynamic_filter/domain/rule/rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/filter_fixtures.dart';

void main() {
  group('convertToRuleUntilTarget', () {
    test("should convert filter to a correct rule", () {
      final target = higherThan6;
      final filter = equalTo5.or(target.and(lowerThan10));
      filter.toDeepString();
      final rule = filter.convertToRuleUntilTarget(target);
      expect(
        rule,
        isA<Rule<int>>()
            .having((e) => e.filter, 'filter', equals(target))
            .having(
              (e) => e.toString(),
              'toString',
              equals(
                'Rule<int>{filter: x > 6,'
                ' next: Rule<int>{filter: (x > 6 && x < 10),'
                ' next: Rule<int>{filter: (x = 5 || (x > 6 && x < 10)),'
                ' next: null}}}',
              ),
            ),
      );
    });
  });
}
