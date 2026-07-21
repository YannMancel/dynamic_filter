import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/impl/values_logic_impl.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValuesLogic valuesLogic;

  setUp(() => valuesLogic = ValuesLogicImpl());

  tearDown(() => valuesLogic.dispose());

  test('should have an initial $AsyncValue equals to $IdleAsyncValue', () {
    expect(
      valuesLogic.notifier.value,
      equals(const IdleAsyncValue<Exception, List<int>>()),
    );
  });

  group('initialize', () {
    test(
      'When the initialize method is called '
      'Then notifies a $LoadingAsyncValue and a $SuccessAsyncValue',
      () async {
        final asyncValues = <AsyncValue<Exception, List<int>>>[];
        void listener() => asyncValues.add(valuesLogic.notifier.value);
        valuesLogic.notifier.addListener(listener);
        await valuesLogic.initialize();
        valuesLogic.notifier.removeListener(listener);
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
}
