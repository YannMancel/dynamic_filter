import 'package:dynamic_filter/domain/state_machine/async_state_machine.dart';
import 'package:dynamic_filter/domain/state_machine/state_transition_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/exception_fixtures.dart';
import '../../fixtures/state_machine_fixtures.dart';

void main() {
  test('should have an initial state equals to A', () async {
    final asyncStateMachine = AsyncStateMachine(
      () async => 'A',
      transitionsByState: const {},
    );
    await expectLater(asyncStateMachine.state(), completion(equals('A')));
  });

  group('applyOrThrow', () {
    test('Given the current state is equal to A '
        'When the $ToB transition is apply '
        'Then the new state is equals to B', () async {
      final asyncStateMachine =
          AsyncStateMachine(
                () async => 'A',
                transitionsByState: const {
                  String: {ToB},
                },
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const ToB())
              .peek(debugPrintState);
      await expectLater(asyncStateMachine.state(), completion(equals('B')));
    });

    test('Given the current state is equal to A '
        'And no transition is provided for String key into '
        'transitionsByState argument '
        'When the $ToD transition is apply '
        'Then a $StateTransitionException is thrown', () async {
      const transitionsByState = <Type, Set<Type>>{String: {}};
      expect(transitionsByState[String]!.contains(ToD), isFalse);
      final asyncStateMachine =
          AsyncStateMachine(
                () async => 'A',
                transitionsByState: transitionsByState,
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const ToD())
              .peek(debugPrintState);
      await expectLater(
        asyncStateMachine.state(),
        throwsA(
          isA<StateTransitionException>().having(
            (e) => e.message,
            'message',
            equals(
              'ToD is not enable for String into '
              'the mapping state/transitions.',
            ),
          ),
        ),
      );
    });

    test('Given the current state is equal to A '
        'And no key is provided into transitionsByState argument '
        'When the $ToD transition is apply '
        'Then a $StateTransitionException is thrown', () async {
      const transitionsByState = <Type, Set<Type>>{};
      expect(transitionsByState[String], isNull);
      final asyncStateMachine =
          AsyncStateMachine(
                () async => 'A',
                transitionsByState: transitionsByState,
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const ToD())
              .peek(debugPrintState);
      await expectLater(
        asyncStateMachine.state(),
        throwsA(
          isA<StateTransitionException>().having(
            (e) => e.message,
            'message',
            equals('String is not a key into the mapping state/transitions.'),
          ),
        ),
      );
    });

    test('Given the current state is equal to A '
        'When the $ToB transition is apply '
        'And the $ToC transition is apply '
        'Then the new state is equals to C', () async {
      final asyncStateMachine =
          AsyncStateMachine(
                () async => 'A',
                transitionsByState: const {
                  String: {ToB, ToC},
                },
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const ToB())
              .peek(debugPrintState)
              .applyOrThrow((_) async => const ToC())
              .peek(debugPrintState);
      await expectLater(asyncStateMachine.state(), completion(equals('C')));
    });
  });

  group('peek', () {
    test('Given the current state is equal to A '
        'When the $ToB transition is apply '
        'And the $ToC transition is apply '
        'Then the state pass from A to B to C', () async {
      final buffer = StringBuffer();
      await AsyncStateMachine(
            () async => 'A',
            transitionsByState: const {
              String: {ToB, ToC},
            },
          )
          .peek((state) => buffer.write('A '))
          .applyOrThrow((_) async => const ToB())
          .peek((state) => buffer.write('-> B '))
          .applyOrThrow((_) async => const ToC())
          .peek((state) => buffer.write('-> C'))
          .state();
      expect(buffer.toString(), equals('A -> B -> C'));
    });
  });

  group('state', () {
    test('Given the guarded $AsyncStateMachine throws a $FakeException '
        'When the state method is called to convert to another '
        '$AsyncStateMachine '
        'Then all next methods are ignored '
        'And it returns Error', () async {
      final asyncStateMachine =
          AsyncStateMachine.guarded(
                () async => throw fakeException,
                transitionsByState: const {
                  String: {ToB},
                },
                onError: (_, _) async => 'Error',
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => const ToB())
              .peek(debugPrintState);
      await expectLater(asyncStateMachine.state(), completion(equals('Error')));
    });

    test('Given the current state is equal to A '
        'When the state method is called to convert to another '
        '$AsyncStateMachine '
        'And a $FakeException is throws during the process '
        'Then all next methods are ignored '
        'And it returns Error', () async {
      final asyncStateMachine =
          AsyncStateMachine.guarded(
                () async => 'A',
                transitionsByState: const {},
                onError: (_, _) async => 'Error',
              )
              .peek(debugPrintState)
              .applyOrThrow((_) async => throw fakeException)
              .peek(debugPrintState);
      await expectLater(asyncStateMachine.state(), completion(equals('Error')));
    });
  });
}
