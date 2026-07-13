import 'package:dynamic_filter/domain/state_machine/state_transition.dart';
import 'package:dynamic_filter/domain/state_machine/state_transition_exception.dart';
import 'package:flutter/foundation.dart';

typedef _OnError<S> = Future<S> Function(dynamic error, StackTrace stackTrace);

/// [AsyncStateMachine] allows to manage asynchronous [S] state via [T]
/// transition callback.
///
/// For example:
/// ```dart
/// final asyncStateMachine = AsyncStateMachine<String, StringTransition>.guarded(
///   () async => 'A',
///   transitionsByState: const {
///     String: {ToB, ToC, ToD},
///   },
///   onError: (error, _) async => '$error',
/// );
///
/// final message = await asyncStateMachine
///   .applyOrThrow((_) async => const ToB())
///   .applyOrThrow((_) async {
///     final either = await getUser('42');
///     return either.fold(
///       left: (exception) => ToC(exception),
///       right: (user) => ToD(user),
///     );
///   })
///   .state();
/// ```
final class AsyncStateMachine<S, T extends StateTransition<S>> {
  const AsyncStateMachine(
    this._callback, {
    required this._transitionsByState,
    this._onError,
  });

  const AsyncStateMachine.guarded(
    this._callback, {
    required this._transitionsByState,
    required this._onError,
  });

  final ValueGetter<Future<S>> _callback;
  final Map<Type, Set<Type>> _transitionsByState;
  final _OnError<S>? _onError;

  /// Allows to complete the [AsyncStateMachine] to retrieve the asynchronous
  /// [S] state.
  ///
  /// ```dart
  /// final state = await asyncStateMachine.state();
  /// ```
  Future<S> state() {
    return _callback().catchError((error, stackTrace) async {
      final stateOrNull = await _onError?.call(error, stackTrace);
      if (stateOrNull == null) throw error;
      return stateOrNull;
    });
  }

  /// According to the completion of [T] transition, there is 2 possibilities.
  /// Either the transition is valid or a [StateTransitionException] is thrown.
  ///
  /// ```dart
  /// asyncStateMachine
  ///   .applyOrThrow((_) async => const ToB())
  ///   .applyOrThrow((_) async {
  ///     final either = await getUser('42');
  ///     return either.fold(
  ///       left: (exception) => ToC(exception),
  ///       right: (user) => ToD(user),
  ///     );
  ///   });
  /// ```
  AsyncStateMachine<S, T> applyOrThrow(Future<T> Function(S) callback) {
    return AsyncStateMachine<S, T>(
      () => _callback().then(
        (state) => callback(
          state,
        ).then((transition) => _transitionOrThrow(state, transition)),
      ),
      transitionsByState: _transitionsByState,
      onError: _onError,
    );
  }

  S _transitionOrThrow(S state, T transition) {
    _validateOrThrow(state, transition);
    return transition.nextState;
  }

  void _validateOrThrow(S state, T transition) {
    _validateStateTypeOrThrow(state);
    _validateTransitionOrThrow(state, transition);
  }

  void _validateStateTypeOrThrow(S state) {
    final stateType = state.runtimeType;
    if (!_transitionsByState.containsKey(stateType)) {
      throw StateTransitionException(
        '$stateType is not a key into the mapping state/transitions.',
      );
    }
  }

  void _validateTransitionOrThrow(S state, T transition) {
    final transitionType = transition.runtimeType;
    final stateType = state.runtimeType;
    if (!_transitionsByState[stateType]!.toList().contains(transitionType)) {
      throw StateTransitionException(
        '$transitionType is not enable for $stateType '
        'into the mapping state/transitions.',
      );
    }
  }

  /// Allows to expose the current [S] state during chain processing without
  /// causing any side effects.
  ///
  /// ```dart
  /// asyncStateMachine
  ///   .peek((state) => print('State: $state'))
  ///   .applyOrThrow((_) async => const ToB())
  /// ```
  AsyncStateMachine<S, T> peek(ValueSetter<S> callback) {
    return AsyncStateMachine<S, T>(
      () => _callback().then((state) {
        callback(state);
        return state;
      }),
      transitionsByState: _transitionsByState,
      onError: _onError,
    );
  }
}
