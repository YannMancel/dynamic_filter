import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/specification_fixtures.dart';

void main() {
  group('DeleteSpecificationRequest', () {
    test("should display a correct message with the specification's "
        "descriptions (deleting by direct parent)", () {
      final lowerThan10 = getLowerThan10();
      final specification = getEqualTo5().or(getHigherThan6().and(lowerThan10));
      expect(specification.toString(), equals('(x == 5 || (x > 6 && x < 10))'));
      lowerThan10.handle(DeleteSpecificationRequest<int>(lowerThan10));
      expect(specification.toString(), equals('(x == 5 || (x > 6))'));
    });

    test("should display a correct message with the specification's "
        "descriptions (deleting by middle parent)", () {
      final equalTo5 = getEqualTo5();
      final lowerThan10 = getLowerThan10();
      final specification = equalTo5.or(getHigherThan6().and(lowerThan10));
      expect(specification.toString(), equals('(x == 5 || (x > 6 && x < 10))'));
      lowerThan10.handle(DeleteSpecificationRequest<int>(equalTo5));
      expect(specification.toString(), equals('((x > 6 && x < 10))'));
    });
  });
}
