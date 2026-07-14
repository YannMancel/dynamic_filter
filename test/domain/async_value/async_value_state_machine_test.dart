import 'package:dynamic_filter/domain/async_value/async_value.dart';
import 'package:dynamic_filter/domain/async_value/async_value_state_machine.dart';
import 'package:dynamic_filter/domain/async_value/async_value_transition.dart';
import 'package:dynamic_filter/domain/state_machine/state_transition_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/exception_fixtures.dart';
import '../../fixtures/state_machine_fixtures.dart';

void main() {
  test('should have an initial state equals to $IdleAsyncValue', () async {
    final asyncStateMachine = AsyncValueStateMachine<FakeException, int>(
      () async => const IdleAsyncValue(),
      transitionsByState:
          AsyncValueTransition.getTransitionsByState<FakeException, int>(),
    );
    await expectLater(
      asyncStateMachine.state(),
      completion(equals(const IdleAsyncValue<FakeException, int>())),
    );
  });

  group('applyOrThrow', () {
    test('Given the current state is equal to $IdleAsyncValue '
        'When the $LoadingAsyncValueTransition transition is apply '
        'Then the new state is equals to $LoadingAsyncValue', () async {
      final asyncStateMachine =
          AsyncValueStateMachine<FakeException, int>(
                () async => const IdleAsyncValue(),
                transitionsByState:
                    AsyncValueTransition.getTransitionsByState<
                      FakeException,
                      int
                    >(),
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const LoadingAsyncValueTransition())
              .peek(debugPrintState);
      await expectLater(
        asyncStateMachine.state(),
        completion(equals(const LoadingAsyncValue<FakeException, int>())),
      );
    });

    test('Given the current state is equal to $IdleAsyncValue '
        'When the $SuccessAsyncValueTransition transition is apply '
        'Then a $StateTransitionException is thrown', () async {
      final asyncStateMachine =
          AsyncValueStateMachine<FakeException, int>(
                () async => const IdleAsyncValue(),
                transitionsByState:
                    AsyncValueTransition.getTransitionsByState<
                      FakeException,
                      int
                    >(),
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const SuccessAsyncValueTransition(1))
              .peek(debugPrintState);
      await expectLater(
        asyncStateMachine.state(),
        throwsA(
          isA<StateTransitionException>().having(
            (e) => e.message,
            'message',
            equals(
              'SuccessAsyncValueTransition<FakeException, int> is not enable '
              'for IdleAsyncValue<FakeException, int> into the mapping '
              'state/transitions.',
            ),
          ),
        ),
      );
    });

    test('Given the current state is equal to $IdleAsyncValue '
        'When the $LoadingAsyncValueTransition transition is apply '
        'And the $SuccessAsyncValueTransition transition is apply '
        'Then the new state is equals to $SuccessAsyncValue', () async {
      final asyncStateMachine =
          AsyncValueStateMachine<FakeException, int>(
                () async => const IdleAsyncValue(),
                transitionsByState:
                    AsyncValueTransition.getTransitionsByState<
                      FakeException,
                      int
                    >(),
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const LoadingAsyncValueTransition())
              .peek(debugPrintState)
              .applyOrThrow((_) async => const SuccessAsyncValueTransition(1))
              .peek(debugPrintState);
      await expectLater(
        asyncStateMachine.state(),
        completion(equals(const SuccessAsyncValue<FakeException, int>(1))),
      );
    });
  });

  group('peek', () {
    test('Given the current state is equal to $IdleAsyncValue '
        'When the $LoadingAsyncValueTransition transition is apply '
        'And the $SuccessAsyncValueTransition transition is apply '
        'Then the state pass from $IdleAsyncValue to $LoadingAsyncValue to'
        '$SuccessAsyncValue', () async {
      final buffer = StringBuffer();
      await AsyncValueStateMachine<FakeException, int>(
            () async => const IdleAsyncValue(),
            transitionsByState:
                AsyncValueTransition.getTransitionsByState<
                  FakeException,
                  int
                >(),
          )
          .peek((state) => buffer.writeln('$state'))
          .applyOrThrow((_) async => const LoadingAsyncValueTransition())
          .peek((state) => buffer.writeln('$state'))
          .applyOrThrow((_) async => const SuccessAsyncValueTransition(1))
          .peek((state) => buffer.write('$state'))
          .state();
      expect(
        buffer.toString(),
        equals(
          'IdleAsyncValue<FakeException, int>\n'
          'LoadingAsyncValue<FakeException, int>\n'
          'SuccessAsyncValue<FakeException, int>{value: 1}',
        ),
      );
    });
  });
}
