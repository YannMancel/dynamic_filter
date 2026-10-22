import 'package:dynamic_filter/domain/rule/filter_request.dart';
import 'package:dynamic_filter/domain/rule/filter_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/filter_fixtures.dart';

void main() {
  group('DeleteFilterRequest', () {
    test("should display a correct message with the filter's "
        "descriptions (deleting by direct parent)", () {
      final lowerThan10 = getLowerThan10();
      final filter = getEqualTo5().or(getHigherThan6().and(lowerThan10));
      expect(filter.toString(), equals('(x = 5 || (x > 6 && x < 10))'));
      final response = lowerThan10.handle(
        DeleteFilterRequest<int>(lowerThan10),
      );
      expect(
        response,
        isA<UpdateFilterResponse>().having(
          (e) => e.filter,
          'filter',
          equals(filter),
        ),
      );
      expect(filter.toString(), equals('(x = 5 || (x > 6))'));
    });

    test("should display a correct message with the filter's "
        "descriptions (deleting by middle parent)", () {
      final equalTo5 = getEqualTo5();
      final lowerThan10 = getLowerThan10();
      final filter = equalTo5.or(getHigherThan6().and(lowerThan10));
      expect(filter.toString(), equals('(x = 5 || (x > 6 && x < 10))'));
      final response = lowerThan10.handle(DeleteFilterRequest<int>(equalTo5));
      expect(
        response,
        isA<UpdateFilterResponse>().having(
          (e) => e.filter,
          'filter',
          equals(filter),
        ),
      );
      expect(filter.toString(), equals('((x > 6 && x < 10))'));
    });
  });
}
