import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/filter/implementations/leaf_filter.dart';
import 'package:dynamic_filter/domain/rule/filter_extension.dart';
import 'package:dynamic_filter/domain/rule/filter_request.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/foundation.dart';

final class FilterLogicImpl implements FilterLogic {
  final ValueNotifier<Filter<int>?> _notifier;

  FilterLogicImpl() : _notifier = ValueNotifier(null);

  @override
  ValueNotifier<Filter<int>?> get notifier => _notifier;

  @visibleForTesting
  void setNotifier(Filter<int>? filter) {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    if (kDebugMode) print('\x1B[35m$runtimeType{State: $filter}\x1B[0m');
    _notifier.value = filter;
  }

  @override
  void filterByDefault() {
    final equalTo5 = LeafFilter<int>((e) => e == 5, description: 'x = 5');
    final higherThan6 = LeafFilter<int>((e) => e > 6, description: 'x > 6');
    final lowerThan12 = LeafFilter<int>((e) => e < 12, description: 'x < 12');
    setNotifier(equalTo5.or(higherThan6.and(lowerThan12)));
  }

  @override
  void delete(Filter<int> filter) {
    _notifier.value = _notifier.value
        ?.convertToRuleUntilTarget(filter)
        ?.handle(DeleteFilterRequest(filter))
        .when(
          empty: () => null,
          same: (filter) => filter,
          update: (filter) => filter,
        );
  }

  @override
  void dispose() => _notifier.dispose();
}
