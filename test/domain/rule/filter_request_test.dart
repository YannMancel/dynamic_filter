import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/rule/filter_extension.dart';
import 'package:dynamic_filter/domain/rule/filter_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/filter_fixtures.dart';
import '../../fixtures/filter_response_fixtures.dart';

void main() {
  group('DeleteFilterRequest', () {
    for (final (head, child, target, response) in [
      (equalTo5, equalTo5, equalTo5, 'empty'),
      (equalTo5, equalTo5, higherThan6, 'x = 5'),
      (equalTo5.and(higherThan6), higherThan6, higherThan6, '(x = 5)'),
      (
        equalTo5.or(higherThan6.and(lowerThan10)),
        equalTo5,
        equalTo5,
        '((x > 6 && x < 10))',
      ),
    ]) {
      test('Given the target is "$target" '
          'When the delete request is called on "$head" '
          'Then the response is "$response"', () {
        expect(
          head
              .convertToRuleUntilTarget(child)
              ?.handle(DeleteFilterRequest<int>(target))
              .debugLabel,
          equals(response),
        );
      });
    }
  });

  group('CompositeAddFilterRequest', () {
    for (final (head, child, from, response) in [
      (
        equalTo5.and(higherThan6),
        higherThan6,
        equalTo5.and(higherThan6),
        '(x = 5 && x > 6 && x < 10)',
      ),
    ]) {
      test('Given the from is "$from" '
          'When the composite add request is called on "$head" '
          'Then the response is "$response"', () {
        expect(from, isA<CompositeFilter<int>>());
        expect(
          head
              .convertToRuleUntilTarget(child)
              ?.handle(
                CompositeAddFilterRequest<int>(
                  from: from as CompositeFilter<int>,
                  filter: lowerThan10,
                ),
              )
              .debugLabel,
          equals(response),
        );
      });
    }
  });
}
