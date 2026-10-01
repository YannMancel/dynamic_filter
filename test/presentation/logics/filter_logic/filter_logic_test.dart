import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/impl/filter_logic_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/specification_fixtures.dart';

void main() {
  late FilterLogic filterLogic;

  setUp(() => filterLogic = FilterLogicImpl());

  tearDown(() => filterLogic.dispose());

  test('should have an initial value equals to null', () {
    expect(filterLogic.notifier.value, isNull);
  });

  group('filterByDefault', () {
    test('When the filterByDefault method is called '
        'Then notifies a $Specification', () {
      final specifications = <Specification?>[];
      void listener() => specifications.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      filterLogic.filterByDefault();
      filterLogic.notifier.removeListener(listener);
      expect(
        specifications,
        allOf([
          hasLength(1),
          contains(
            isA<Specification<int>>().having(
              (e) => e.toString(),
              'specification',
              equals('(x = 5 || (x > 6 && x < 12))'),
            ),
          ),
        ]),
      );
    });
  });

  group('delete', () {
    test('When the delete method is called '
        'Then notifies a $Specification', () {
      final lowerThan10 = getLowerThan10();
      filterLogic.notifier.value = getHigherThan6().and(lowerThan10);
      final specifications = <Specification?>[];
      void listener() => specifications.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      expect(
        filterLogic.notifier.value.toString(),
        equals('(x > 6 && x < 10)'),
      );
      filterLogic.delete(lowerThan10);
      filterLogic.notifier.removeListener(listener);
      expect(
        specifications,
        allOf([
          hasLength(1),
          contains(
            isA<Specification<int>>().having(
              (e) => e.toString(),
              'specification',
              equals('(x > 6)'),
            ),
          ),
        ]),
      );
    });
  });

  group('reset', () {
    test('When the reset method is called '
        'Then notifies a $Specification', () {
      filterLogic.notifier.value = getEqualTo5();
      final specifications = <Specification?>[];
      void listener() => specifications.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      expect(filterLogic.notifier.value.toString(), equals('x = 5'));
      filterLogic.reset();
      filterLogic.notifier.removeListener(listener);
      expect(specifications, allOf([hasLength(1), contains(isNull)]));
    });
  });
}
