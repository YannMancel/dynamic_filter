import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/async_value/async_value_state_machine.dart';
import 'package:dynamic_filter/domain/async_value/async_value_transition.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/filtered_values_logic/filtered_values_logic.dart';
import 'package:flutter/foundation.dart';

final class FilteredValuesLogicImpl implements FilteredValuesLogic {
  FilteredValuesLogicImpl({
    required this._valuesNotifier,
    required this._filterNotifier,
  }) : _notifier = ValueNotifier(const IdleAsyncValue());

  final ValueNotifier<AsyncValue<Exception, List<int>>> _valuesNotifier;
  final ValueNotifier<Specification<int>?> _filterNotifier;
  final ValueNotifier<AsyncValue<Exception, List<int>>> _notifier;

  @override
  ValueNotifier<AsyncValue<Exception, List<int>>> get notifier => _notifier;

  @override
  Future<void> initialize() async {
    _listener();
    _valuesNotifier.addListener(_listener);
    _filterNotifier.addListener(_listener);
  }

  Specification<int>? get _specificationOrNull => _filterNotifier.value;

  Future<void> _listener() async {
    setNotifier(
      await _valuesNotifier.value.maybeWhen(
        success: (values) async {
          return generateAsyncValueStateMachine<Exception, List<int>>(
                _notifier.value,
                onError: (error, _) async => FailureAsyncValue(
                  error is Exception ? error : Exception('$error'),
                ),
              )
              .applyOrThrow((_) async => const LoadingAsyncValueTransition())
              .peek(setNotifier)
              .applyOrThrow(
                (_) async => SuccessAsyncValueTransition(
                  List.unmodifiable(
                    values.where(
                      (p) => _specificationOrNull?.isSatisfiedBy(p) ?? true,
                    ),
                  ),
                ),
              )
              .state();
        },
        orElse: () => _valuesNotifier.value,
      ),
    );
  }

  @visibleForTesting
  void setNotifier(AsyncValue<Exception, List<int>> value) {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    if (_notifier.value == value) return;
    if (kDebugMode) print('\x1B[36m$runtimeType{State: $value}\x1B[0m');
    _notifier.value = value;
  }

  @override
  void dispose() {
    _valuesNotifier.removeListener(_listener);
    _filterNotifier.removeListener(_listener);
    _notifier.dispose();
  }
}
