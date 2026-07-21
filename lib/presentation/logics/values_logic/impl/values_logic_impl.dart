import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/async_value/async_value_state_machine.dart';
import 'package:dynamic_filter/domain/async_value/async_value_transition.dart';
import 'package:dynamic_filter/presentation/logics/values_logic/values_logic.dart';
import 'package:flutter/foundation.dart';

final class ValuesLogicImpl implements ValuesLogic {
  ValuesLogicImpl() : _notifier = ValueNotifier(const IdleAsyncValue());

  final ValueNotifier<AsyncValue<Exception, List<int>>> _notifier;

  @override
  ValueNotifier<AsyncValue<Exception, List<int>>> get notifier => _notifier;

  @override
  Future<void> initialize() async {
    setNotifier(
      await generateAsyncValueStateMachine<Exception, List<int>>(
            _notifier.value,
            onError: (error, _) async => FailureAsyncValue(
              error is Exception ? error : Exception('$error'),
            ),
          )
          .applyOrThrow((_) async => const LoadingAsyncValueTransition())
          .peek(setNotifier)
          .applyOrThrow(
            (_) async => SuccessAsyncValueTransition(
              List.unmodifiable(Iterable.generate(100, (index) => index + 1)),
            ),
          )
          .state(),
    );
  }

  @visibleForTesting
  void setNotifier(AsyncValue<Exception, List<int>> value) {
    assert(ChangeNotifier.debugAssertNotDisposed(_notifier));
    if (_notifier.value == value) return;
    if (kDebugMode) print('\x1B[32m$runtimeType{State: $value}\x1B[0m');
    _notifier.value = value;
  }

  @override
  void dispose() => _notifier.dispose();
}
