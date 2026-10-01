import 'package:dynamic_filter/domain/specification/impl/leaf_specification.dart';
import 'package:dynamic_filter/domain/specification/requests/specification_request.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filter_logic/filter_logic.dart';
import 'package:flutter/foundation.dart';

final class FilterLogicImpl implements FilterLogic {
  final ValueNotifier<Specification<int>?> _notifier;

  FilterLogicImpl() : _notifier = ValueNotifier(null);

  @override
  ValueNotifier<Specification<int>?> get notifier => _notifier;

  @visibleForTesting
  void setNotifier(Specification<int>? specification) {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    if (kDebugMode) print('\x1B[35m$runtimeType{State: $specification}\x1B[0m');
    _notifier.value = specification;
  }

  @override
  void filterByDefault() {
    final equalTo5 = LeafSpecification<int>(
      (e) => e == 5,
      description: 'x = 5',
    );
    final higherThan6 = LeafSpecification<int>(
      (e) => e > 6,
      description: 'x > 6',
    );
    final lowerThan12 = LeafSpecification<int>(
      (e) => e < 12,
      description: 'x < 12',
    );
    setNotifier(equalTo5.or(higherThan6.and(lowerThan12)));
  }

  @override
  void delete(Specification<int> specification) {
    specification.handle(DeleteSpecificationRequest(specification));
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    (_notifier as ChangeNotifier).notifyListeners();
  }

  @override
  void reset() => _notifier.value = null;

  @override
  void dispose() => _notifier.dispose();
}
