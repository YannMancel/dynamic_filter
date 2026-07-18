import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/presentation/logics/implementations/values_logic_by_value_notifier.dart';
import 'package:dynamic_filter/presentation/logics/values_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValuesLogic logic;

  setUp(() => logic = ValuesLogicByValueNotifier());

  tearDown(() => logic.dispose());

  test('should have an initial $AsyncValue equals to $IdleAsyncValue', () {
    expect(
      logic.notifier.value,
      equals(const IdleAsyncValue<Exception, List<int>>()),
    );
  });

  group('initialize', () {
    test(
      'When the initialize method is called '
      'Then notifies a $LoadingAsyncValue and a $SuccessAsyncValue',
      () async {
        final asyncValues = <AsyncValue<Exception, List<int>>>[];
        void listener() => asyncValues.add(logic.notifier.value);
        logic.notifier.addListener(listener);
        await logic.initialize();
        logic.notifier.removeListener(listener);
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
    test("Given the notify's value is a $SuccessAsyncValue "
        'When the filter method is called '
        'Then notifies a $SuccessAsyncValue', () async {
      (logic as ValuesLogicByValueNotifier).notifier.value = SuccessAsyncValue(
        List.unmodifiable(Iterable.generate(100, (index) => index + 1)),
      );
      final asyncValues = <AsyncValue<Exception, List<int>>>[];
      void listener() => asyncValues.add(logic.notifier.value);
      logic.notifier.addListener(listener);
      await logic.filter();
      logic.notifier.removeListener(listener);
      expect(
        asyncValues,
        allOf([
          hasLength(1),
          contains(
            isA<SuccessAsyncValue<Exception, List<int>>>().having(
              (e) => e.value,
              'value',
              allOf([
                hasLength(6),
                containsAllInOrder(const [5, 7, 8, 9, 10, 11]),
              ]),
            ),
          ),
        ]),
      );
    });
  });
}
