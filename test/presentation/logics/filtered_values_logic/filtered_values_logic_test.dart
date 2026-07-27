import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/filtered_values_logic.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/impl/filtered_values_logic_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/specification_fixtures.dart';

void main() {
  late ValueNotifier<AsyncValue<Exception, List<int>>> valuesNotifier;
  late ValueNotifier<Specification<int>?> filterNotifier;
  late FilteredValuesLogic filteredValuesLogic;

  setUp(() {
    valuesNotifier = ValueNotifier(const IdleAsyncValue());
    filterNotifier = ValueNotifier(null);
    filteredValuesLogic = FilteredValuesLogicImpl(
      valuesNotifier,
      filterNotifier,
    );
  });

  tearDown(() {
    filteredValuesLogic.dispose();
    valuesNotifier.dispose();
    filterNotifier.dispose();
  });

  test('should have an initial $AsyncValue equals to $IdleAsyncValue', () {
    expect(
      filteredValuesLogic.notifier.value,
      equals(const IdleAsyncValue<Exception, List<int>>()),
    );
  });

  group('initialize', () {
    test(
      'When the initialize method is called '
      'And the values notifier notifies a $SuccessAsyncValue '
      'Then notifies a $LoadingAsyncValue and a $SuccessAsyncValue',
      () async {
        final asyncValues = <AsyncValue<Exception, List<int>>>[];
        void listener() => asyncValues.add(filteredValuesLogic.notifier.value);
        filteredValuesLogic.notifier.addListener(listener);
        await filteredValuesLogic.initialize();
        valuesNotifier.value = SuccessAsyncValue(itemsFrom1To20);
        // to await the notify's update
        await Future.delayed(const Duration(milliseconds: 300));
        filteredValuesLogic.notifier.removeListener(listener);
        expect(
          asyncValues,
          allOf([
            hasLength(2),
            containsAllInOrder([
              const LoadingAsyncValue<Exception, List<int>>(),
              isA<SuccessAsyncValue<Exception, List<int>>>().having(
                (e) => e.value,
                'value',
                allOf([
                  hasLength(itemsFrom1To20.length),
                  containsAllInOrder(itemsFrom1To20),
                ]),
              ),
            ]),
          ]),
        );
      },
    );

    test(
      "Given the values notifier equals to a $SuccessAsyncValue "
      'When the initialize method is called '
      'And the filter notifier notifies a $Specification '
      'Then notifies a $LoadingAsyncValue and a $SuccessAsyncValue',
      () async {
        valuesNotifier.value = SuccessAsyncValue(itemsFrom1To20);
        await filteredValuesLogic.initialize();
        // to await the notify's update
        await Future.delayed(const Duration(milliseconds: 300));
        final asyncValues = <AsyncValue<Exception, List<int>>>[];
        void listener() => asyncValues.add(filteredValuesLogic.notifier.value);
        filteredValuesLogic.notifier.addListener(listener);
        filterNotifier.value = equalTo5;
        // to await the notify's update
        await Future.delayed(const Duration(milliseconds: 300));
        filteredValuesLogic.notifier.removeListener(listener);
        expect(
          asyncValues,
          allOf([
            hasLength(2),
            containsAllInOrder([
              const LoadingAsyncValue<Exception, List<int>>(),
              isA<SuccessAsyncValue<Exception, List<int>>>().having(
                (e) => e.value,
                'value',
                allOf([
                  hasLength(1),
                  containsAllInOrder(const [5]),
                ]),
              ),
            ]),
          ]),
        );
      },
    );
  });
}
