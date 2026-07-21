import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/impl/filter_logic_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FilterLogic filterLogic;

  setUp(() => filterLogic = FilterLogicImpl());

  tearDown(() => filterLogic.dispose());

  test('should have an initial value equals to null', () {
    expect(filterLogic.notifier.value, isNull);
  });

  group('update', () {
    test('When the update method is called '
        'Then notifies a $Specification', () {
      final specifications = <Specification?>[];
      void listener() => specifications.add(filterLogic.notifier.value);
      filterLogic.notifier.addListener(listener);
      filterLogic.update();
      filterLogic.notifier.removeListener(listener);
      expect(
        specifications,
        allOf([
          hasLength(1),
          contains(
            isA<Specification<int>>().having(
              (e) => e.toString(),
              'specification',
              equals('(x == 5 || (x > 6 && x < 12))'),
            ),
          ),
        ]),
      );
    });
  });
}
