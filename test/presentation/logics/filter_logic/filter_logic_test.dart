import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/impl/filter_logic_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/filter_fixtures.dart';

void main() {
  late FilterLogic filterLogic;

  setUp(() => filterLogic = FilterLogicImpl());

  tearDown(() => filterLogic.dispose());

  test('should have an initial value equals to null', () {
    expect(filterLogic.notifier.value, isNull);
  });

  group('filterByDefault', () {
    test('When the filterByDefault method is called '
        'Then notifies a $Filter', () {
      final filters = <Filter?>[];
      void listener() => filters.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      filterLogic.filterByDefault();
      filterLogic.notifier.removeListener(listener);
      expect(
        filters,
        allOf([
          hasLength(1),
          contains(
            isA<Filter<int>>().having(
              (e) => e.toString(),
              'filter',
              equals('(x = 5 || (x > 6 && x < 12))'),
            ),
          ),
        ]),
      );
    });
  });

  group('delete', () {
    test('When the delete method is called '
        'Then notifies a $Filter', () {
      final lowerThan10 = getLowerThan10();
      filterLogic.notifier.value = getHigherThan6().and(lowerThan10);
      final filters = <Filter?>[];
      void listener() => filters.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      expect(
        filterLogic.notifier.value.toString(),
        equals('(x > 6 && x < 10)'),
      );
      filterLogic.delete(lowerThan10);
      filterLogic.notifier.removeListener(listener);
      expect(
        filters,
        allOf([
          hasLength(1),
          contains(
            isA<Filter<int>>().having(
              (e) => e.toString(),
              'filter',
              equals('(x > 6)'),
            ),
          ),
        ]),
      );
    });
  });

  group('reset', () {
    test('When the reset method is called '
        'Then notifies a $Filter', () {
      filterLogic.notifier.value = getEqualTo5();
      final filters = <Filter?>[];
      void listener() => filters.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      expect(filterLogic.notifier.value.toString(), equals('x = 5'));
      filterLogic.reset();
      filterLogic.notifier.removeListener(listener);
      expect(filters, allOf([hasLength(1), contains(isNull)]));
    });
  });
}
