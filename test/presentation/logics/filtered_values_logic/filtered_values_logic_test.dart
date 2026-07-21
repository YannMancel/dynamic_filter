import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/impl/filter_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/filtered_values_logic.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/impl/filtered_values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/impl/values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValuesLogic valuesLogic;
  late FilterLogic filterLogic;
  late FilteredValuesLogic filteredValuesLogic;

  setUp(() {
    valuesLogic = ValuesLogicImpl();
    filterLogic = FilterLogicImpl();
    filteredValuesLogic = FilteredValuesLogicImpl(
      valuesLogic.notifier,
      filterLogic.notifier,
    );
  });

  tearDown(() {
    filteredValuesLogic.dispose();
    valuesLogic.dispose();
    filterLogic.dispose();
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
      'Then notifies a $LoadingAsyncValue and a $SuccessAsyncValue',
      () async {
        final asyncValues = <AsyncValue<Exception, List<int>>>[];
        void listener() => asyncValues.add(filteredValuesLogic.notifier.value);
        filteredValuesLogic.notifier.addListener(listener);

        await filteredValuesLogic.initialize();
        await valuesLogic.initialize();
        // to await the notify's update
        await Future.delayed(const Duration(seconds: 1));

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
                  hasLength(100),
                  containsAllInOrder(
                    Iterable.generate(100, (index) => index + 1),
                  ),
                ]),
              ),
            ]),
          ]),
        );
      },
    );
  });

  group('filter', () {
    test("Given the valuesNotify's value is a $SuccessAsyncValue "
        "When the filterLogic's update method is called "
        'Then notifies a $SuccessAsyncValue', () async {
      (valuesLogic as ValuesLogicImpl).notifier.value = SuccessAsyncValue(
        List.unmodifiable(Iterable.generate(100, (index) => index + 1)),
      );

      await filteredValuesLogic.initialize();
      // to await the notify's update
      await Future.delayed(const Duration(seconds: 1));

      final asyncValues = <AsyncValue<Exception, List<int>>>[];
      void listener() => asyncValues.add(filteredValuesLogic.notifier.value);
      filteredValuesLogic.notifier.addListener(listener);

      filterLogic.update();
      // to await the notify's update
      await Future.delayed(const Duration(seconds: 1));

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
                hasLength(6),
                containsAllInOrder(const [5, 7, 8, 9, 10, 11]),
              ]),
            ),
          ]),
        ]),
      );
    });
  });
}
