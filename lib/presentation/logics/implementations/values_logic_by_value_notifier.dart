import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/async_value/async_value_state_machine.dart';
import 'package:dynamic_filter/domain/async_value/async_value_transition.dart';
import 'package:dynamic_filter/domain/specification/implementations/leaf_specification.dart';
import 'package:dynamic_filter/domain/specification/specification.dart';
import 'package:dynamic_filter/presentation/logics/values_logic.dart';
import 'package:flutter/foundation.dart';

final class ValuesLogicByValueNotifier implements ValuesLogic {
  ValuesLogicByValueNotifier()
    : _notifier = ValueNotifier(const IdleAsyncValue());

  final ValueNotifier<AsyncValue<Exception, List<int>>> _notifier;

  @override
  ValueNotifier<AsyncValue<Exception, List<int>>> get notifier => _notifier;

  @override
  Future<void> initialize() async {
    final stateMachine = _getStateMachine(_notifier.value)
        .applyOrThrow((_) async => const LoadingAsyncValueTransition())
        .peek(setNotifier)
        .applyOrThrow(
          (_) async => SuccessAsyncValueTransition(
            List.unmodifiable(Iterable.generate(100, (index) => index + 1)),
          ),
        );
    setNotifier(await stateMachine.state());
  }

  AsyncValueStateMachine<Exception, List<int>> _getStateMachine(
    AsyncValue<Exception, List<int>> value,
  ) {
    return AsyncValueStateMachine<Exception, List<int>>.guarded(
      () async => value,
      transitionsByState:
          AsyncValueTransition.getTransitionsByState<Exception, List<int>>(),
      onError: (error, _) async =>
          FailureAsyncValue(error is Exception ? error : Exception('$error')),
    );
  }

  @visibleForTesting
  void setNotifier(AsyncValue<Exception, List<int>> value) {
    if (kDebugMode) print('$runtimeType{State: $value}');
    _notifier.value = value;
  }

  @override
  Future<void> filter() async {
    await _notifier.value.maybeWhen(
      success: (values) async {
        final specification = _generateSpecification();
        final stateMachine = _getStateMachine(_notifier.value).applyOrThrow(
          (_) async => SuccessAsyncValueTransition(
            List.unmodifiable(
              values.where((p) => specification.isSatisfiedBy(p)),
            ),
          ),
        );
        setNotifier(await stateMachine.state());
      },
      orElse: () {
        /* Do nothing here */
      },
    );
  }

  Specification<int> _generateSpecification() {
    final equalTo5 = LeafSpecification<int>(
      (e) => e == 5,
      description: 'x == 5',
    );
    final higherThan6 = LeafSpecification<int>(
      (e) => e > 6,
      description: 'x > 6',
    );
    final lowerThan12 = LeafSpecification<int>(
      (e) => e < 12,
      description: 'x < 12',
    );
    final specification = equalTo5.or(higherThan6.and(lowerThan12));
    if (kDebugMode) print('Specification: $specification');
    return specification;
  }

  @override
  void dispose() => _notifier.dispose();
}
